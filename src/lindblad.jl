"""
Lindblad.jl contains the functionalities to generate the final Lindbladian in operator form.
"""

"""
    repeated_combinations(arr::Array, n::Int)
    
        Given a collection of terms and a number `n`, returns all possible `n` repetitions of the elements in the collection.
"""
# Helper function (NOTE: not sure what the protocol is to steal something from StackOverflow)
repeated_combinations(arr::Vector, n::Int) = 
    [ getindex.(Ref(arr), 1 .+ digits(i-1; base=length(arr), pad=n)) for i=1:length(arr)^n ]


"""
    effective_hamiltonian(k::Int, ω::Array, h::Array)
    
        Given a Hamiltonian as a list of operators and corresponding frequencies,
        returns the effective TCG Hamiltonian up to order `k`.
"""
function effective_hamiltonian(k::Int, ω::Array, h::Array)
    # Functionality to sum over all contractions of up to kth order 
    # w and h are arrays of symbolic cnumbers from QuantumCumulants
    g_list = []
    V_list = []
    h_eff = 0
    ω_list = repeated_combinations(ω, k)
    h_list = repeated_combinations(h, k)
    for i in 1:k
        g = 0
        V = 0
        lc(ω) = (contraction_coeff(k, 0))(ω)                # returns a function of μ and ν
        rc(ω) = (contraction_coeff(0, k))(ω)                
        for (ω, h) in zip(ω_list, h_list) 
            g += 1//2*(lc(ω) + rc(ω))
            V += prod(h) #? 
        end
        push!(g_list, g) 
        push!(V_list, V)
        h_eff += g*V
    end
    return h_eff
    # effective_ham = 0
    # for n in 1:k
    #     ω_list = repeated_combinations(ω,n)
    #     h_list = repeated_combinations(h,n)
    #     effective_ham += sum([effective_hamiltonian(diagram,ω_list,h_list) for diagram in get_diagrams(DiagramNode((n,0)))])    
    # end
    # return effective_ham
end


# function effective_hamiltonian(diagram, ω_list::Array, h_list::Array)
#     effective_ham = 0 
#     @definemodes μ get_max_modes(diagram)[1]
#     #@definemodes ν get_max_modes(diagram)[2]
#     C0, C0_list = calculate_coeff(μ,[],τ,diagram)
#     for j in range(1, length(ω_list), length(ω_list))
#         freqs = ω_list[j]
#         g = (substitute(C0, Dict(μ .=> freqs)) + substitute(C0, Dict(μ .=> -reverse(freqs)))/2)*exp(1im*τ*sum(freqs))
#         effective_ham += g*prod(h_list[j])
#     end
#     return effective_ham
# end

# """
# * effective_dissipator(c::Tuple{int, int}) - Given a contraction, returns all contributing terms.
# * effective_dissipator(d::Diagram) - Given a diagram object, returns all contributing terms.
# * effective_dissipator(d::Array{Tuple{Int, Int}}) - Given a diagram in an array format, returns all contributing terms.
# """

# function effective_dissipator(k::Int, ω::Array, h::Array, fmt=:QuantumCumulants)

#     effective_disp = []

#     for n in range 1:k   
#         ω_list = repeated_combinations(ω,n)
#         h_list = repeated_combinations(h,n)
#         for m in 0:n
#             effective_disp_rate = 0
#             for diagram in get_diagrams(DiagramNode((n-m,m)))     
#                 effective_disp_rate += effective_dissipator_rate(diagram,ω_list) 
#                 rev_diagram = [reverse(bub) for bub in diagram]
#                 effective_disp_rate += effective_dissipator_rate(rev_diagram,-reverse(ω_list)) 
#             end 
#             push!(effective_disp, [effective_disp_rate, (prod(h_list[1:(n-m)]), prod(h_list[n-m+1:n]))]) 
#         end
#     end
#     return effective_disp
# end



# function effective_dissipator_rate(diagram::Array{Tuple{Int, Int}}, ω_list::Array)
#     effective_disp = 0
#     @definemodes μ get_max_modes(diagram)[1]
#     @definemodes ν get_max_modes(diagram)[2]
#     C0, C0_list = calculate_coeff(μ,[],τ,diagram)
#     for j in range(1, length(ω_list), length(ω_list))
#         freqs = ω_list[j]
#         effective_disp +=  substitute(C0, Dict(μ .=> freqs[1:length(μ)], ν .=> freqs[length(μ):length(freqs)]))*exp(1im*τ*sum(freqs))
#     end
#     return effective_disp
# end


"""
* effective_lindblad(c::Tuple{int, int}) - Given a contraction, returns all contributing terms.
* effective_lindblad(d::Diagram) - Given a diagram object, returns all contributing terms.
* effective_lindblad(d::Array{Tuple{Int, Int}}) - Given a diagram in an array format, returns all contributing terms.
"""
