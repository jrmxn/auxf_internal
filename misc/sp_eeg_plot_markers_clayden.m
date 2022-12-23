function sp_eeg_plot_markers_clayden(EEG, ix_channel, str_grad)
plot(EEG.times / 1000, EEG.data(ix_channel, :), 'k');

% only plot the TR markers
event_tr = EEG.event(strcmpi({EEG.event.type}, str_grad));
ev_u = unique({event_tr.type});
cmap = lines(length(ev_u));

for ix = 1:length(event_tr)
    c = cmap(strcmpi(event_tr(ix).type, ev_u), :);
    y = get(gca, 'ylim');
    plot(ones(1, 2) * EEG.times(event_tr(ix).latency) / 1000, y, 'color', c);
end
xlabel('Time (s)');
end