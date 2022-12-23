
function c_v = adjust_color_brightness(c, value)
c_v = rgb2hsv(c);
        c_v(:, end) = value;
        c_v(c_v>1) = 1;
        c_v(c_v<0) = 0;
        c_v = hsv2rgb(c_v);
end