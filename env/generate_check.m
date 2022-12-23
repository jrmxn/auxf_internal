function do = generate_check(p, overwrite, v_hash, skip_hash_check)
% of the generate_check functions this is the most uptodate 2021-09-30
% should expand on this one rather than use the other ones.
[d, f, ext] = fileparts(p);
if isempty(ext)
    p_temp = glob([p(1:end-4), '.*']);
    if length(p_temp) > 1
        error('Canot determine extension!');
    else
        p = p_temp{1};  % auto determine extension
    end
end
[d, f, ext] = fileparts(p);

if not(strcmpi(ext, '.mat'))
    skip_hash_check = true;
elseif nargin<3
    skip_hash_check = true;
elseif nargin<4
    skip_hash_check = false;
end
if skip_hash_check
    v_hash = nan;
else
    
end

do = false;
if not(exist(p, 'file') == 2) || overwrite
    % file does not exist or we want to overwrite
    do = true;
    if not(exist(fileparts(p), 'dir')==7), mkdir(fileparts(p));end
elseif isfinite(v_hash)
    % this probably needs fixing?
    mat_loaded = load(p);
    % check that the file we loaded has the same settings that we want
    % to use - if not, regenerate it.
    if mat_loaded.v_hash == v_hash
        do = false;
    else
        do = true;
    end
end
end