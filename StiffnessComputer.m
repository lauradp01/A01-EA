classdef StiffnessComputer < handle
   
    properties (Access = private)
        dimensions
        preprocessData
        Td
    end
    properties (Access = private)
        stiffnessMatrix
    end

    methods (Access = public)
        function obj = StiffnessComputer(cParams)
           obj.init(cParams);
        end
        function KG = compute(obj)
            obj.computeMatrixAssembly() ;
            KG = obj.stiffnessMatrix ;
         end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions = cParams.dimensions ;
            obj.preprocessData = cParams.preprocessData ;
            obj.Td = cParams.Td ;
        end
        function Kel = createKel(obj)
            nDim = obj.dimensions.n_d ;
            nElem = obj.dimensions.n_el ;
            connec = obj.preprocessData.connec ;
            n_nod = size(connec,2) ;  
            n_el_dof = nDim*n_nod ;
            Kel = zeros(n_el_dof,n_el_dof,nElem) ;
        end

        function n = computeNodes(obj)
            nElem = obj.dimensions.n_el ;
            connec = obj.preprocessData.connec ;
            for i = 1:nElem
                n.node1(i) = connec(i,1) ;
                n.node2(i) = connec(i,2) ;
            end
        end

        function co = computeCoordinates(obj)
            nElem = obj.dimensions.n_el ;
            coord = obj.preprocessData.coord ;
            n = obj.computeNodes() ;
             for i = 1:nElem
                co.x1(i) = coord(n.node1(i),1) ;
                co.y1(i) = coord(n.node1(i),2) ;
                co.x2(i) = coord(n.node2(i),1) ;
                co.y2(i) = coord(n.node2(i),2) ;
             end
        end
        function [l,s,c] = computeData(obj) 
            nElem = obj.dimensions.n_el ;
            co = obj.computeCoordinates() ;
            for i = 1:nElem
                l(i) = ((co.x2(i)-co.x1(i))^2+(co.y2(i)-co.y1(i))^2)^0.5 ;
                s(i) = (co.y2(i)-co.y1(i))/l(i) ;
                c(i) = (co.x2(i)-co.x1(i))/l(i) ;
            end
        end
        function iMat = computeMaterial(obj)
            nElem = obj.dimensions.n_el ;
            materialConnec = obj.preprocessData.connecMaterial ;
            for i = 1:nElem
                iMat(i) = materialConnec(i) ;
            end
        end
        function Kel = computeKel(obj)
            nElem = obj.dimensions.n_el ;
            Kel = obj.createKel() ;
            materialData = obj.preprocessData.material ;
            [l,s,c] = obj.computeData() ;
            iMat = obj.computeMaterial() ;
            for i = 1:nElem
                Kel(:,:,i) = [
                    c(i)^2 c(i)*s(i) -(c(i)^2) -c(i)*s(i) ;
                    c(i)*s(i) s(i)^2 -c(i)*s(i) -(s(i)^2) ;
                    -(c(i)^2) -c(i)*s(i) c(i)^2 c(i)*s(i) ;
                    -c(i)*s(i) -(s(i)^2) c(i)*s(i) s(i)^2
                    ] * materialData(iMat(i),2) * materialData(iMat(i),1) / l(i) ;
            end
        end
        function computeMatrixAssembly(obj)
%             obj.computeElementStiffnessMatrix() ;            
            s.dimensions = obj.dimensions ;
            s.Td = obj.Td ;
            s.Kel = obj.computeKel() ;
            c = AssemblyComputer(s) ;
            KG = c.compute() ;
            obj.stiffnessMatrix = KG ;
        end
    end
end