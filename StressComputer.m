classdef StressComputer < handle
    properties (Access = private)
        
    end

    methods (Access = public)
        function obj = StressComputer(cParams)
            obj.init(cParams) ;
        end

        function sig = compute(obj)
            sig = obj.sigma ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            
        end
    end
end