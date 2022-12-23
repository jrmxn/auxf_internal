function y_o = extract_standards_targets_from_epochs(EEG, l_standards, l_targets)
y_o = false(1, length(EEG.epoch));
for ix_ep = 1:length(EEG.epoch)
    ix_lat = find(cellfun(@(x) x, EEG.epoch(ix_ep).eventlatency)==0);
    et = EEG.epoch(ix_ep).eventtype(ix_lat);
    
    %for rare cases where e.g. qrs lands at the same atency...
    et = et(strcmpi(et, l_targets)|strcmpi(et, l_standards));
    et = et{1};
    
    try
        if strcmpi(et, l_targets)
            y_o(ix_ep) = true;
        elseif strcmpi(et, l_standards)
            y_o(ix_ep) = false;
        else
            error('something wrong');
        end
    catch
        keyboard
    end
end
end