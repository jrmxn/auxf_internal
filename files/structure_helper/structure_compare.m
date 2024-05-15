function areIdentical = structure_compare(S1, S2, excludeFields)
% GPT4 wrote this - 2024-05-01

    % Initially assume the structures are identical
    areIdentical = true;
    
    % Check if both inputs are structures
    if ~isstruct(S1) || ~isstruct(S2)
        error('Both inputs must be structures.');
    end

    % If no fields are to be excluded, initialize an empty cell array
    if nargin < 3
        excludeFields = {};
    end

    % Convert excludeFields from dot notation to nested cell arrays
    excludePaths = cellfun(@(x) strsplit(x, '.'), excludeFields, 'UniformOutput', false);

    % Function to check if a field is excluded
    function isExcluded = checkExclusion(fieldPath)
        isExcluded = any(cellfun(@(p) isequal(p, fieldPath), excludePaths));
    end

    % Recursive function to compare fields
    function identical = compareFields(S1, S2, currentPath)
        identical = true;
        fields1 = sort(fieldnames(S1));
        fields2 = sort(fieldnames(S2));
        if ~isequal(fields1, fields2)
            identical = false;
            return;
        end
        
        for i = 1:length(fields1)
            field = fields1{i};
            newPath = [currentPath, {field}];
            if checkExclusion(newPath)
                continue; % Skip excluded fields
            end
            value1 = S1.(field);
            value2 = S2.(field);
            if class(value1) ~= class(value2)
                identical = false;
                return;
            end
            if isstruct(value1) && isstruct(value2)
                if ~compareFields(value1, value2, newPath)
                    identical = false;
                    return;
                end
            elseif iscell(value1) && iscell(value2)
                if numel(value1) ~= numel(value2) || ...
                   any(~cellfun(@(v1, v2) isequal(v1, v2), value1, value2))
                    identical = false;
                    return;
                end
            elseif isnumeric(value1) && isnumeric(value2) || ...
                   islogical(value1) && islogical(value2) || ...
                   ischar(value1) && ischar(value2)
                if ~isequal(value1, value2)
                    identical = false;
                    return;
                end
            elseif isstring(value1) && isstring(value2)
                if ~isequal(value1, value2)
                    identical = false;
                    return;
                end
            else
                fprintf('Skipping comparison of complex or unsupported data types in field: %s\n', strjoin(newPath, '.'));
            end
        end
    end

    % Start comparison with an empty path
    areIdentical = compareFields(S1, S2, {});
end
