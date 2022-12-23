function [y, fs] = generate_audio(vec_f, varargin)
%%
d.fs = 96000;
d.window = @(x) tukeywin(x, 0.1);
d.w_welch = 2000;
d.t_max = 0.5;
d.vec_A = 1;
d.vec_phi = 0;
d.special_case = '';
d.overwrite = false;
d.d_overwrite = struct;
%% Parse input
[v, d] = inputParserCustom(d, varargin);clear d;
v = inputParserStructureOverwrite(v);
%%
vec_A = v.vec_A;
vec_phi = v.vec_phi;
fs = v.fs;
if isempty(v.special_case)
%%
if numel(vec_phi)==1
    vec_phi = vec_phi * ones(size(vec_f));
end
if numel(vec_A)==1
    vec_A = vec_A * ones(size(vec_f));
end
%%
y = 0;
t = 0:1/fs:v.t_max-(1/fs);
t = t.';
for ix_vec_f = 1:length(vec_f)
    y = y + vec_A(ix_vec_f) * sin(2 * pi * vec_f(ix_vec_f) * t - vec_phi(ix_vec_f));
end

if not(isempty(v.window))
    y = y .* v.window(length(y));
end
else
    % whatever
end
%
% if y is a double looks like it should scale from -1 to +1
end