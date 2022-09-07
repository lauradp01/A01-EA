s.solverType = 'Direct';
str = StructuralComputer(s);
[u,R,KG,Fext,eps,sig,sig_cr] = str.compute();


 %% TESTS
 results = runtests('tests.m') ;
