function [mat_y1_ix_val_given_bin_rs, mat_y2_ix_val_given_bin_rs, ym_bin] = match_bins(y1, y2, x_e, varargin)

d.n_its = 1000;
d.replacement = false;
d.d_overwrite = struct;
%% Parse input
[v, d] = inputParserCustom(d, varargin);clear d;
v = inputParserStructureOverwrite(v);
%%
x =(x_e(1:end-1)+x_e(2:end))/2;
[y1_c, ~, y1_bin] = histcounts(y1, x_e);
[y2_c, ~, y2_bin] = histcounts(y2, x_e);

ym_c = min([y1_c; y2_c], [], 1);
%%
mat_y1_ix_val_given_bin_rs = zeros(sum(ym_c), v.n_its);
mat_y2_ix_val_given_bin_rs = zeros(sum(ym_c), v.n_its);
ym_bin = zeros(sum(ym_c), 1);
n_c = sum(ym_c);
for ix_bin = 1:length(x)
    n_samples = ym_c(ix_bin);
    y1_ix_val_given_bin = find(ix_bin == y1_bin);
    y2_ix_val_given_bin = find(ix_bin == y2_bin);
    
    n = sum(ym_c(1:ix_bin-1));
    ix_ss = 1 + n:n+n_samples;
    case_ss = false(n_c, 1);
    case_ss(ix_ss) = true;
    ym_bin(case_ss, 1) = ix_bin;
    
    for ix_n_its = 1:v.n_its
        y1_ix_val_given_bin_rs = randsample(y1_ix_val_given_bin, n_samples, v.replacement);
        y2_ix_val_given_bin_rs = randsample(y2_ix_val_given_bin, n_samples, v.replacement);
        mat_y1_ix_val_given_bin_rs(case_ss, ix_n_its) = y1_ix_val_given_bin_rs;
        mat_y2_ix_val_given_bin_rs(case_ss, ix_n_its) = y2_ix_val_given_bin_rs;
    end
end

end


% n_its = size(mat_y1_ix_val_given_bin_rs, 2);
%
% mat_ci2 = nan(n_its, 2);
% mat_ci1 = mat_ci2;
% for ix_n_its = 1:n_its
%     a = p2(mat_y2_ix_val_given_bin_rs(:, ix_n_its));
%     [~, mat_ci2(ix_n_its, :)] = binofit(sum(a), length(a));
%     a = p1(mat_y1_ix_val_given_bin_rs(:, ix_n_its));
%     [~, mat_ci1(ix_n_its, :)] = binofit(sum(a), length(a));
% end
% [mean(mat_ci1);mean(mat_ci2)]
