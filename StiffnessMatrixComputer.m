classdef StiffnessMatrixComputer < handle
    
    properties (Access = private)
        dimensions
        preprocessData
        connecDofs
    end
    
    properties (Access = private)
        elemStiffnessMat
        stiffnessMatrix
    end

    methods (Access = public)
        function obj = StiffnessMatrixComputer(cParams)
            obj.init(cParams) ;
        end

        function KG = compute(obj)
            obj.computeMatrixAssembly() ;
            KG = obj.stiffnessMatrix ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions = cParams.dimensions ;
            obj.preprocessData.coord = cParams.coord ;
            obj.preprocessData.connec = cParams.connec ;
            obj.preprocessData.material = cParams.material ;
            obj.preprocessData.connecMaterial = cParams.connecMaterial ;
            obj.connecDofs = cParams.connecDofs ;
            
        end

        function computeElementStiffnessMatrix(obj)
            % Computation of element stiffness matrices
            s.n_d = obj.dimensions.n_d ;
            s.n_el = obj.dimensions.n_el ;
            s.x = obj.preprocessData.coord ;
            s.Tn = obj.preprocessData.connec ;
            s.mat = obj.preprocessData.material ;
            s.Tmat = obj.preprocessData.connecMaterial ;

            c = StiffnessComputer(s) ;
            Kel = c.compute() ;
            obj.elemStiffnessMat = Kel ;
        end

        function computeMatrixAssembly(obj)
            obj.computeElementStiffnessMatrix() ;
            
            % Global matrix assembly
            s.n_el = obj.dimensions.n_el ;
            s.n_el_dof = obj.dimensions.n_el_dof ;
            s.n_dof = obj.dimensions.n_dof ;
            s.Td = obj.connecDofs ;
            s.Kel = obj.elemStiffnessMat ;

            c = AssemblyComputer(s) ;
            KG = c.compute() ;
            obj.stiffnessMatrix = KG ;
        end
    end
end