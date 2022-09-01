classdef PreprocessComputer < handle
    
    properties (Access = private)
        F 
        Young 
        Area
        thermal_coeff
        Inertia
    end

    methods (Access = public)
        function obj = PreprocessComputer(cParams)
            obj.init(cParams) ;
        end

        function [x,Tn,Fdata,fixNod,mat,Tmat] = compute(obj)
            Force = obj.F ;
            ElasticMod = obj.Young ;
            Superf = obj.Area ;
            thermalCoef = obj.thermal_coeff ;
            Inercia = obj.Inertia ;
                      
            % Nodal coordinates matrix creation
            %  x(a,j) = coordinate of node a in the dimension j
            x = [%  X       Y
            0 0 ;
            0.5 0.2 ;
            1 0.4 ;
            1.5 0.6 ;
            0 0.5 ;
            0.5 0.6 ;
            1 0.7 ;
            1.5 0.8
            ];
            
            % Connectivities matrix ceation
            %  Tn(e,a) = global nodal number associated to node a of element e
            Tn = [%     a      b
            1 2 ;
            2 3 ;
            3 4 ;
            5 6 ;
            6 7 ; 
            7 8 ;
            1 5 ;
            1 6 ; 
            2 5 ;
            2 6 ; 
            2 7 ;
            3 6 ;
            3 7 ;
            3 8 ;
            4 7 ;
            4 8 ;
            ];
            
            % External force matrix creation
            %  Fdata(k,1) = node at which the force is applied
            %  Fdata(k,2) = DOF (direction) at which the force is applied
            %  Fdata(k,3) = force magnitude in the corresponding DOF
            Fdata = [%   Node        DOF  Magnitude   
            2 4 3*Force ;
            3 6 2*Force ;
            4 8 Force ;
            ];
            
            % Fix nodes matrix creation
            %  fixNod(k,1) = node at which some DOF is prescribed
            %  fixNod(k,2) = DOF prescribed
            %  fixNod(k,3) = prescribed displacement in the corresponding DOF (0 for fixed)
            fixNod = [% Node        DOF  Magnitude
            1 1 0 ;
            1 2 0 ;
            5 9 0 ;
            5 10 0 ;
            ];
            
            % Material data
            %  mat(m,1) = Young modulus of material m
            %  mat(m,2) = Section area of material m
            %  --more columns can be added for additional material properties--
            mat = [% Young M.   Section A.   thermal_coeff   Inertia
                     ElasticMod,   Superf,      thermalCoef,     Inercia;  % Material (1)
            ];
            
            % Material connectivities
            %  Tmat(e) = Row in mat corresponding to the material associated to element e 
            Tmat = [% Mat. index
            1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1  
            ];
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.F = cParams.F ;
            obj.Young = cParams.Young ;
            obj.Area = cParams.Area ;
            obj.thermal_coeff = cParams.thermal_coeff ;
            obj.Inertia = cParams.Inertia ;
        end
    end

end