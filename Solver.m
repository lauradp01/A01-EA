classdef Solver
    properties
    end

    methods (Static)
        function solution = system(LHS,RHS)
            switch mode
                case 'Direct'
                    solution = RHS\LHS ;
                    
                case 'Iterative'
                    solution = pcg(RHS,LHS) ; 
            end
        end 
    end

end