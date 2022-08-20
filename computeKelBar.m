function Kel = computeKelBar(n_d,n_el,x,Tn,mat,Tmat)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_d        Problem's dimensions
%                  n_el       Total number of elements
%   - x     Nodal coordinates matrix [n x n_d]
%            x(a,i) - Coordinates of node a in the i dimension
%   - Tn    Nodal connectivities table [n_el x n_nod]
%            Tn(e,a) - Nodal number associated to node a of element e
%   - mat   Material properties table [Nmat x NpropertiesXmat]
%            mat(m,1) - Young modulus of material m
%            mat(m,2) - Section area of material m
%   - Tmat  Material connectivities table [n_el]
%            Tmat(e) - Material index of element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------

n_nod = size(Tn,2) ;  
n_el_dof = n_d*n_nod ;
Kel = zeros(n_el_dof,n_el_dof,n_el) ;


for i = 1:n_el
    node1 = Tn(i,1) ;
    node2 = Tn(i,2) ;
    x1 = x(node1,1) ;
    y1 = x(node1,2) ;
    x2 = x(node2,1) ;
    y2 = x(node2,2) ;
    l = ((x2-x1)^2+(y2-y1)^2)^0.5 ;
    s = (y2-y1)/l ;
    c = (x2-x1)/l ;
    material = Tmat(i) ;
    Kel(:,:,i) = [
        c^2 c*s -(c^2) -c*s ;
        c*s s^2 -c*s -(s^2) ;
        -(c^2) -c*s c^2 c*s ;
        -c*s -(s^2) c*s s^2
        ] * mat(material,2) * mat(material,1) / l ;
end



end