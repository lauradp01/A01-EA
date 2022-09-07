classdef StiffnessMatrixComputer < handle

    properties
        dimensions
        coord
        connec
        material
        connecMaterial

        connecDofs

        elemStiffnessMat
        stiffnessMatrix

        computeDofConnectivities

        
    end

    methods (Access = public)
%         function obj = untitled5(inputArg1,inputArg2)
%             %UNTITLED5 Construct an instance of this class
%             %   Detailed explanation goes here
%             obj.Property1 = inputArg1 + inputArg2;
%         end

        function KG = compute(obj)
            KG = obj.computeMatrixAssembly ;
        end
    end

    methods (Access = private)
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
            obj.computeDofConnectivities() ;
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