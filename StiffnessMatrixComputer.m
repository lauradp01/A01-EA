classdef StiffnessMatrixComputer < handle
    
    properties (Access = private)
        dimensions
        preprocessData
        connecDofs
    end
    
    properties (Access = private)
        stiffnessMatrix
    end

    methods (Access = public)
        function obj = StiffnessMatrixComputer(cParams)
            obj.init(cParams) ;
        end

        function KG = compute(obj)
            obj.computeElementStiffnessMatrix() ;
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
            s.dimensions = obj.dimensions ;
            s.preprocessData = obj.preprocessData ;
            s.Td = obj.connecDofs ;
            c = StiffnessComputer(s) ;
            KG = c.compute() ;
            obj.stiffnessMatrix = KG ;
        end
    end
end