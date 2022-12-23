function do = generate_check_mat(f, overwrite, v_hash, skip_hash_check)
if nargin<4
    skip_hash_check = false;
end
if skip_hash_check
    v_hash = nan;
end
    
if not(exist(sprintf('%s.mat', f), 'file') == 2) || overwrite
    % file does not exist or we want to overwrite
    do = true;
    if not(exist(fileparts(f), 'dir')==7), mkdir(fileparts(f));end
elseif nargin < 3
    % file exists, and we didn't pass a hash to check
    do = false;
elseif isnan(v_hash)
    % skip checks for speed
    do = false;
else
    mat_loaded = load(f);
    % check that the file we loaded has the same settings that we want
    % to use - if not, regenerate it.
    if mat_loaded.v_hash == v_hash
        do = false;
    else
        do = true;
    end
end
end