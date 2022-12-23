function [se2, s] = std_error(x, w, dim, flag)
if not(isnumeric(dim))
    if strcmpi(dim, 'all')
        x = x(:);
    else
        error('dim is a string, but not -all-?')
    end
end
if or(nargin<3, isempty(dim))
    dim = 1;
end
if nargin<4
    flag = 'omitnan';
end
s = std(x, w, dim, flag);
n = sum(isfinite(x), dim);
se2 = 2 * s./sqrt(n);
end