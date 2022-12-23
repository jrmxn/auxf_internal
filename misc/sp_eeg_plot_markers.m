function sp_eeg_plot_markers(EEG, ix_channel, filter_marker)
ev_u = unique({EEG.event.type});
if nargin<3, filter_marker = ev_u;end
if not(iscell(filter_marker)), filter_marker = {filter_marker};end
plot(EEG.times / 1000, EEG.data(ix_channel, :), 'k');
cmap = lines(length(ev_u));
for ix = 1:length(EEG.event)
    ty = EEG.event(ix).type;
    if contains(ty, filter_marker)
    c = cmap(strcmpi(ty, ev_u), :);
    y = get(gca, 'ylim');
    plot(ones(1, 2) * EEG.times(EEG.event(ix).latency) / 1000, y, 'Color', c);
    end
end
xlabel('Time (s)');
end