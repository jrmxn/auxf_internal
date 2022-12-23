function [v, d] = inputParserCustom(d, varargin_, d_setting)
%% if the env variable is set then use it to overwrite
D_ROOT = getenv('D_GIT');
if not(isempty(D_ROOT))
    d.D_ROOT = D_ROOT;
elseif not(isfield(d, 'D_ROOT'))
    error('You need to set the D_ROOT env variable');
end
%%
if nargin>2
    if not(isempty(d_setting))
    error('Placeholder for type checks that can be passed to addParameter.')
    end
end
%% Do the actual input parsing
v = inputParser;
fn_d = fieldnames(d);
for ix_d = 1:length(fn_d)
    addParameter(v, fn_d{ix_d}, d.(fn_d{ix_d}));
end
parse(v,varargin_{:});
v = v.Results; clear d;
%% Try get version of this script from git, to store along with output
try
    if isempty(which('get_gitinfo')), addpath(genpath(fullfile(v.D_ROOT, 'matlab_code', 'auxf')));end
    v = get_gitinfo(v);
catch
    warning('Failed to get git information.');
end
%%
d = [];
end