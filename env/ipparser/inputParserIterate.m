function T = inputParserIterate(f, opt, varargin)
% Iterate function f evaluation over every combination of varargin
% where varargin is in the form:
% 'variable_name1', vector_of_variable1, 'variable_name2', vector_of_variable2, ...
% f should be a function handle pointing to some core function that needs
% to be evaluated - but with only varargin options.

% The core function must spit out a single output structure e.g., the
% variable o after loading it: o.x = 1, o.y = 2; etc.

% You can easily add more parameters in the sense that on one run you pass
% e.g. 'vec_K', [1:10], and if you pass it again but as 'vec_K', [1:12] the
% program should append the new K = 11 and K = 12 combinations without
% re-running all previous cases. But ...

% TODO: it's not easy to add an entirely new variable - only to extend
% existing ones at the moment. Would probably be doable though.

% E.g.:
% redefine core function in function handle, making sure to remove all
% inputs other than varargin_
% fh_local = @(varargin_) example_core_function(fixed_input, varargin_);
% o = inputParserIterate(fh_local, 'f_alpha', vec_f_alpha, ...
%     'A_noise', vec_A_noise, ...
%     'x', vec_x);

% function o = example_core_function(fxed_input, varargin_)
% d.d_overwrite = struct; %this is necessary
% % these have to match what is specificied in the iterate_over_fh function
% d.f_alpha = 1;
% d.A_noise = 2;
% d.x = 'g';
% %%
% opt = [];
% [v, d] = inputParserCustom(d, opt, varargin_);clear d;
% v = inputParserStructureOverwrite(v);
% %% write operations here
% o.value = fxed_input + v.f_alpha + v.A_noise ;
% o.some_other_thing = v.x;
% end
% % % % % % % % % % % % % % % % % % % % % % % %

opt = defaultOpt(opt);

%
p = reshape(varargin, [2, length(varargin)/2]);

A = generate_varargin_combinations(p);

% flatten
for ix = 1:size(p, 2)
    A.(sprintf('S%d', ix)) = A.(sprintf('S%d', ix))(:);
end

A = struct2table(A);
A.Properties.VariableNames = p(1, :);

% 
vec_comb = 1:size(A, 1);

% resume if previously attempted and interrupted
if not(isempty(opt.load_location))
    fprintf('Loading previous progress...');
    if exist(opt.load_location, 'file') == 2
        tempAT = load(opt.load_location);
        if not(isequaln(A, tempAT.A))
            [A_new, iA] = setdiff(A, tempAT.A);
        end
        A = [tempAT.A; A_new];
        T = tempAT.T;
        clear tempAT;
        vec_comb = (length(T) + 1):size(A, 1);
        fprintf('Loaded %d combinations out of %d\n', length(T), size(A, 1))
    else
        fprintf('\nPrevious progress does not exist.\nStarting from scratch\n');
    end
end
% now evaluate each row.
if opt.progress_show
    fprintf('Will iterate over %d combinations\n', length(vec_comb));
    progress_n = round(length(vec_comb) / opt.progress_fraction);
end
for ix_vec_comb = 1:length(vec_comb)
    ix_comb = vec_comb(ix_vec_comb);
    
    varargin_ = table2struct(A(ix_comb,:));
    
    rng(opt.rng);
    T(ix_comb).output = f([{'d_overwrite'}, varargin_]);
    % you could check T(ix_comb).output.v against other entries here if you
    % want
    
    if not(isnan(opt.save_every))
        if or(mod(ix_comb, opt.save_every) == 0, ix_vec_comb == vec_comb(end))
            if opt.progress_show
                fprintf('Checkpoint\n');
            end
            save(opt.save_location, 'T', 'A');
        end
    end
    
    if and(opt.progress_show, mod(ix_vec_comb, progress_n) == 0)
        %         fprintf(repmat('\b', 1, length(progress_string)));
        progress_string = sprintf('Progress: %02d%s\n', ...
            round(100 * (ix_vec_comb/length(vec_comb))), '%%');
        fprintf(progress_string);
    end
end

if opt.progress_show
    fprintf('All combinations tested.\n');
end
T = [A, struct2table(T)];
end

function opt = defaultOpt(opt)

if not(isstruct(opt))
    if isempty(opt)
        opt = struct;
    else
        error('opt should be a struct!');
    end
end

if not(isfield(opt, 'load_location'))
    opt.load_location = '';
end

if not(isfield(opt, 'save_location'))
    opt.save_location = fullfile(pwd, 'inputParserIterate_temp.mat');
end

if not(isfield(opt, 'save_every'))
    opt.save_every = nan; %  you can set it to zero to only save at the end
end

if not(isfield(opt, 'rng'))
    opt.rng = rng('shuffle');
end

if not(isfield(opt, 'progress_show'))
    opt.progress_show = true;
end

if not(isfield(opt, 'progress_fraction'))
    opt.progress_fraction = 5; %  percentage progress at which to show
end

end

function A = generate_varargin_combinations(p)
%this is ugly - but couldn't think of a better way

s = "[";
for ix = 1:size(p, 2)
    s = s + sprintf('A.S%d, ', ix);
end
s = char(s);
s = s(1:end-2);
s = s + "]";

s = s + " = ndgrid(";

for ix = 1:size(p, 2)
    s = s + sprintf('p{2, %d}, ', ix);
end

s = char(s);
s = s(1:end-2);
s = s + ");";

% generate a meshgrid of inputs
eval(s);
end


function o = example_core_function(fixed_input, varargin)
d.d_overwrite = struct; %this is necessary
% these have to match what is specificied in the iterate_over_fh function
d.f_alpha = 1;
d.A_noise = 2;
d.x = 'g';
%%
if all(size(varargin)==[1,1]),varargin = varargin{1};end % this is in case varargin has been pre-packaged
[v, d] = inputParserCustom(d, varargin);clear d;
v = inputParserStructureOverwrite(v);
%% write operations here
o.value = fixed_input + v.f_alpha + v.A_noise ;
o.some_other_thing = v.x;
end


