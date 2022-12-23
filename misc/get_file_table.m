function T = get_file_table(d_path, ext, file_type)
%% get_file_table: get file paths that match a regular expression used to organise data
% param d_path: directory in which to look for files to match
% param file_type: unique matching conditions after run
% return: table with all file paths matching as well as subjects and runs
if nargin<3
    file_type = '**';
end
file_list = glob(fullfile(d_path, ['**_r[0-9][0-9]_' file_type '.', ext]));
T = struct;
assert(not(isempty(file_list)), 'File list is empty - probably folder is badly specified.');
for ix_file = 1:length(file_list)
    T(ix_file).file = file_list{ix_file};
    tokens = regexpi(T(ix_file).file, ...
        ['/sub[0-9][0-9]/(sub[0-9][0-9])_r([0-9][0-9])_.+\.', ext], 'tokens');
    T(ix_file).str_sub = tokens{1}{1};
    ix_sub = regexpi(T(ix_file).str_sub, 'sub([0-9]+)', 'tokens');
    ix_sub = str2double(ix_sub{1}{1});
    T(ix_file).ix_sub = ix_sub;
    T(ix_file).ix_run = str2double(tokens{1}{2});
    s = dir(T(ix_file).file);
    T(ix_file).rm_file = s.bytes==0;
end
T = struct2table(T);
T(T.rm_file, :) = [];
end