function cfg_proc_parent = structure_update_simple(cfg_proc_parent, cfg_proc, verbose)
if nargin < 3
    verbose = false;
end
% GPT4
% This function recursively updates fields from cfg_proc to cfg_proc_parent
fields = fieldnames(cfg_proc);
for i = 1:numel(fields)
    currentField = fields{i};
    if isstruct(cfg_proc.(currentField))
        % If the field is a structure, recurse into it
        if isfield(cfg_proc_parent, currentField)
            cfg_proc_parent.(currentField) = structure_update_simple(cfg_proc_parent.(currentField), cfg_proc.(currentField), verbose);
        else
            % If the field does not exist in the parent, create it
            cfg_proc_parent.(currentField) = cfg_proc.(currentField);
        end
    else
        % If the field is not a structure, directly update the value
        cfg_proc_parent.(currentField) = cfg_proc.(currentField);
        if verbose
            fprintf('Updating %s to %s\n', currentField, string(cfg_proc.(currentField)));
        end
    end
end
return
end
