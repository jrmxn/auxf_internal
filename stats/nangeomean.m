function m = nangeomean(x, dim)
if nargin<2
    dim = 1;
end

m = prod(x, dim, 'omitnan').^(1./sum(isfinite(x), dim));
m(not(any(isfinite(x), dim))) = nan;
end