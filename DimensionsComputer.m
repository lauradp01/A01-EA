classdef DimensionsComputer < handle
    properties (Access = private)
        preprocessData
%         necessaryData
    end

    properties (Access = private)
        dimensions
    end

    methods (Access = public)
        function obj = DimensionsComputer(cParams)
           obj.init(cParams) ;
        end

        function dimensions = compute(obj)
            obj.computeDimensions() ;
            dimensions = obj.dimensions ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.preprocessData = cParams.preprocessData ;
        end

        function computeDimensions(obj)
            x = obj.preprocessData.coord ;
            Tn = obj.preprocessData.connec ;
            dim.n_d = size(x,2) ;              % Number of dimensions
            dim.n_i = dim.n_d ;                % Number of DOFs for each node
            dim.n = size(x,1) ;                % Total number of nodes
            dim.n_dof = dim.n_i*dim.n ;        % Total number of degrees of freedom
            dim.n_el = size(Tn,1) ;            % Total number of elements
            dim.n_nod = size(Tn,2) ;           % Number of nodes for each element
            dim.n_el_dof = dim.n_i*dim.n_nod ; % Number of DOFs for each element
            obj.dimensions = dim ;
        end
    end
end