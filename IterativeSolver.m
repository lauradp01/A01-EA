
classdef IterativeSolver < Solver
    properties
    end

    methods (Static)
        function solution = system(LHS,RHS)
            solution = pcg(RHS,LHS,1e-15) ; 
        end
    end

end