classdef SwitchedSystem < handle
    properties (SetAccess = protected)
        A
        B
        isSumHurwitz
        Dim
    end

    methods

        % Constructor
        function [obj, Successfull] = SwitchedSystem(SystemA, SystemB)
            try
                Successfull = false;
                if isa(SystemA,'LinearSystem')
                    obj.A=copy(SystemA);
                else
                    obj.A=LinearSystem(SystemA);
                end
                if isa(SystemB,'LinearSystem')
                    obj.B=copy(SystemB);
                else
                    obj.B=LinearSystem(SystemB);
                end
                if obj.A.Dim~=obj.B.Dim
                    error('SwitchedSystem:DimMissMatch',...
                        'The Dims of the systems must be the same.');
                end
                obj.isSumHurwitz=all(real(eig(obj.A.Mat+obj.B.Mat))<0);
                obj.Dim = obj.A.Dim;
                Successfull = true;
            catch e
                reth  row(e);
            end
        end

        function [Successfull, DimChanged, AMatChanged, BMatChanged] = Set(obj, options)
            arguments
                obj
                options.A {mustBeNumeric} = 1
                options.B {mustBeNumeric} = 1
            end

            try
                Successfull=false;
                ADimChanged=false; AMatChanged=false;
                BDimChanged=false; BMatChanged=false;
                DimChanged=false;
                if and(size(options.A,1)~=1, size(options.B,1)==1)
                    % Only change A
                    [~, ADimChanged, AMatChanged] = obj.A.Set(options.A);
                    if ADimChanged
                        error('SwitchedSystem:DimMissMatch',...
                            'The Dims of the systems must be the same.');
                    end
                elseif and(size(options.A,1)==1, size(options.B,1)~=1)
                    % Only change B
                    [~, BDimChanged, BMatChanged] = obj.B.Set(options.B);
                    if BDimChanged
                        error('SwitchedSystem:DimMissMatch',...
                            'The Dims of the systems must be the same.');
                    end
                elseif and(size(options.A,1)~=1, size(options.B,1)~=1)
                    % Change both
                    [~, ADimChanged, AMatChanged] = obj.A.Set(options.A);
                    [~, BDimChanged, BMatChanged] = obj.B.Set(options.B);
                    if xor(ADimChanged,BDimChanged)
                        % Dimention of one changed but not the other
                        error('SwitchedSystem:DimMissMatch',...
                            'The Dims of the systems must be the same.');
                    elseif and(ADimChanged,BDimChanged)
                        % Leagal demention change
                        obj.Dim=obj.A.Dim;
                        DimChanged=true;
                    end
                end

                if or(AMatChanged,BMatChanged)
                    obj.isSumHurwitz=all(real(eig(obj.A.Mat+obj.B.Mat))<0);
                end
                Successfull = true;
            catch e
                rethrow(e);
            end
        end
    end
end