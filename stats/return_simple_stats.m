function [mea_x, std_x,sem_x, n_x, med_x, str_out] = return_simple_stats(vec_x, dim, str_condition, str_units)
if (nargin < 2) || isempty(dim)
    dim = 1;
end
if nargin < 3
    str_condition = [];
end
mea_x = mean(vec_x, dim, 'omitnan');
std_x = std(vec_x, 0, dim, 'omitnan');
n_x = sum(isfinite(vec_x), dim);
sem_x = std_x./sqrt(n_x);
med_x = median(vec_x, dim, 'omitnan');
if not(isempty(str_condition))
    line1 = sprintf('%s: %0.2f+-%0.2f %s ', str_condition, mea_x, sem_x, str_units);
    line2 = sprintf('(STD = %0.2f %s, median = %0.2f %s), n = %d', std_x, str_units, med_x, str_units, n_x);
    str_out = sprintf('%s%s', line1, line2);
    fprintf('%s\n', str_out);
end
end