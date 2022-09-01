classdef StrainStressGraph < handle
    properties (Access = private)
        n_d
        a
        x
        Tn
        title_name 
    end

    methods (Access = public)
        function obj = StrainStressGraph(cParams)
            obj.init(cParams) ;
        end

        function plot(obj)
            nDim = obj.n_d ;
            vectRepresented = obj.a ;
            coord = obj.x ;
            connec = obj.Tn ;
            titleName = obj.title_name ;

            % Reshape matrices for plot
            for i = 1:nDim
                X0{i} = reshape(coord(connec,i),size(connec))' ;
            end
            S = repmat(vectRepresented',size(connec,2),1);
            
            % Open and initialize figure
            figure('color','w');
            hold on;       % Allow multiple plots on same axes
            box on;        % Closed box axes
            axis equal;    % Keep aspect ratio to 1
            colormap jet;  % Set colormap colors
            
            % Add axes labels
            xlabel('x (m)')
            ylabel('y (m)')
            title(titleName);
            
            % Plot undeformed structure
            patch(X0{:},S,'edgecolor','flat','linewidth',2);
            
            % Set colorbar properties
            caxis([min(S(:)),max(S(:))]);
            cbar = colorbar;
            set(cbar,'Ticks',linspace(min(S(:)),max(S(:)),5));
            title(cbar,titleName);
        end
    end

    methods (Access = private) 
        function init(obj,cParams)
            obj.n_d = cParams.n_d ;
            obj.a = cParams.a ;
            obj.x = cParams.x ;
            obj.Tn = cParams.Tn ;
            obj.title_name = cParams.title_name ;
        end
    end
end