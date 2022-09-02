
classdef Solver < handle
    properties
    end

    methods (Static)
        function sol = chooseMode(mode)
            switch mode
                case "Direct"
                    sol = DirectSolver ;
                case "Iterative"
                    sol = IterativeSolver ;
            end
        end

    end


end