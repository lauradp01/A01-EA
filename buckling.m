function sig_cr = buckling(n_el,Td,x,Tn,mat)

n_el_dof = size(Td,2) ;
u_e = zeros(n_el_dof,1) ;

sig_cr = zeros(n_el,1) ;

for i = 1:n_el 
    x1 = x(Tn(i,1),1) ;
    y1 = x(Tn(i,1),2) ;
    x2 = x(Tn(i,2),1) ;
    y2 = x(Tn(i,2),2) ;

    l = ((x2-x1)^2+(y2-y1)^2)^0.5 ;
    sig_cr(i) = pi^2 * mat(1) * mat(4) / (l^2 * mat(2)) ;

end

end