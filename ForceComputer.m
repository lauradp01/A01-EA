classdef ForceComputer < handle
    
    properties (Access = private)
        n_dof
        Fdata
    end

    methods (Access = public)
        function obj = ForceComputer(cParams)
            obj.init(cParams) ;
        end

        function Fext = compute(obj)
            nDim = obj.n_dof ;
            Forces = obj.Fdata ;
            
            Fext = zeros(nDim,1) ;

            for i = 1:size(Forces,1)
                Fext(Forces(i,2)) = Forces(i,3) ;
            end
        end
    end

    methods (Access = private) 
        function init(obj,cParams)
            obj.n_dof = cParams.n_dof ;
            obj.Fdata = cParams.Fdata ;
        end
    end
end