
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
            actualSolution = evalin('base','uIterative') ;
            value = abs(actualSolution-expectedSolution) ;
            zero = 10^(-14) ;
            if value < zero
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end
    end

end