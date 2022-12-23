function n = set_filter_n(fs_target, ds, n_max)
n = ceil(fs_target/ds) * 2;
n(n>n_max) = n_max;
if mod(n, 2) == 1
    n = n+1;
end
end