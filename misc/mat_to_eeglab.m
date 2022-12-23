function mat_to_eeglab(d_project, varargin)
%%
if nargin<1
    d_project = '190327_eeg_fmri_linbi';
end
assert(not(isempty(getenv('D_OUT'))), 'set_env.m should be run first');
%%
d.overwrite = false;
d.str_ecg = 'ECG';
d.fs_rs = 500;
d.proc = getenvc('R_PROC');
d.proc_rs = 'proc_rs';
d.proc_bcgnet_mat = 'proc_bcgnet_mat';
d.proc_bcgnet = 'proc_bcgnet';

d.d_overwrite = struct;
%% Parse inputs
[v, d] = inputParserCustom(d, varargin);clear d;
v = inputParserStructureOverwrite(v);
%%
d_proc = fullfile(getenv('D_OUT'), d_project, v.proc);

d_rs = fullfile(d_proc, v.proc_rs);
d_bcgnet_mat = fullfile(d_proc, v.proc_bcgnet_mat);
d_bcgnet = fullfile(d_proc, v.proc_bcgnet);
%%
file_list = glob(fullfile(d_bcgnet_mat, '**_r0[0-9]_bcgnet.mat'));

for ix = 1:length(file_list)
    [p_mat, f_mat, ext_mat] = fileparts(file_list{ix});
    ss = split(p_mat, filesep);
    str_sub = ss{end};
    arch = ss{end -1};
    trial_type = ss{end -2};
    ix_run = extractBetween(f_mat, '_r0', '_bcgnet');
    ix_run = str2double(ix_run{end});
    
    p_rs = fullfile(d_rs, str_sub);
    f_rs = sprintf('%s_r%02d_rs.set', str_sub, ix_run);
    
    p_eeglab = fullfile(d_bcgnet, trial_type, arch, str_sub);
    f_eeglab = sprintf('%s_r%02d_bcgnet', str_sub, ix_run);
    pfe_out_eeglab = fullfile(p_eeglab, f_eeglab);
    do_generate = generate_check_eeg(pfe_out_eeglab, v.overwrite);
    
    if do_generate
        fprintf('Loading:\n%s\n', f_rs);
        EEG_rs = pop_loadset(f_rs, p_rs);
        EEG_rs.times = double(EEG_rs.times);
        EEG_rs.data = double(EEG_rs.data);
        
        v.setname = f_rs;
        if strcmpi(getenv('R_PROC'), 'proc_clayden')
            EEG_bcgnet = EEG_rs;
        elseif strcmpi(getenv('R_PROC'), 'proc_cwl')
            error('not implemented!');
        else
            EEG_bcgnet = pop_select(EEG_rs, 'nochannel', 65:70);
        end
        
        v.ch_ecg = find(strcmpi({EEG_rs.chanlocs.labels}, v.str_ecg));
        ecg_data = EEG_rs.data(v.ch_ecg, :);
        
        struct_bcgnet = load(file_list{ix});
        data_bcgnet = struct_bcgnet.data * 1e6;
        data_bcgnet(v.ch_ecg, :) = ecg_data;
        
        EEG_bcgnet.data = data_bcgnet;
        EEG_bcgnet = eeg_checkset(EEG_bcgnet);
        
        pop_saveset(EEG_bcgnet, 'filename', f_eeglab, 'filepath', p_eeglab, 'version', '6');
    end
end

file_list_pre = glob(fullfile(d_bcgnet_mat, '**_r0[0-9]_bcgnet_pre_trained.mat'));
for ix = 1:length(file_list_pre)
    [p_mat, f_mat, ext_mat] = fileparts(file_list_pre{ix});
    ss = split(p_mat, filesep);
    str_sub = ss{end};
    arch = ss{end -1};
    trial_type = ss{end -2};
    ix_run = extractBetween(f_mat, '_r0', '_bcgnet');
    ix_run = str2double(ix_run{end});
    
    p_rs = fullfile(d_rs, str_sub);
    f_rs = sprintf('%s_r%02d_rs.set', str_sub, ix_run);
    
    p_eeglab = fullfile(d_bcgnet, trial_type, arch, str_sub);
    f_eeglab_pre = sprintf('%s_r%02d_bcgnet_pre_trained', str_sub, ix_run);
    pfe_out_eeglab_pre = fullfile(p_eeglab, f_eeglab_pre);
    do_generate = generate_check_eeg(pfe_out_eeglab_pre, v.overwrite);
    
    if do_generate
        fprintf('Loading:\n%s\n', f_rs);
        EEG_rs = pop_loadset(f_rs, p_rs);
        if EEG_rs.srate ~= v.fs_rs
            EEG_rs = pop_resample(EEG_rs, v.fs_rs);
        end
        
        EEG_rs.times = double(EEG_rs.times);
        EEG_rs.data = double(EEG_rs.data);
        v.setname = f_rs;
        if strcmpi(getenv('R_PROC'), 'proc_clayden')
            % do nothing
        elseif strcmpi(getenv('R_PROC'), 'proc_cwl')
            error('not implemented!');
        else
            EEG_bcgnet = pop_select(EEG_rs, 'nochannel', 65:70);
        end
        v.ch_ecg = find(strcmpi({EEG_rs.chanlocs.labels}, v.str_ecg));
        ecg_data = EEG_rs.data(v.ch_ecg, :);
        
        struct_bcgnet = load(file_list_pre{ix});
        data_bcgnet = struct_bcgnet.data * 1e6;
        data_bcgnet(v.ch_ecg, :) = ecg_data;
        EEG_bcgnet.data = data_bcgnet;
        
        EEG_bcgnet = eeg_checkset(EEG_bcgnet);
        
        pop_saveset(EEG_bcgnet, 'filename', f_eeglab_pre, 'filepath', p_eeglab, 'version', '6');
    end
end
end