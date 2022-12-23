function output_string = struct2string(lm,varargin)
%%
vip = inputParser;

%
d_style = 'usable';
v_style = {'usable','display'};
c_style = @(x) any(validatestring(x,v_style));

% This adds a string in front of each fieldname. So that combined with
% usable style, we can copy and paste it as code.
d_prefix = '';

%
d_stringFormat = '%0.4f';

%
addRequired(vip,'lm',@isstruct);
addParameter(vip,'style',d_style,c_style)
addParameter(vip,'prefix',d_prefix,@isstr)
addParameter(vip,'stringFormat',d_stringFormat,@isstr)
parse(vip,lm,varargin{:})

%
lm = vip.Results.lm;
style = vip.Results.style;
prefix = vip.Results.prefix;
stringFormat = vip.Results.stringFormat;
%%
fnlm = fieldnames(lm);
output_string = '';
for i = 1:numel(fnlm)
    val = lm.(fnlm{i});
    if isnumeric(val)
        val = sprintf(stringFormat,val);
    elseif ischar(val)
        %nothing to do
    elseif islogical(val)
        val = double(val);
    elseif isstring(val)
        % do nothing
    elseif iscell(val)
        % cannot handle everything
        if isempty(val)
            val = string(val);
        elseif ischar(val{1})
            val = string(val);
        end
    else
        disp(val);
        error('what is this?');
    end
    if strcmpi(style,v_style{1})%usable
        output_line = sprintf('%s%s = %s;\n',prefix,fnlm{i},val);
    elseif  strcmpi(style,v_style{2})%display
        output_line = sprintf('%s%s: %s\n',prefix,fnlm{i},val);
    end
    output_string = [output_string,output_line];
end
% fprintf(output_string)
end
