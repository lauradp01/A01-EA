classdef StressDefGraph < handle

    properties (Access = private)
        x
        Tn
        u
        sig
        scale
    end

    properties (Access = private)
        horizCoord
        verticCoord
        horizDisp
        verticDisp
    end

    methods (Access = public)
        function obj = StressDefGraph(cParams)
            obj.init(cParams) ;
        end

        function plot(obj)
            obj.precompute() ;
            obj.computeInitializeFigure() ;
            obj.plotUndefStructure() ;
            obj.plotDefStructure() ;
            obj.addAxes() ;
            obj.addTitle() ;
            obj.setColorBar() ;
        end
    end

    methods (Access = private) 
        function init(obj,cParams)
            obj.x = cParams.x ;
            obj.Tn = cParams.Tn ;
            obj.u = cParams.u ;
            obj.sig = cParams.sig ;
            obj.scale = cParams.scale ;
        end

        function precompute(obj)
            coord = obj.x ;
            displacement = obj.u ;
            % Precomputations
            n_d = size(coord,2);
            X = coord(:,1);
            Y = coord(:,2);
            ux = displacement(1:n_d:end);
            uy = displacement(2:n_d:end);

            obj.horizCoord = X ;
            obj.verticCoord = Y ;
            obj.horizDisp = ux ;
            obj.verticDisp = uy ;
        end

        function plotUndefStructure(obj)
            connec = obj.Tn ;
            X = obj.horizCoord ;
            Y = obj.verticCoord ;
            % Plot undeformed structure
            plot(X(connec)',Y(connec)','-k','linewidth',0.5);
        end

        function plotDefStructure(obj)
            connec = obj.Tn ;
            X = obj.horizCoord ;
            Y = obj.verticCoord ;
            ux = obj.horizDisp ;
            uy = obj.verticDisp ;
            escala = obj.scale ;
            sigma = obj.sig ;
            % Plot deformed structure with stress colormapped
            patch(X(connec)'+escala*ux(connec)',Y(connec)'+escala*uy(connec)',[sigma';sigma'],'edgecolor','flat','linewidth',2);
        end

        function addTitle(obj)
            escala = obj.scale ;
            % Add title
            title(sprintf('Deformed structure (scale = %g)',escala));
        end

        function setColorBar(obj)
            sigma = obj.sig ;
            % Add colorbar
            caxis([min(sigma(:)),max(sigma(:))]);
            cbar = colorbar;
            set(cbar,'Ticks',linspace(min(sigma(:)),max(sigma(:)),5));
            title(cbar,{'Stress';'(Pa)'});
        end
    end

    methods (Access = private, Static)
        function computeInitializeFigure()
            % Initialize figure
            figure('color','w');
            hold on
            box on
            axis equal;
            colormap jet;
        end

        function addAxes()
            % Add axes labels
            xlabel('x (m)')
            ylabel('y (m)')
        end
    end

end