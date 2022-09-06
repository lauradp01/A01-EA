
classdef tests < matlab.unittest.TestCase
    
    methods(Test)

        function stiffnessMatrix(testCase)
            expectedSolution = load('StiffnessMatrix.mat','KG').KG ;
            actualSolution = evalin('base','KG') ;
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function totalForce(testCase)
            expectedSolution = load('TotalForce.mat','Fext').Fext ;
            actualSolution = evalin('base','Fext') ;
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function directDisplacements(testCase)
            expectedSolution = load('Displacements.mat','u').u ;

            s.solverType = 'Direct';
            str = StructuralComputer(s);
            [u,K,F] = str.compute();
            actualSolution = evalin('base','uDirect') ;
            value = abs(actualSolution-expectedSolution) ;
            zero = 10^(-14) ;
            if value < zero
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function iterativeDisplacements(testCase)
            expectedSolution = load('Displacements.mat','u').u ;
            s.solverType = 'Iterative';
            str = StructuralComputer(s);
            [u,K,F] = str.compute();

            actualSolution = evalin('base','uIterative') ;
            value = abs(actualSolution-expectedSolution) ;
            zero = 10^(-14) ;
            if value < zero
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function epsilon(testCase)
            expectedSolution = load("Epsilon.mat").eps ;
            actualSolution = evalin('base','eps') ;
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function sigma(testCase)
            expectedSolution = load("Sigma.mat").sig ;
            actualSolution = evalin('base','sig') ;
            testCase.verifyEqual(actualSolution,expectedSolution);
        end
        
%         function sigmaCritica(testCase)
%             expectedSolution = load("Sigma_critica.mat").sig_cr ;
%             actualSolution = evalin('base','sig_cr') ;
%             testCase.verifyEqual(actualSolution,expectedSolution);
%         end
     end

end