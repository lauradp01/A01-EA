function [vL,vR,uR] = applyCond(n_i,n_dof,fixNod)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i      Number of DOFs per node
%                  n_dof    Total number of DOFs
%   - fixNod  Prescribed displacements data [Npresc x 3]
%              fixNod(k,1) - Node at which the some DOF is prescribed
%              fixNod(k,2) - DOF (direction) at which the prescription is applied
%              fixNod(k,3) - Prescribed displacement magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - vL      Free degree of freedom vector
%   - vR      Prescribed degree of freedom vector
%   - uR      Prescribed displacement vector
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each displacement is prescribed.

prescribed_dofs = size(fixNod,1) ;

vL = zeros(n_dof-prescribed_dofs,1) ;
vR = zeros(prescribed_dofs,1) ;
uR = zeros(prescribed_dofs,1) ;

a = 0 ;
pos_vL = 1 ;

for i = 1:n_dof
    for j = 1:prescribed_dofs
        if i == fixNod(j,2)
            a = 1 ;
            vR(j) = i ;
            uR(j) = fixNod(j,3) ;
        end
    end
    if a == 0
        vL(pos_vL) = i ;
        pos_vL = pos_vL + 1 ; 
    end
    a = 0 ;
end

end