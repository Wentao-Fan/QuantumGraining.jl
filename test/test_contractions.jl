using Revise
using QuantumCumulants
using SymbolicUtils
using IterTools
using Symbolics
#using Test

#@testset "contractions" begin
module Tst
    using Test
    using IterTools
    include("../src/diagrams.jl")
    include("../src/poles.jl")
    include("../src/contractions.jl")
    include("../src/printing.jl")
    include("../src/expressions.jl")

    ## problem definition ##    
    num_bubbles = 2
    @cnumbers a b c
    μ1 = [0, a, -a] # pole at 1 and 3
    ν1 = [a, -a, b, c] # pole at 2

    μ2 = [a, b, c, -(a+b+c)] # pole at 4
    ν2 = [3*c, 2*b] # no poles

    ω = [(μ1, ν1), (μ2, ν2)]

    s_list = [[1, 3], [4]]
    stag_list = [[2], []]  # singular indices
    total_num_poles = 4
    
    num_vars = 3*num_bubbles
    num_sols = binomial(total_num_poles + num_vars - 1, num_vars - 1)
    sols = find_integer_solutions(3*num_bubbles, total_num_poles)     
    unl_list = reshape_sols(sols, total_num_poles, num_bubbles)           # partition for the inner sum

    ## singular_expansion & calculate_bubble_factor() - bubble 1 ##
    s = s_list[1]
    stag = stag_list[1]
    
    @show s, stag
    t1 = singular_expansion(μ1, ν1, unl_list[:, 1], s, stag)
    t2 = calculate_bubble_factor(ω, 1, unl_list[:, 1], s, stag)

    #= 
        contraction_coeff
    =#
    left = 1
    right = 2
    μ1 = [0] 
    ν1 = [1, 1]
    ω = [μ1..., ν1...]
    split_freqs_into_bubbles(ω, [(left, right)])
    c, c_list = contraction_coeff((left, right), ω)
    @show c_list
    @show c

    @cnumbers ω_1 ω_3
    c, cs = contraction_coeff((2,0),[ω_1,ω_3])

end


#=
end #testset
=#