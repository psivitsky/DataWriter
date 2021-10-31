classdef DataWriter < matlab.System & ...
        matlab.system.mixin.CustomIcon   
    % The block writes the input binary data to a file.
    % It uses the low-level I/O function "fwrite".
    % Writing is done over the existing file ("w" mode).
    % The block uses little-endian ordering by default.
    % The block can write real or complex data.
    % For more information, see the section "Exporting binary data using 
    % low-level I/O" in the MATLAB documentation.

    properties(Nontunable)
        FileName = 'test.pcm';      % File name      
        InputType = 'double';       % Input data type
    end
    
    properties(Hidden, Access = private)
        File;       % File object
    end
    
    properties(Constant, Hidden)
        % StringSet is used for the list box of data types in block dialog.
        % This method will be removed in future MATLAB releases.        
        InputTypeSet = matlab.system.StringSet(...
            {'double', 'single', 'int8', 'uint8', 'int16', 'uint16', ...
            'int32', 'uint32', 'int64', 'uint64'});
    end

    methods(Access = protected)
        
        function validateInputsImpl(obj, data)
            if ~strcmp(obj.InputType, class(data))
                 error('Input type mismatch!');
            end
        end
        
        function setupImpl(obj)
            obj.File = fopen(obj.FileName, 'w');
            if obj.File < 0
                error('File can not be opened!');
            end
        end

        function stepImpl(obj, data)
            if isreal(data)
                fwrite(obj.File, data, obj.InputType);
            else
                [r_num, c_num] = size(data);
                interleaved_data = zeros(r_num * 2, c_num);                
                new_row = 1;
                for row = 1 : r_num
                    interleaved_data(new_row, :) = real(data(row, :));
                    interleaved_data(new_row + 1, :) = imag(data(row, :));
                    new_row = new_row + 2;
                end                
                fwrite(obj.File, interleaved_data, obj.InputType);               
                % The writing of complex data is taken from the section
                % "Exporting binary data with low-level I/O" in the MATLAB
                % documentation with minor improvements.
            end
        end
        
        function releaseImpl(obj)
            fclose(obj.File);
        end

        function icon = getIconImpl(~)
            icon = 'Data Writer';
        end

        function name = getInputNamesImpl(~)
            name = '';
        end
        
    end
    
    methods(Static, Access = protected)
        
        function header = getHeaderImpl
            header = matlab.system.display.Header('DataWriter', ...
                'Title', 'Data Writer');
        end

        function group = getPropertyGroupsImpl
            group = matlab.system.display.Section(...
                'Title', 'Parameters', ...
                'PropertyList', {'FileName', 'InputType'});
        end
        
    end
end

