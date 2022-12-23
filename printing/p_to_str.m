function p_str = p_to_str(p)
if p < 1e-3
    p_str = sprintf('%0.0e', p);
    p_str = strrep(p_str, 'e', ' × 10');
else
    p_str = sprintf('%0.3f', p);
end
end