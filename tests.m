
classdef tests < matlab.unittest.TestCase

    properties (Access = private)
        TOL = 1e-9;
    end

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
            uSolver = str.compute();
            actualSolution = uSolver ;
            error = testCase.computeRealitveError(actualSolution,expectedSolution);

            if error < testCase.TOL
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function iterativeDisplacements(testCase)
            expectedSolution = load('Displacements.mat','u').u ;
            s.solverType = 'Iterative';
            str = StructuralComputer(s);
            uSolver = str.compute();
            actualSolution = uSolver ;
            error = testCase.computeRealitveError(actualSolution,expectedSolution);
            if error < testCase.TOL
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function reactions(testCase)
            expectedSolution = load("Reactions.mat").R ;
            actualSolution = evalin('base','R') ;
            error = testCase.computeRealitveError(actualSolution,expectedSolution);
            if error < testCase.TOL
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function epsilon(testCase)
            expectedSolution = load("Epsilon.mat").eps ;
            actualSolution = evalin('base','eps') ;
            error = testCase.computeRealitveError(actualSolution,expectedSolution);
            if error < testCase.TOL
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

        function sigma(testCase)
            expectedSolution = load("Sigma.mat").sig ;
            actualSolution = evalin('base','sig') ;
            error = testCase.computeRealitveError(actualSolution,expectedSolution);
            if error < testCase.TOL
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end



        function sigmaCritica(testCase)
            expectedSolution = load("Sigma_critica.mat").sig_cr ;
            actualSolution = evalin('base','sig_cr') ;
            error = testCase.computeRealitveError(actualSolution,expectedSolution);
            if error < testCase.TOL
                actualSolution = expectedSolution ;
            end
            testCase.verifyEqual(actualSolution,expectedSolution);
        end

    end

    methods (Access = private)

        function err = computeRealitveError(testCase,a,b)
            absErr = abs((a-b)/b) ;
            err = norm(absErr)/norm(a(:));
        end        

    end


end