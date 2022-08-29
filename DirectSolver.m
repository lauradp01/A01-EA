
classdef DirectSolver < Solver

    properties
    end

    methods (Static)
        function solution = system(LHS,RHS)
           solution = RHS\LHS ;
        end
    end

end