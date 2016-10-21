clc
%close all
clear


data = importdata('data\QQ0904.txt');

%% Normalize
[data_norm, data_mean, data_std] = Normalize(data);
lambda = 637e-9;
lambda_norm = (lambda - data_mean(4)) / data_std(4);
N = size(data, 1);

%% J1: Only use lambda (Flat)
J1 = (data_norm(:, 4) - lambda).^2;
[J1_sort, J1_index] = sort(J1);
y1 = (J1_sort - J1_sort(1)) / (J1_sort(N) - J1_sort(1));
x1 = (0 : N - 1) / (N - 1);
figure(1);
subplot(1,3,1);
plot(x1, y1); hold on;
title('Wavelegth deviation');

%% J2: Only use Q (Flat)
%J2 = exp(-data_norm(:, 3));
J2 = (-data_norm(:, 3));
[J2_sort, J2_index] = sort(J2);
y2 = (J2_sort - J2_sort(1)) / (J2_sort(N) - J2_sort(1));
x2 = (0 : N - 1) / (N - 1);
subplot(1,3,2);
plot(x2, y2); hold on;
title('Q-factor');

%% J3: Combine lambda and Q (Flat)
theta = 0.9;
J3 = theta * J1 + (1 - theta) * J2;
[J3_sort, J3_index] = sort(J3);
y3 = (J3_sort - J3_sort(1)) / (J3_sort(N) - J3_sort(1));
x3 = (0 : N - 1) / (N - 1);
subplot(1,3,3);
plot(x3, y3); hold on;
title('Pareto');



data = importdata('data\QQ0929.txt');

%% Normalize
[data_norm, data_mean, data_std] = Normalize(data);
lambda = 637e-9;
lambda_norm = (lambda - data_mean(4)) / data_std(4);
N = size(data, 1);

%% J1: Only use lambda (Flat)
J1 = (data_norm(:, 4) - lambda).^2;
[J1_sort, J1_index] = sort(J1);
y1 = (J1_sort - J1_sort(1)) / (J1_sort(N) - J1_sort(1));
x1 = (0 : N - 1) / (N - 1);
figure(1);
subplot(1,3,1);
plot(x1, y1,'-.'); hold on;
title('Wavelegth deviation');

%% J2: Only use Q (Flat)
%J2 = exp(-data_norm(:, 3));
J2 = (-data_norm(:, 3));
[J2_sort, J2_index] = sort(J2);
y2 = (J2_sort - J2_sort(1)) / (J2_sort(N) - J2_sort(1));
x2 = (0 : N - 1) / (N - 1);
subplot(1,3,2);
plot(x2, y2,'-.'); hold on;
title('Q-factor');

%% J3: Combine lambda and Q (Flat)
theta = 0.9;
J3 = theta * J1 + (1 - theta) * J2;
[J3_sort, J3_index] = sort(J3);
y3 = (J3_sort - J3_sort(1)) / (J3_sort(N) - J3_sort(1));
x3 = (0 : N - 1) / (N - 1);
subplot(1,3,3);
plot(x3, y3,'-.'); hold on;
title('Pareto');


%% Flat type
Z1 = 8.1378;
Z2 = 0.8974;
Z3 = -1.2058;
Z4 = 6;

%% Steep Type
% Z1 = 8.1998;
% Z2 = 1.9164;
% Z3 = -2.0250;
% Z4 = 10;

k = 1;
g = 20;
Z = exp(Z1) * k^Z2 * g^Z3 + Z4;

s = round(Z); %Selected set number
s_set = J1_index(1:s);
s_set_para = data(s_set, 1:2)