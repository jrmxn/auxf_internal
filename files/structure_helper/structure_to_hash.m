function hashString = structure_to_hash(S, excludeFields, hashLength)
% GPT4 wrote this - 2024-05-01

    % Set default for excludeFields if it's not provided
    if nargin < 2 || isempty(excludeFields)
        excludeFields = {};
    end
    % Set default hash length if not provided
    if nargin < 3
        hashLength = 128; % Default to MD5
    end

    % Exclude specified fields from the structure
    S = excludeSpecifiedFields(S, excludeFields);
    
    % Serialize the structure to a JSON string
    jsonString = jsonencode(S);
    
    % Choose hashing algorithm based on desired hash length
    if hashLength == 128
        md = java.security.MessageDigest.getInstance('MD5'); % MD5 hashing
    elseif hashLength == 160
        md = java.security.MessageDigest.getInstance('SHA-1'); % SHA-1 hashing
    elseif hashLength == 256
        md = java.security.MessageDigest.getInstance('SHA-256'); % Default to SHA-256
    else
        error('Bad hash length - this can still work, but not sure.')
    end
    
    hash = md.digest(uint8(jsonString));  % Convert JSON string to uint8 and then digest

    % Convert the hash byte array to its hexadecimal representation
    hashString = sprintf('%02x', typecast(hash, 'uint8'));
    % If SHA-256 and a shorter hash is needed, truncate it
    if hashLength < 256 && hashLength > 0
        hashString = hashString(1:hashLength/4); % hashLength/4 because each hex digit represents 4 bits
    end
end


function S = excludeSpecifiedFields(S, fields)
    % Iterate over all specified fields to exclude
    for i = 1:length(fields)
        fieldPath = strsplit(fields{i}, '.');
        S = removeField(S, fieldPath);
    end
end

function S = removeField(S, fieldPath)
    % Recursively remove fields from the structure
    if isstruct(S) && isfield(S, fieldPath{1})
        if length(fieldPath) == 1
            S = rmfield(S, fieldPath{1});
        else
            % Recurse deeper into the structure
            S.(fieldPath{1}) = removeField(S.(fieldPath{1}), fieldPath(2:end));
        end
    end
end
