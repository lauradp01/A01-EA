classdef DataComputer < handle
    properties (Access = private)
        barProperties
        preprocessData
        dimensions
        connecDofs
    end

    methods (Access = public)
        function necessaryData = compute(obj)
            obj.createData() ;
            obj.computePreprocess() ;
            obj.createDimensions() ;
            obj.computeDofConnectivities() ;
            necessaryData.barProperties = obj.barProperties ;
            necessaryData.preprocessData = obj.preprocessData ;
            necessaryData.dimensions = obj.dimensions ;
            necessaryData.connecDofs = obj.connecDofs ;
         end
    end

    methods (Access = private)
        function createData(obj)
            prop.F = 920 ; %N
            prop.Young = 75e9 ; %Pa
            prop.Area = 120e-6 ; %m^2
            prop.thermal_coeff = 23e-6 ;%1/K
            prop.Inertia = 1400e-12 ; %m^4
            prop.deltaT = 0 ; %K
            obj.barProperties = prop ;
        end

        function computePreprocess(obj)
            s.barProperties = obj.barProperties ;
            c = PreprocessComputer(s) ;
            obj.preprocessData = c.compute() ;
        end
        function createDimensions(obj)
            s.preprocessData = obj.preprocessData ;
            c = DimensionsComputer(s) ;
            obj.dimensions = c.compute() ;
        end
        function computeDofConnectivities(obj)
            s.dimensions = obj.dimensions;
            s.connec = obj.preprocessData.connec ;
            c = ConnectivitiesComputer(s);
            Td = c.compute();
            obj.connecDofs = Td ;
        end
    end
end