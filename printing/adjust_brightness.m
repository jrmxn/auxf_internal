function RGB_out = adjust_brightness(RGB_in, val)
HSV = rgb2hsv(RGB_in);
HSV(3) = val;
RGB_out = hsv2rgb(HSV);
end