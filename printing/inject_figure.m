function cell_h_injected = inject_figure(cell_ax_inject, cell_ax_template, varargin)
% d.pos = [0.6, 0.6, 0.4, 0.4];
d.pos = [0.0, 0.0, 1.0, 1.0];
d.copy_properties = {'XLim', 'YLim', 'XLabel', 'YLabel','YAxisLocation'};%     'XTickLabel', 'XTick', 'YTickLabel', 'YTick'
d.copy_title = false; % there can only be one title... so it gets its own flag
d.close = false;
d.d_overwrite = struct;
%% Parse input
[v, d] = inputParserCustom(d, varargin);clear d;
v = inputParserStructureOverwrite(v);
%%
if v.copy_title
    v.copy_properties = cat(2, v.copy_properties, {'Title'});
end
h_figure_template = cell_ax_template{1}.Parent;  % assume all have same parent...
cell_h_injected = cell(1, length(cell_ax_inject));
for ix_ax_inject = 1:length(cell_ax_inject)
    
    h1 = figure(cell_ax_inject{ix_ax_inject});
    ax_h1 = findall(h1.Children, 'Type', 'Axes');
    assert(length(ax_h1)==1, 'Only equipped to deal with one ax at the moment');
    
    hpos = cell_ax_template{1, ix_ax_inject}.Position;
    hpos(1) = hpos(1) + hpos(3) * v.pos(1);
    hpos(2) = hpos(2) + hpos(4) * v.pos(2);
    hpos(3) = hpos(3) * v.pos(3);
    hpos(4) = hpos(4) * v.pos(4);
    h_injected = axes('Position', hpos, 'Parent', h_figure_template);
    copyobj(ax_h1.Children, h_injected);
    %     copyobj(findall(ax1.Children, 'Type', 'Line'), h_injected);
    
    for ix_copy_properties = 1:length(v.copy_properties)
        h_injected.(v.copy_properties{ix_copy_properties}) = ax_h1.(v.copy_properties{ix_copy_properties});
    end
    h_injected.XAxis.Visible = ax_h1.XAxis.Visible;
    h_injected.YAxis.Visible = ax_h1.YAxis.Visible;
    h_injected.Color = 'none';
    cell_h_injected{1, ix_ax_inject} = h_injected;
    
    h_legend = findall(h1.Children, 'Type', 'Legend');
    if not(isempty(h_legend))
        %         warning('Have not figured out how to copy legends - just add them on manually...');
    end
    
    if v.close
        close(h1);
    end
end
end

