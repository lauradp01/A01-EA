
classdef Connectivities

    properties (Access = private)
    
    end

    methods (Access = public)

        function obj = main_class(cParams)
           obj.init(cParams);
        end

        function Td = compute(n_el,n_nod,n_i,Tn)
            Td = zeros(n_el,n_nod*n_i) ;
            for i = 1:n_el
                for j = 1:n_nod
                    column = j*n_i ;
                    valor = n_i * Tn(i,j) ;
                    for a = 1:n_i
                        Td(i,column) = valor ;
                        column = column-1 ;
                        valor = valor-1 ;
                    end
                end
            end
        end

    end



    methods (Access = private)
    

        function init(obj,cParams)
            n_el = cParams.n_el;
            
            

        end
        
        
      
    end

end