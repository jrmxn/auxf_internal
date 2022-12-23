function cfg = toml_read_wrapper(p)
cfg = toml.read(p);
cfg = toml.map_to_struct(cfg);
end