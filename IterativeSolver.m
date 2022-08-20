classdef IterativeSolver < Solver
    properties
    end

    methods (Static)
        function solution = system(LHS,RHS)
            solution = pcg(RHS,LHS) ; %segons la teoria hauria de ser pcg(LHS,RHS) però dona error
        end
    end
end