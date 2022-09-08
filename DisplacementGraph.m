classdef DisplacementGraph < handle

    properties (Access = private)
        n_d
        n
        u
        x
        Tn
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
            computeInitializeFigure ;
            addAxes ;
            obj.plotUndefStructure() ;
            obj.plotDefStructure() ;
            setColorBar ;
           
%             % Reshape matrices for plot
%             U = reshape(displacements,nDim,nodes);
%             for i = 1:nDim
%                 X0{i} = reshape(coord(connec,i),size(connec))';
%                 X{i} = X0{i}+factor*reshape(U(i,connec),size(connec))';
%             end
%             D = reshape(sqrt(sum(U(:,connec).^2,1)),size(connec))';
            
%             % Open and initialize figure
%             figure('color','w');
%             hold on;       % Allow multiple plots on same axes
%             box on;        % Closed box axes
%             axis equal;    % Keep aspect ratio to 1
%             colormap jet;  % Set colormap colors
%             
%             % Add axes labels
%             xlabel('x (m)')
%             ylabel('y (m)')
%             title('Displacement');
            
%             % Plot undeformed structure
%             patch(X0{:},zeros(size(D)),'edgecolor',[0.5,0.5,0.5],'linewidth',2);
            
%             % Plot deformed structure with displacement magnitude coloring
%             patch(X{:},D,'edgecolor','interp','linewidth',2);
            
%             % Set colorbar properties
%             caxis([min(D(:)),max(D(:))]); % Colorbar limits
%             cbar = colorbar;              % Create colorbar
%             set(cbar,'Ticks',linspace(min(D(:)),max(D(:)),5))
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.n_d = cParams.n_d ;
            obj.n = cParams.n ;
            obj.u = cParams.u ;
            obj.x = cParams.x ;
            obj.Tn = cParams.Tn ;
            obj.fact = cParams.fact ;
        end

        function computeReshape(obj)
            nDim = obj.n_d ;
            nodes = obj.n ;
            displacements = obj.u ;
            coord = obj.x ;
            connec = obj.Tn ;
            factor = obj.fact ;
            % Reshape matrices for plot
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

            % Plot undeformed structure
            patch(X0{:},zeros(size(D)),'edgecolor',[0.5,0.5,0.5],'linewidth',2);
        end

        function plotDefStructure(obj)
            X = obj.defStruc ;
            D = obj.reshapedD ;
            % Plot deformed structure with displacement magnitude coloring
            patch(X{:},D,'edgecolor','interp','linewidth',2);
        end
        
        
    end

    methods (Access = private, Static)
        function computeInitializeFigure()
            % Open and initialize figure
            figure('color','w');
            hold on;       % Allow multiple plots on same axes
            box on;        % Closed box axes
            axis equal;    % Keep aspect ratio to 1
            colormap jet;  % Set colormap colors
            
        end

        function addAxes()
            % Add axes labels
            xlabel('x (m)')
            ylabel('y (m)')
            title('Displacement');
        end

        function setColorBar()
            % Set colorbar properties
            caxis([min(D(:)),max(D(:))]); % Colorbar limits
            cbar = colorbar;              % Create colorbar
            set(cbar,'Ticks',linspace(min(D(:)),max(D(:)),5))
        end

    end



end