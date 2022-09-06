s.solverType = 'Direct';
str = StructuralComputer(s);
[u,K,F] = str.compute();


 %% TESTS
 results = runtests('tests.m') ;
