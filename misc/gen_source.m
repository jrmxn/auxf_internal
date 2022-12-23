function [str_source, str_type] = gen_source(data_source)
% helper function to convert path into something usable as a filename
cell_source = strsplit(data_source, '/');
str_source = '';
for ix_cell_source = 1:length(cell_source)
    str_source = sprintf('%s_%s', str_source, cell_source{ix_cell_source});
end
str_source = erase(str_source, '_proc');

str_type = strsplit(str_source, '_');
str_type = sprintf('_%s', str_type{2});
end