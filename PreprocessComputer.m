classdef PreprocessComputer < handle
    
    properties (Access = private)
        barProperties
    end

    properties (Access = private)
        preprocessData
    end

    methods (Access = public)
        function obj = PreprocessComputer(cParams)
            obj.init(cParams) ;
        end

        function preprocessData = compute(obj)
            obj.extForceCreation() ;
            obj.nodalCoordCreation() ;
            obj.connectMatCreation() ;
            obj.fixNodesCreation() ;
            obj.materialConnec() ;
            obj.materialData() ;
            preprocessData = obj.preprocessData ;
        end
    end

    methods (Access = private)
        function init(obj,cParams)
%             obj.barProperties = cParams.barProperties ;
            obj.barProperties.F = cParams.F ;
            obj.barProperties.Young = cParams.Young ;
            obj.barProperties.Area = cParams.Area ;
            obj.barProperties.thermal_coeff = cParams.thermal_coeff ;
            obj.barProperties.Inertia = cParams.Inertia ;
        end
        
        function extForceCreation(obj)
            force = obj.barProperties.F ;
            Fdata = [%   Node        DOF  Magnitude   
            2 4 3*force ;
            3 6 2*force ;
            4 8 force ;
            ];
            obj.preprocessData.dataForce = Fdata ;
        end
        
        function materialData(obj)
            elasticModule = obj.barProperties.Young ;
            superf = obj.barProperties.Area ;
            thermalCoef = obj.barProperties.thermal_coeff ;
            inercia = obj.barProperties.Inertia ;
            mat = [% Young M.   Section A.   thermal_coeff   Inertia
                     elasticModule,   superf,      thermalCoef,     inercia;  % Material (1)
            ];
            obj.preprocessData.material = mat ;

        end
   
        function x = nodalCoordCreation(obj)
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
            obj.preprocessData.coord = x ;
        end

        function Tn = connectMatCreation(obj)
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
            obj.preprocessData.connec = Tn ;
        end

        function fixNod = fixNodesCreation(obj)
            fixNod = [% Node        DOF  Magnitude
            1 1 0 ;
            1 2 0 ;
            5 9 0 ;
            5 10 0 ;
            ];
            obj.preprocessData.fixNodes = fixNod ;
        end

        function Tmat = materialConnec(obj)
            Tmat = [% Mat. index
            1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1 ; 1  
            ];
            obj.preprocessData.connecMaterial = Tmat ;
        end
    end
end