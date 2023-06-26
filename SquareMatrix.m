classdef SquareMatrix < handle & matlab.mixin.Copyable
    properties (SetAccess = protected)
        Mat
        Dim
        Eig
    end

    % events
    %     Changed
    % end

    methods

        % Constructor
        function [obj, Successfull] = SquareMatrix(data)
            try
                if ~isnumeric(data)
                    error('SquareMatrix:NotNumeric',...
                        'Data must be a numeric square array.');
                elseif ~ismatrix(data)
                    error('SquareMatrix:NotMatrix',...
                        'Data must be a matrix. That is size(A,n)=1 for all n>2.');
                elseif size(data,1)~=size(data,2)
                    error('SquareMatrix:NotSquare', ...
                        'Data must be a square array.');
                end
                obj.Mat=data;
                obj.Dim=size(data,1);
                obj.Eig=eig(data);
                Successfull = true;
            catch e                
                Successfull = false;
                rethrow(e);
            end
        end

        function [Successfull, DimChanged, DataChanged] = Set(obj, data)
            try
                DimChanged = false;
                DataChanged = false;
                Successfull = false;
                if ~isnumeric(data)
                    error('SquareMatrix:NotNumeric',...
                        'Data must be a numeric square array.');
                elseif ~ismatrix(data)
                    error('SquareMatrix:NotMatrix',...
                        'Data must be a matrix. That is size(A,n)=1 for all n>2.');
                elseif size(data,1)~=size(data,2)
                    error('SquareMatrix:NotSquare', ...
                        'Data must be a square array.');
                end
                if size(data,1)~=obj.Dim 
                    % Current dimention is not the same as new.
                    DimChanged = true;
                    obj.Dim=size(data,1);
                    DataChanged = true;
                else
                    % Current dimention is the same as new.
                    DimChanged = false;
                end
                if ~DimChanged
                    % No dimention change
                    if obj.Mat==data
                        % and the data is the same
                        DataChanged = false;
                    else
                        DataChanged = true;
                    end
                end
                if DataChanged
                    % Not the same data, so update necessary
                    obj.Mat=data;
                    obj.Eig = eig(data);
                end
                
                Successfull=true;
            catch e                
                rethrow(e);
            end
        end
    end
end
