classdef LinearSystem < SquareMatrix & matlab.mixin.Copyable
    properties (SetAccess = protected)
        LyapunovMatrix
    end

    methods

        % Constructor
        function [obj, Successfull] = LinearSystem(data)
            obj@SquareMatrix(data);
            try
                obj.LyapunovMatrix=lyap(data',eye(size(data,1)));
                Successfull=true;
            catch e
                rethrow(e);
                Successfull=false;
            end
        end

        function [Successfull, DimChanged, DataChanged] = Set(obj, data)
            [Successfull, DimChanged, DataChanged]=Set@SquareMatrix(obj,data);
            try
                obj.LyapunovMatrix=lyap(data',eye(size(data,1)));
                Successfull=true;
            catch e                
                DimChanged = false;
                DataChanged = false;
                Successfull = false;
                rethrow(e);
            end
        end
    end
end
