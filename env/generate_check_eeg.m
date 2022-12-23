function do = generate_check_eeg(f, overwrite, v_hash, skip_hash_check)
if nargin<4
    skip_hash_check = false;
end
if skip_hash_check
    v_hash = nan;
end

[~, ~, ext] = fileparts(f);
if strcmpi(ext, '.set')
    % remove extensions if it's .set
    f = f(1:end-length(ext));
end
if not(exist(sprintf('%s.set', f), 'file') == 2) || overwrite
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
    EEG = pop_loadset('filename', sprintf('%s.set', f));
    % check that the file we loaded has the same settings that we want
    % to use - if not, regenerate it.
    do = true;
    fn = fieldnames(EEG.etc.hashes);
    for ix_fn = 1:length(fn)
        if EEG.etc.hashes.(fn{ix_fn}) == v_hash
            do = false;
        end
    end
end
end