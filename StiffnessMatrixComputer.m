classdef StiffnessMatrixComputer < handle
    
    properties (Access = private)
        dimensions
        coord
        connec
        material
        connecMaterial
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
            obj.coord = cParams.coord ;
            obj.connec = cParams.connec ;
            obj.material = cParams.material ;
            obj.connecMaterial = cParams.connecMaterial ;
            obj.connecDofs = cParams.connecDofs ;
        end

        function computeElementStiffnessMatrix(obj)
            % Computation of element stiffness matrices
            s.n_d = obj.dimensions.n_d ;
            s.n_el = obj.dimensions.n_el ;
            s.x = obj.coord ;
            s.Tn = obj.connec ;
            s.mat = obj.material ;
            s.Tmat = obj.connecMaterial ;

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