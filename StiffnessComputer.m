classdef StiffnessComputer < handle
   
    properties (Access = private)
        n_d
        n_el
        x
        Tn
        mat
        Tmat
    end

    methods (Access = public)
        function obj = StiffnessComputer(cParams)
           obj.init(cParams);
        end

        function Kel = compute(obj)
            nDim = obj.n_d ;
            nElem = obj.n_el ;
            coord = obj.x ;
            connec = obj.Tn ;
            materialData = obj.mat ;
            materialConnec = obj.Tmat ;
            
            n_nod = size(connec,2) ;  
            n_el_dof = nDim*n_nod ;
            Kel = zeros(n_el_dof,n_el_dof,nElem) ;
                    
            for i = 1:nElem
                node1 = connec(i,1) ;
                node2 = connec(i,2) ;
                x1 = coord(node1,1) ;
                y1 = coord(node1,2) ;
                x2 = coord(node2,1) ;
                y2 = coord(node2,2) ;
                l = ((x2-x1)^2+(y2-y1)^2)^0.5 ;
                s = (y2-y1)/l ;
                c = (x2-x1)/l ;
                material = materialConnec(i) ;
                Kel(:,:,i) = [
                    c^2 c*s -(c^2) -c*s ;
                    c*s s^2 -c*s -(s^2) ;
                    -(c^2) -c*s c^2 c*s ;
                    -c*s -(s^2) c*s s^2
                    ] * materialData(material,2) * materialData(material,1) / l ;
            end
         end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_d = cParams.n_d ;
            obj.n_el = cParams.n_el ;
            obj.x = cParams.x ;
            obj.Tn = cParams.Tn ;
            obj.mat = cParams.mat ;
            obj.Tmat = cParams.Tmat ;
        end
        
        
    end

    
end