clc
close all
clear

%% Load data
data_accur_init = importdata('data\QQ0904.txt');
data_crude_init = importdata('data\QQ0929.txt');
N1 = size(data_accur_init, 1);
N2 = size(data_crude_init, 1);

%% For cases that N1 do not equal N2
data_accur = [];
data_crude = [];
for i = 1 : N1
    index = find(data_crude_init(:, 1) == data_accur_init(i, 1) & ...
                 data_crude_init(:, 2) == data_accur_init(i, 2));
    if (~isempty(index))
        data_accur = [data_accur; data_accur_init(i, :)];
        data_crude = [data_crude; data_crude_init(index, :)];
    end
end

%% Normalize
[data_norm, data_mean, data_std] = Normalize([data_accur;data_crude]);
N1 = size(data_accur, 1);
N2 = size(data_crude, 1);
data_norm_accur = data_norm(1 : N1, :);
data_norm_crude = data_norm(N1 + 1 : N1 + N2, :);
lambda = 637e-9;
lambda_norm = (lambda - data_mean(4)) / data_std(4);

%% Noise Estimation
noise_lambda = mean(data_norm_accur(:, 4) - data_norm_crude(:, 4));
noise_Q = mean(data_norm_accur(:, 3) - data_norm_crude(:, 3)); 

%% J1: Taken only lambda into account (Flat)
% Accurate Model
J1_accur = abs(data_norm_accur(:, 4) - lambda);
[J1_accur_sort, J1_accur_index] = sort(J1_accur);
y1_accur = (J1_accur_sort - J1_accur_sort(1)) / (J1_accur_sort(N1) - J1_accur_sort(1));
x1_accur = (0 : N1 - 1) / (N1 - 1);
figure(1);
% subplot(1,3,1);
accur_curve = plot(x1_accur, y1_accur, 'b-'); hold on;
title('Wavelength deviation');
% Crude Model
J1_crude = abs(data_norm_crude(:, 4) - lambda);
[J1_crude_sort, J1_crude_index] = sort(J1_crude);
y1_crude = (J1_crude_sort - J1_crude_sort(1)) / (J1_crude_sort(N2) - J1_crude_sort(1));
x1_crude = (0 : N2 - 1) / (N2 - 1);
% subplot(1, 3, 1);
crude_curve = plot(x1_crude, y1_crude, 'r-.');
legend([accur_curve, crude_curve], 'Accurate Curve', 'Crude Cruve');

%% Noise evaluation of function J1_crude
noise_J1 = noise_lambda / (J1_crude_sort(N2) - J1_crude_sort(1))

%% Only take wavelength into account (Flat type)
% OO parameters(Small computing budget, N(0, 0.25^2))
Z1 = 7.7731;
Z2 = 0.7264;
Z3 = -1.0167;
Z4 = 2.4674;

% OO parameters (Mideum computing budget, N(0, 0.25^2))
% Z1 = 7.6176;
% Z2 = 0.7065;
% Z3 = -0.9745;
% Z4 = 1.5720;

%% Selected set calculation
k = 1;
g = 10;
s = ceil(exp(Z1) * k^Z2 * g^Z3 + Z4);

%% Selected set number evaluation 
k = 1;
sg_map = zeros(1000, 2);
for g = 1:1000
    sg_map(g, :) = [ceil(exp(Z1) * k^Z2 * g^Z3 + Z4), g];
end 

s_num = 10000; % initial, a considerably large number 
s_table = zeros(size(sg_map, 1), 2);
j = 1;
for i = 1:1000
    if sg_map(i, 1) ~= s_num
        s_num = sg_map(i, 1);
        s_table(j, :) = [sg_map(i, 1), sg_map(i, 2) / N1];
        j = j + 1;
    end
end
s_table(j:size(sg_map, 1), :) = [];
s_table = s_table(size(s_table, 1):-1: 1, :);
save 's_table.txt' 's_table' -ascii;

title = {'Selected Set Number', 'Top %'}
data_cell = mat2cell(s_table, ones(size(s_table, 1), 1), ones(size(s_table, 2), 1));
result = [title; data_cell];
xlswrite('s_table.xls', result);