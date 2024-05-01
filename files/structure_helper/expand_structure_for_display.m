function expand_structure_for_display(S, indent)
% GPT4 wrote this - 2024-05-01

    % If no indent level is provided, start with no indent.
    if nargin < 2
        indent = '';
    end
    
    % Check if the input is a structure array
    if numel(S) > 1
        for i = 1:numel(S)
            fprintf('%sStructure element %d:\n', indent, i);
            expand_structure_for_display(S(i), [indent '    ']);
        end
    else
        % Retrieve field names of the structure
        fields = fieldnames(S);
        
        % Iterate over each field
        for i = 1:length(fields)
            value = S.(fields{i});
            % Check the type of the field
            if isstruct(value)
                fprintf('%s%s:\n', indent, fields{i});
                % Recursive call to handle nested structures
                expand_structure_for_display(value, [indent '    ']);
            elseif iscell(value)
                fprintf('%s%s: {', indent, fields{i});
                for j = 1:length(value)
                    if iscell(value{j})
                        expand_structure_for_display(value{j}, [indent '    ']);
                        fprintf(', ');
                    elseif ischar(value{j})
                        fprintf('"%s"', value{j});
                    else
                        fprintf('%s, ', mat2str(value{j}));
                    end
                end
                fprintf('}\n');
            elseif ischar(value)
                fprintf('%s%s: "%s"\n', indent, fields{i}, value);
            elseif isnumeric(value) || islogical(value)
                fprintf('%s%s: %s\n', indent, fields{i}, mat2str(value));
            else
                % Handle other data types generically
                fprintf('%s%s: [%s]\n', indent, fields{i}, class(value));
            end
        end
    end
end
