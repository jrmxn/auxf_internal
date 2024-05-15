function df = convert_table_to_df(T)
% Convert MATLAB table to cell array and extract column names
data = table2cell(T);
column_names = T.Properties.VariableNames;

% Initialize an empty Python list for the data
py_data_list = py.list();

% Populate the Python list directly
for i = 1:size(data, 1)
    row_data = data(i, :);
    for j = 1:length(row_data)
        if ischar(row_data{j})
            row_data{j} = py.str(row_data{j});
        elseif isnumeric(row_data{j})
            row_data{j} = py.float(row_data{j}); % using py.float for general numeric types
        end
    end
    py_row_list = py.list(row_data);
    py_data_list.append(py_row_list);  % Append each row list to the main list
end

py_column_names = py.list(column_names);

% Import pandas and create DataFrame
pd = py.importlib.import_module('pandas');
df = pd.DataFrame(py_data_list, pyargs('columns', py_column_names));
end