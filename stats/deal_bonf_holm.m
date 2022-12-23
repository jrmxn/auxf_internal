function varargout = deal_bonf_holm(x)
%% make every input to bonf_holm match every output
p = bonf_holm(x);
for k = 1:length(p)
    varargout{k} = p(k);
end
end