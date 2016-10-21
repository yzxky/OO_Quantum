function [norm_data, mean_data, std_data] = Normalize(data)
    norm_data = zeros(size(data));
    mean_data = mean(data)
    std_data = std(data)
    for i = 1:size(data, 2)
        norm_data(:, i) = (data(:, i) - mean_data(i)) / std_data(i);
    end