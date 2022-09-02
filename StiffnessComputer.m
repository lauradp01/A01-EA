
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
            Kel = obj.computeKel() ;
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

        function Kel = createKel(obj)
            nDim = obj.n_d ;
            nElem = obj.n_el ;
            connec = obj.Tn ;

            n_nod = size(connec,2) ;  
            n_el_dof = nDim*n_nod ;
            Kel = zeros(n_el_dof,n_el_dof,nElem) ;
        end

        function n = computeNodes(obj,i)
            nElem = obj.n_el ;
            connec = obj.Tn ;
            for i = 1:nElem
                n.node1(i) = connec(i,1) ;
                n.node2(i) = connec(i,2) ;
            end
        end

        function co = computeCoordinates(obj)
            nElem = obj.n_el ;
            coord = obj.x ;
              n = obj.computeNodes() ;
             for i = 1:nElem
                
                co.x1(i) = coord(n.node1(i),1) ;
                co.y1(i) = coord(n.node1(i),2) ;
                co.x2(i) = coord(n.node2(i),1) ;
                co.y2(i) = coord(n.node2(i),2) ;
             end
        end

        function [l,s,c] = computeData(obj) 
            nElem = obj.n_el ;
            co = obj.computeCoordinates() ;
            for i = 1:nElem
                l(i) = ((co.x2(i)-co.x1(i))^2+(co.y2(i)-co.y1(i))^2)^0.5 ;
                s(i) = (co.y2(i)-co.y1(i))/l(i) ;
                c(i) = (co.x2(i)-co.x1(i))/l(i) ;
            end
        end

        function material = computeMaterial(obj)
            nElem = obj.n_el ;
            materialConnec = obj.Tmat ;
            for i = 1:nElem
                material(i) = materialConnec(i) ;
            end
        end

        function Kel = computeKel(obj)
            nElem = obj.n_el ;
            Kel = obj.createKel() ;
            materialData = obj.mat ;
            [l,s,c] = obj.computeData() ;
            material = obj.computeMaterial() ;
            for i = 1:nElem
                Kel(:,:,i) = [
                    c(i)^2 c(i)*s(i) -(c(i)^2) -c(i)*s(i) ;
                    c(i)*s(i) s(i)^2 -c(i)*s(i) -(s(i)^2) ;
                    -(c(i)^2) -c(i)*s(i) c(i)^2 c(i)*s(i) ;
                    -c(i)*s(i) -(s(i)^2) c(i)*s(i) s(i)^2
                    ] * materialData(material(i),2) * materialData(material(i),1) / l(i) ;
            end

         end
       
        
  
    end
    
end