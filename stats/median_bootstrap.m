function stat = median_bootstrap(y, varargin)
d.n_its = 1e3;
d.stat_type = 'percentiles';
d.percentiles = [2.5, 97.5];
d.overwrite = false;
d.d_overwrite = struct;

%% Parse input
[v, d] = inputParserCustom(d, varargin);clear d;
v = inputParserStructureOverwrite(v);
%%

vec_med_sample = zeros(v.n_its, 1);

for ix_its = 1:v.n_its
    vec_med_sample(ix_its) = nanmedian(y(randi(length(y), size(y))));
end


if strcmpi(v.stat_type, 'percentiles')
    stat = prctile(vec_med_sample, v.percentiles);
else
    error('incorrect stat type');
end
end