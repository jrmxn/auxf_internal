function a = glob_single(x, varargin)
d.multi_match_rule = 'error';
d.exclude = [];
d.overwrite = false;
d.d_overwrite = struct;

%% Parse input
[v, d] = inputParserCustom(d, varargin);clear d;
v = inputParserStructureOverwrite(v);

%%
a = glob(x);

case_exclude = false(size(a));
for ix_exclude = 1:length(v.exclude)
    case_exclude = case_exclude | contains(a, v.exclude(ix_exclude));
end
a(case_exclude) = [];

if isempty(a)
    a = '';
elseif length(a) == 1
    % what we hope for usually...
    a = a{1};
else
    if strcmpi(v.multi_match_rule, 'error')
        disp(a);
        error('more than one glob match ^.');
    elseif strcmpi(v.multi_match_rule, 'numerical_v_max')
        % File names need a string with _v01_ or _v4_ etc. in them
        b = cell(size(a));
        for ix_b = 1:length(b)
            [~, b{ix_b}, ~] = fileparts(a{ix_b});
        end
        b_ver = nan(size(b));
        for ix_b_ver = 1:length(b)
            b_ver_ = extractBetween(b{ix_b_ver}, '_v', '_');
            assert(length(b_ver_)<=1, '?');
            if isempty(b_ver_)
                b_ver(ix_b_ver) = 0;
            else
                b_ver(ix_b_ver) = str2double(b_ver_{1});
            end
        end
        [~, ix_max] = max(b_ver);
        a = a{ix_max};
        disp(a);
    end
end
end