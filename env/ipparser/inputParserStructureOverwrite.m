function v = inputParserStructureOverwrite(v)
% instead of supplying each item ('variable_name', variable)
% just supply it as a structure assigned to d_overwrite
if isfield(v, 'd_overwrite')
    d_overwrite = v.d_overwrite;
    fn_d_overwrite = fieldnames(d_overwrite);
    for ix_fn_d_overwrite = 1:length(fn_d_overwrite)
        assert(isfield(v, fn_d_overwrite{ix_fn_d_overwrite}), ...
            'Invalid (missing in function preamble) field was set in d_overwrite: %s', ...
            fn_d_overwrite{ix_fn_d_overwrite});
        v.(fn_d_overwrite{ix_fn_d_overwrite}) = d_overwrite.(fn_d_overwrite{ix_fn_d_overwrite});
    end
else
    warning('d_overwrite not defined for input parser.')
    %     i.e. put this d.d_overwrite = struct; in the preamble before
    %     inputParserCustom call.
end
end