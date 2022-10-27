using QuantumGraining
#using QuantumCumulants
#using Test

#@testset "contractions" begin
module Tst
    using Test
    include("../src/diagrams.jl")
    include("../src/contractions.jl")
    include("../src/printing.jl")

    diagram = [(3, 4), (2, 1)]
    for (i, bubble) in enumerate(diagram)
        println("bubble $i: ($(bubble[1]), $(bubble[2])) ")
        println("----")
    end

    @definemodes diagram[1][1] diagram[1][2]
    @show μ
    @show ν
    @show τ

    @definemodes diagram[2][1] diagram[2][2]
    @show μ
    @show ν

    umax, dmax = _maxmodes(diagram)                       # to avoid redundancy, we find the maximum amount of participating modes
    @show umax
    @show dmax
    @definemodes umax dmax                                # define all the participating modes as symbols

    @definemodes diagram
    c = calculate_coeff(diagram)
    @show c
end

# if denominator goes to zero -> take limit


#=
end #testset
=#