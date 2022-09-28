classdef DisplacementGraph < handle

    properties (Access = private)
        dimensions
        u
        preprocessData
        fact
    end

    properties (Access = private)
        reshapedU
        undefStruc
        defStruc
        reshapedD
    end

    methods (Access = public)
        function obj = DisplacementGraph(cParams)
            obj.init(cParams) ;
        end

        function plot(obj)
            obj.computeReshape() ;
            obj.computeInitializeFigure() ;
            obj.addAxes() ;
            obj.plotUndefStructure() ;
            obj.plotDefStructure() ;
            obj.setColorBar() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.dimensions = cParams.dimensions ;
            obj.preprocessData = cParams.preprocessData ;
            obj.u = cParams.u ;
            obj.fact = cParams.fact ;
        end

        function computeReshape(obj)
            nDim = obj.dimensions.n_d ;
            nodes = obj.dimensions.n ;
            displacements = obj.u ;
            coord = obj.preprocessData.coord ;
            connec = obj.preprocessData.connec ;
            factor = obj.fact ;
            U = reshape(displacements,nDim,nodes);
            for i = 1:nDim
                X0{i} = reshape(coord(connec,i),size(connec))';
                X{i} = X0{i}+factor*reshape(U(i,connec),size(connec))';
            end
            D = reshape(sqrt(sum(U(:,connec).^2,1)),size(connec))';
            obj.reshapedU = U ;
            obj.undefStruc = X0 ;
            obj.defStruc = X ;
            obj.reshapedD = D ;

        end

        function plotUndefStructure(obj)
            X0 = obj.undefStruc ;
            D = obj.reshapedD ;
            patch(X0{:},zeros(size(D)),'edgecolor',[0.5,0.5,0.5],'linewidth',2);
        end

        function plotDefStructure(obj)
            X = obj.defStruc ;
            D = obj.reshapedD ;
            patch(X{:},D,'edgecolor','interp','linewidth',2);
        end
        
        function setColorBar(obj)
            D = obj.reshapedD ;
            caxis([min(D(:)),max(D(:))]); % Colorbar limits
            cbar = colorbar;              % Create colorbar
            set(cbar,'Ticks',linspace(min(D(:)),max(D(:)),5))
        end
    end

    methods (Access = private, Static)
        function computeInitializeFigure()
            figure('color','w');
            hold on;       % Allow multiple plots on same axes
            box on;        % Closed box axes
            axis equal;    % Keep aspect ratio to 1
            colormap jet;  % Set colormap colors
        end

        function addAxes()
            xlabel('x (m)')
            ylabel('y (m)')
            title('Displacement');
        end
    end
end