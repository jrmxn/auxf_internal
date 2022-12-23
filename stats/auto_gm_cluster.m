function [vec_cluster, v] = auto_gm_cluster(vec_input, varargin)
d.MaxIter = 2500;
d.reg = 1e-2;
d.n_rep = 10;
d.sharedcovariance = false;
d.gof = 'AIC';  % can be AIC or BIC
d.n_clusters_max = Inf;
d.d_overwrite = struct;
%% Parse input
[v, d] = inputParserCustom(d, varargin);clear d;
v = inputParserStructureOverwrite(v);
%%
% v.reg = 1e-2;
if isinf(v.n_clusters_max) || v.n_clusters_max>=length(vec_input)
    v.n_clusters_max = length(vec_input)-1;
end
vec_gof = nan(1, v.n_clusters_max);
options = statset('Display','off', 'MaxIter', v.MaxIter);
for ix = 1:v.n_clusters_max
    GMModel = fitgmdist(vec_input, ix, 'RegularizationValue', v.reg, ...
        'Options', options, 'Replicates', v.n_rep, 'SharedCovariance', v.sharedcovariance);
    vec_gof(ix) = GMModel.(v.gof);
    if ix>=3
        % if we are getting worse
        if all(vec_gof(ix) > vec_gof(ix-2:ix-1))
            break;
        end
    end
end
[~, N_clusters] = min(vec_gof);
% try
if isempty(N_clusters)
    vec_cluster = nan(size(vec_input));
else
    GMModel = fitgmdist(vec_input, N_clusters, 'RegularizationValue', v.reg, ...
        'Options', options, 'Replicates', v.n_rep);
% catch
%     keyboard;
% end
vec_cluster = GMModel.cluster(vec_input);
% vec_cluster_u = unique(vec_cluster, 'stable');  % stable keeps the ordering
end
end