function c = get_cmap(cswitch)
if nargin<1
    cswitch = false;
end
c = struct;

c.blue1 = [000, 000, 062]/255;
c.green1 = [068, 120, 070]/255;
c.green3 = [091, 194, 062]/255;

c.blue2 = [075, 075, 130]/255;
c.green2 = [083, 091, 184]/255;
c.blue3 = [165, 165, 235]/255;

c.neutral = [177, 177, 176]/255;
c.neutral_dark = [100, 100, 100]/255;

% c.ecg = [0.6350    0.0780    0.1840];

if cswitch
    %     c.gar_ta = [0.95, 0.95, 1.05].*[075, 075, 130]/255;
        c.blue2 = [1.10, 1.10, 1.50].*[075, 075, 130]/255;
        c.blue1 = [1.00, 1.00, 1.00].*[000, 000, 062]/255;
end

end