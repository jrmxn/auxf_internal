function h = plot_stars(p, loc, line_height, tooth_length, VerticalAlignment)
if nargin < 5
    VerticalAlignment = 'bottom';
end

h = struct;
lw = 0.5;
n_star = (p<0.05) + (p<0.01) + (p<0.001);
if n_star>0
    str_sig = repmat('*', 1, n_star);
    yb = line_height;
    d = 0.075;
    h.line = line(loc + d*[+1, -1], ones(1, 2) * yb, 'Color', [0, 0, 0], 'lineWidth', lw);
    h.tooth1 = line(loc(1) + d*[+1, +1], [yb-tooth_length, yb] , 'Color', [0, 0, 0], 'lineWidth', lw);
    h.tooth2 = line(loc(2) + d*[-1, -1], [yb-tooth_length, yb] , 'Color', [0, 0, 0], 'lineWidth', lw);
    h.star = text(mean(loc), yb, str_sig, 'HorizontalAlignment', 'center', 'VerticalAlignment', VerticalAlignment);
end
end