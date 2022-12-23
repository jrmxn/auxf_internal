function [p, stats, med_v1_m_v2] = plot_siglines(v1, v2, loc, line_height, tooth_length, p, VerticalAlignment)
if nargin < 7
    VerticalAlignment = 'bottom';
end
if nargin < 6
    [p, ~, stats] = signrank(v1, v2);
else
    stats = nan;
end
lw = 0.5;
med_v1_m_v2 = median(v1 - v2);
n_star = (p<0.05) + (p<0.01) + (p<0.001);
if n_star>0
%     str_sig = repmat('*', 1, n_star);
    yb = line_height;
    d = 0.075*2;
    line(loc + d*[+1, -1], ones(1, 2) * yb, 'Color', [0, 0, 0], 'lineWidth', lw);
%     line(loc(1) + d*[+1, +1], [yb-tooth_length, yb] , 'Color', [0, 0, 0], 'lineWidth', lw);
%     line(loc(2) + d*[-1, -1], [yb-tooth_length, yb] , 'Color', [0, 0, 0], 'lineWidth', lw);
%     text(mean(loc), yb, str_sig, 'HorizontalAlignment', 'center', 'VerticalAlignment', VerticalAlignment)
end
end