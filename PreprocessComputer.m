classdef PreprocessComputer < handle
    
    properties (Access = private)
        barProperties
    end

    methods (Access = public)
        function obj = PreprocessComputer(cParams)
            obj.init(cParams) ;
        end

        function [x,Tn,Fdata,fixNod,mat,Tmat] = compute(obj)
            x = obj.nodalCoordCreation() ;
            Tn = obj.connectMatCreation() ;
            Fdata = obj.extForceCreation() ;
            fixNod = obj.fixNodesCreation() ;
            mat = obj.materialData() ;
            Tmat = obj.materialConnec() ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
            obj.barProperties.F = cParams.F ;
            obj.barProperties.Young = cParams.Young ;
            obj.barProperties.Area = cParams.Area ;
            obj.barProperties.thermal_coeff = cParams.thermal_coeff ;
            obj.barProperties.Inertia = cParams.Inertia ;
        end
        
        function Fdata = extForceCreation(obj)
            Force = obj.barProperties.F ;
            Fdata = [%   Node        DOF  Magnitude   
            2 4 3*Force ;
            3 6 2*Force ;
            4 8 Force ;
            ];
        end
        
        function mat = materialData(obj)
            ElasticMod = obj.barProperties.Young ;
            Superf = obj.barProperties.Area ;
            thermalCoef = obj.barProperties.thermal_coeff ;
            Inercia = obj.barProperties.Inertia ;
            mat = [% Young M.   Section A.   thermal_coeff   Inertia
                     ElasticMod,   Superf,      thermalCoef,     Inercia;  % Material (1)
            ];

        end
    end
    methods(Access = private, Static)

        function x = nodalCoordCreation()
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
        end

        function Tn = connectMatCreation()
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
        end

        function fixNod = fixNodesCreation()
            fixNod = [% Node        DOF  Magnitude
            1 1 0 ;
            1 2 0 ;
            5 9 0 ;
            5 10 0 ;
            ];
        end

        function Tmat = materialConnec()
            Tmat = [% Mat. index
            1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1  
            ];
        end
    end
end