function cfg_out = map_to_struct(cfg)
keys = cfg.keys;
cfg_out = struct;
for ix_key_outer = 1:length(keys)
    key = keys{ix_key_outer};
    value = cfg(key);
    if isa(value, 'containers.Map')
        cfg_out.(key) = map_to_struct(value);
    else
        cfg_out.(key) = value;
    end
end
end