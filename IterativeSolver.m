classdef IterativeSolver < Solver
    properties
    end

    methods (Static)
        function solution = system(LHS,RHS)
            solution = pcg(RHS,LHS) ; 
        end
    end
end