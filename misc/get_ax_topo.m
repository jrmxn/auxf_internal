function ax = get_ax_topo(case_ch, coi_local, topo)
% tweak ax positions from electrode locations for plot
assert(sum(case_ch)==1, 'case_ch must have only one selection');
topo_local = [ ...
    0.5 + 0.01*(topo.topoX(case_ch)+1)/2-topo.topoW/2, ...
    0.625 + 0.01*(topo.topoY(case_ch)+1)/2-topo.topoH/2, ...
    topo.topoW * 0.9, ...
    topo.topoH, ...
    ];
if strcmpi(coi_local, 'FT8')
    topo_local(1:2) = topo_local(1:2) + [+0.03, +0.1];
elseif strcmpi(coi_local, 'FT7')
    topo_local(1:2) = topo_local(1:2) + [-0.03, +0.1];
elseif strcmpi(coi_local, 'T8')
    topo_local(1:2) = topo_local(1:2) + [+0.015, +0.1];
elseif strcmpi(coi_local, 'T7')
    topo_local(1:2) = topo_local(1:2) + [-0.015, +0.1];
elseif strcmpi(coi_local, 'TP8')
    topo_local(1:2) = topo_local(1:2) + [+0.01, +0.08];
elseif strcmpi(coi_local, 'TP7')
    topo_local(1:2) = topo_local(1:2) + [-0.01, +0.08];
elseif strcmpi(coi_local, 'FC1')
    topo_local(1:2) = topo_local(1:2) + [+0.05, 0];
elseif strcmpi(coi_local, 'FC2')
    topo_local(1:2) = topo_local(1:2) + [-0.05, 0];
elseif strcmpi(coi_local, 'FC3')
    topo_local(1:2) = topo_local(1:2) + [+0.025, 0];
elseif strcmpi(coi_local, 'FC4')
    topo_local(1:2) = topo_local(1:2) + [-0.025, 0];
elseif strcmpi(coi_local, 'P3')
    topo_local(1:2) = topo_local(1:2) + [-0.025, 0];
elseif strcmpi(coi_local, 'P4')
    topo_local(1:2) = topo_local(1:2) + [+0.025, 0];
elseif strcmpi(coi_local, 'F3')
    topo_local(1:2) = topo_local(1:2) + [-0.05, 0];   %out
elseif strcmpi(coi_local, 'F4')
    topo_local(1:2) = topo_local(1:2) + [+0.05, 0]; %out
end
ax = subplot('Position', topo_local);
end