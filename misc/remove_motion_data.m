function EEG = remove_motion_data(EEG)
% remove motion data
labels = {EEG.chanlocs.labels};
motion_channels = cellfun(@(x) isempty(regexp(x, '[tr][0-9]')), labels);
EEG = pop_select( EEG, 'channel', labels(motion_channels));
end