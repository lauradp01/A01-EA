classdef ForceComputer < handle
    
    properties (Access = private)
        nDof
        dataForce
    end

    methods (Access = public)
        function obj = ForceComputer(cParams)
            obj.init(cParams) ;
        end

        function Fext = compute(obj)
            Fext = obj.computeFext() ;
        end
    end

    methods (Access = private) 
        function init(obj,cParams)
            obj.nDof = cParams.nDof ;
            obj.dataForce = cParams.dataForce ;
        end

        function Fext = computeFext(obj)
            nDim = obj.nDof ;
            Forces = obj.dataForce ;
            
            Fext = zeros(nDim,1) ;

            for i = 1:size(Forces,1)
                Fext(Forces(i,2)) = Forces(i,3) ;
            end
        end

    end

end