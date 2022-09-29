classdef DataComputer < handle
    properties (Access = private)
        barProperties
    end

    methods (Access = public)
        function barProperties = compute(obj)
            obj.createData() ;
            barProperties = obj.barProperties ;
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
    end
end