function threshold_manual = extract_threshold_from_redcap(res_cx_th)

%         res_cx_th = 'RFCR:65V(ct3, 75us);RFCR:>300V(ct1, 75us)';  %
%         example of how to write the threshold so that it can be read

pattern = '([a-zA-Z0-9]+):([<>]?[0-9]+)V\(ct([0-9]+), ([0-9]+)us\)';

matches = regexp(res_cx_th, pattern, 'tokens');

% The matches are returned in a cell array, where each cell is a 1x4 cell array containing the muscle, intensity, pulse count, and pulse width.

threshold_manual = struct;
for i = 1:numel(matches)
    match = matches{i};
    threshold_manual(i).muscle = string(match{1});
    intensity = match{2};
    if strcmpi(intensity(1), '>')
        intensity = intensity(2:end);
        intensity_is_greater_than = true;
    else
        intensity_is_greater_than = false;
    end
    threshold_manual(i).intensity = str2double(intensity);
    threshold_manual(i).cx_count = str2double(match{3});
    threshold_manual(i).cx_pw = str2double(match{4}) * 1e-6;  % to s
    threshold_manual(i).intensity_is_greater_than = intensity_is_greater_than;
end
threshold_manual = struct2table(threshold_manual);
end