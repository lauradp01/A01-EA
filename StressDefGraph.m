classdef StressDefGraph < handle

    properties (Access = private)
        x
        Tn
        u
        sig
        scale
    end

    methods (Access = public)
        function obj = StressDefGraph(cParams)
            obj.init(cParams) ;
        end

        function plot(obj)
            coord = obj.x ;
            connec = obj.Tn ;
            displacement = obj.u ;
            sigma = obj.sig ;
            scale = obj.scale ;

            % Precomputations
            n_d = size(coord,2);
            X = coord(:,1);
            Y = coord(:,2);
            ux = displacement(1:n_d:end);
            uy = displacement(2:n_d:end);
            
            % Initialize figure
            figure('color','w');
            hold on
            box on
            axis equal;
            colormap jet;
            
            % Plot undeformed structure
            plot(X(connec)',Y(connec)','-k','linewidth',0.5);
            
            % Plot deformed structure with stress colormapped
            patch(X(connec)'+scale*ux(connec)',Y(connec)'+scale*uy(connec)',[sigma';sigma'],'edgecolor','flat','linewidth',2);
            
            % Add axes labels
            xlabel('x (m)')
            ylabel('y (m)')
            
            % Add title
            title(sprintf('Deformed structure (scale = %g)',scale));
            
            % Add colorbar
            caxis([min(sigma(:)),max(sigma(:))]);
            cbar = colorbar;
            set(cbar,'Ticks',linspace(min(sigma(:)),max(sigma(:)),5));
            title(cbar,{'Stress';'(Pa)'});
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
    end
end