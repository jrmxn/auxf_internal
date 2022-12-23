function va = update_struct(struct_local, sub, ch_, pos, str_param, va_default)
va = va_default;
if isfield(struct_local, sub)
    if isfield(struct_local.(sub), ch_)
        if isfield(struct_local.(sub).(ch_), pos)
            if isfield(struct_local.(sub).(ch_).(pos), str_param)
                va = struct_local.(sub).(ch_).(pos).(str_param);
            end
        elseif isfield(struct_local.(sub).(ch_), str_param)
            va = struct_local.(sub).(ch_).(str_param);
        end
    elseif isfield(struct_local.(sub), str_param)
        va = struct_local.(sub).(str_param);
    end
elseif isfield(struct_local, str_param)
    va = struct_local.(str_param);
end
if not(length(va)==length(va_default))
    va = va_default;
    % this should throw an error
elseif all(isnan(va))
    va = va_default;
    % if on the first fit attempt they don't get set, this can happen
end
end