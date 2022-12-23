function fileLoc = printForPub(fig, fName, varargin)
%%
% printForPub(gcf,[figuredir_png filesep extendStyle_s extraString '_' sub],...
%     'figformat','png','physicalSizeCM',[17.5 17.5]);
%%
% Updated: 2020-05-29 to split figformat so you can specifiy e.g. pdf_png
% Updated: 2020-05-29 so that you can append format to dir
% Updated: 2020-06-19 add InvertHardcopy (def: 'off') for background color
% Updated: 2020-10-25 added figformat from env to overwrite if present
% Updated: 2021-09-01 added jpg/jpeg option
% Updated: 2022-09-01 added autoclose
%%
p = inputParser;
p.addParameter('physicalSizeCM', [10 10]);
p.addParameter('fontname', 'Verdana');
p.addParameter('fontsizeText', 9);
p.addParameter('fontsizeAxes', 8);
p.addParameter('doPrint', true);
p.addParameter('figformat','svg');
p.addParameter('fformat','');
p.addParameter('autopos', false);
p.addParameter('saveDir', fullfile(pwd));
p.addParameter('append_format_to_dir', false);
p.addParameter('InvertHardcopy', 'off');
p.addParameter('autoclose', false);

p.parse(varargin{:});
save_dir = p.Results.saveDir;
set(fig,'Units','centimeters');%size of figure on screen will be in cm
physicalSizeCM = [0,0,p.Results.physicalSizeCM];
if p.Results.autopos
    %     a = get(0, 'MonitorPositions');
    physicalSizeCM = [-25,-5,fig.Position(3),fig.Position(4)];
end

if not(exist(save_dir, 'dir')==7), mkdir(save_dir);end

doPrint = p.Results.doPrint;
v.figformat = p.Results.figformat;
fontname = p.Results.fontname;
fontsizeText = p.Results.fontsizeText;
fontsizeAxes = p.Results.fontsizeAxes;
append_format_to_dir = p.Results.append_format_to_dir;
InvertHardcopy = p.Results.InvertHardcopy;
autoclose = p.Results.autoclose;
fileLoc = '';

if not(isempty(p.Results.fformat))
    v.figformat = p.Results.fformat;
end
FIGFORMAT = getenv('FIGFORMAT');
if not(isempty(FIGFORMAT))
    v.figformat = FIGFORMAT;
%     warning('Grabbing figure format from environment variable: %s', v.figformat);
end

try
    %should probably change the next line
    set(0,'defaulttextinterpreter','tex');
    %     set(0,'defaultaxesfontname',fontname);set(0,'defaulttextfontname',fontname);
    %     set(0,'defaultaxesfontsize',fs);set(0,'defaulttextfontsize',fs-1);
    
    set(fig,'Position',physicalSizeCM + [2.5 2.5 0 0]);%This line sets on-screen figure size (and position)
    set(fig,'PaperPositionMode','manual');%This has to be manual or the distinction between position and paperposition does not work
    
    set(fig,'PaperUnits','centimeters');%Paper units
    set(fig,'PaperPosition',[0 0 physicalSizeCM(3) physicalSizeCM(4)]);%Think paper pos might be for non vector graphics saving
    set(fig,'PaperSize',[physicalSizeCM(3) physicalSizeCM(4)]);%Size for vector graphics saving
    
    if strcmpi(InvertHardcopy, 'off')
        set(fig, 'Color', 'w');
    end
    set(fig, 'InvertHardcopy', InvertHardcopy);
    
    fs_properties = findall(fig,'-property','FontSize');
    fs_properties_types = arrayfun(@(x) x.Type, fs_properties,'UniformOutput',0);
    set(fs_properties(strcmpi(fs_properties_types,'Text')),'FontSize',fontsizeText);
    set(fs_properties(strcmpi(fs_properties_types,'axes')),'FontSize',fontsizeAxes);
    set(findall(fig,'-property','FontName'),'FontName',fontname);
    
    
    if doPrint
        cell_figformat = strsplit(v.figformat, '_');
        for ix_cell_figformat = 1:length(cell_figformat)
            save_figformat = cell_figformat{ix_cell_figformat};
            if append_format_to_dir
                save_dir_local = fullfile(save_dir, save_figformat);
            else
                save_dir_local = save_dir;
            end
            if not(exist(save_dir_local, 'dir')==7), mkdir(save_dir_local);end
            
            
            if strcmpi(save_figformat, 'meta')
                print(fig ,['-d' save_figformat]);
            else
                if strcmpi(save_figformat, 'epsc'),ext = 'eps';
                elseif strcmpi(save_figformat, 'epsc2'),ext = 'eps';
                else
                    ext = save_figformat;
                end
                
                fileLoc = fullfile(save_dir_local, sprintf('%s.%s', fName, ext));
                if strcmpi(save_figformat, 'png')
                    print(fig, fileLoc, ['-d', save_figformat], '-r300');
                elseif strcmpi(save_figformat, 'jpg') || strcmpi(save_figformat, 'jpeg')
                    print(fig, fileLoc, ['-d', 'jpeg'], '-r300');
                elseif strcmpi(save_figformat, 'fig')
                    saveas(fig, fileLoc);
                else
                    print(fig, fileLoc, ['-d', save_figformat], '-vector');
                end
            end
        end
    end
    if autoclose
        close(fig);
    end
catch errt
    warning('Save figure failed');
end
end