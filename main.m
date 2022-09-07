s.solverType = 'Direct';
str = StructuralComputer(s);
[u,R,KG,Fext,eps,sig] = str.compute();


 %% TESTS
 results = runtests('tests.m') ;
