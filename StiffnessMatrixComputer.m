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
            obj.preprocessData = cParams.preprocessData ;
            obj.connecDofs = cParams.connecDofs ;
        end

        function computeElementStiffnessMatrix(obj)
            % Computation of element stiffness matrices
            s.dimensions = obj.dimensions ;
            s.preprocessData = obj.preprocessData ;
            c = StiffnessComputer(s) ;
            Kel = c.compute() ;
            obj.elemStiffnessMat = Kel ;
        end

        function computeMatrixAssembly(obj)
            obj.computeElementStiffnessMatrix() ;            
            % Global matrix assembly
            s.dimensions = obj.dimensions ;
            s.Td = obj.connecDofs ;
            s.Kel = obj.elemStiffnessMat ;
            c = AssemblyComputer(s) ;
            KG = c.compute() ;
            obj.stiffnessMatrix = KG ;
        end
    end
end