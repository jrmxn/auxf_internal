function [EEG, G, H, M] = sp_reference_laplace(EEG, do_plot, m, lambda)
if nargin < 2
    do_plot = false;
end
if nargin < 3
    m = nan;
end
if nargin < 4
    lambda = nan;
end
if or(isempty(which('CSD.m')),isempty(which('ConvertLocations.m')))
    error('CSD toolbox not on path');
end
used_labels = {EEG.chanlocs.labels}';

% old montage extraction - incorrect:
% [d,f_capout] = fileparts(f_cap);
% f_capout = fullfile(d,[f_capout,'.csd']);
% ConvertLocations ( f_cap, f_capout, used_labels )
% [ M ] = ExtractMontage ( f_capout, used_labels  );

used_labels(strcmpi(used_labels, 'M1')) = {'LM'};
used_labels(strcmpi(used_labels, 'M2')) = {'RM'};
M = ExtractMontage('10-5-System_Mastoids_EGI129.csd', used_labels);
if do_plot
    %check the montage
    MapMontage(M);
end
if isnan(m)
    [G,H] = GetGH(M);
else
    [G,H] = GetGH(M, m);
end
D = EEG.data;
if isnan(lambda)
    X = CSD (D, G, H);
else
    X = CSD (D, G, H, lambda);
end
EEG.data = X;
for ix_chan = 1:length(EEG.chanlocs),EEG.chanlocs(ix_chan).ref = 'none';end
EEG = eeg_checkset( EEG );
end