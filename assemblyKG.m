function KG = assemblyKG(n_el,n_el_dof,n_dof,Td,Kel)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_el       Total number of elements
%                  n_el_dof   Number of DOFs per element
%                  n_dof      Total number of DOFs
%   - Td    DOFs connectivities table [n_el x n_el_dof]
%            Td(e,i) - DOF i associated to element e
%   - Kel   Elemental stiffness matrices [n_el_dof x n_el_dof x n_el]
%            Kel(i,j,e) - Term in (i,j) position of stiffness matrix for element e
%--------------------------------------------------------------------------
% It must provide as output:
%   - KG    Global stiffness matrix [n_dof x n_dof]
%            KG(I,J) - Term in (I,J) position of global stiffness matrix
%--------------------------------------------------------------------------

KG = zeros(n_dof,n_dof) ;


for i = 1:n_el
    for j = 1:n_el_dof
        I = Td(i,j) ;
        for a = 1:n_el_dof
            J = Td(i,a) ;
            KG(I,J) = KG(I,J) + Kel(j,a,i) ;
        end
    end
end

end