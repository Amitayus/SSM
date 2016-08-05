% Demo1: estimation of a Nonlinear-Transition function
%
% By Yin Chao yc199303@email.swu.edu.cn
%
% Reference: 
% Tobar, F., P.M. Djuri?, and D.P. Mandic, 
% Unsupervised State-Space Modeling Using Reproducing Kernels.
% IEEE Transactions on Signal Processing, 2015. 63(19): p. 5210-5221.

clc; clear; close all;

% Time series
nx = 1;
nz = 1;
N = 40;

Q = 4;
R = 4;

f_fun_real = @(x) 10*sinc(x/7);

P0_real = 10;
X0_real = sqrt(P0_real)*randn(nx, 1);

X_real(:, 1) = X0_real + sqrt(Q)*randn(nx, 1);
Z_real(:, 1) = X0_real + sqrt(R)*randn(nz, 1);
for k = 2:N
   X_real(:, k) = f_fun_real(X_real(:, k-1)) + sqrt(Q)*randn(nx, 1);
   Z_real(:, k) = X_real(:, k) + sqrt(R)*randn(nz, 1);
end

% typeKernel = 'Gauss';
% paramKernel = 0.2;
% th_ald=0.86;
% index = ALD_F(Z_real, paramKernel, th_ald);
% size(index)
% sv = Z_real(index);
% sv = [-6.2237, 0.0413, 11.3876, 13.7155, 4.4880, -2.9097, 8.6757];
% sv = 0.01*[-0.1884, 7.7666, 2.6337, 12.6129, -2.2763, -4.9422, 4.8453];
% sv = zeros(1, 7);
sv = -10*randn(1, 7)
% sv = -2*rand(1, 7);
%% 函数估计
[f_fun_est1, out_pdf, mix_param] = SSMLearningOffline(Z_real, Q, R, sv);
mix_param
% 0.7519    0.7460    0.7470    0.7369    0.7263    0.7284    0.7682
% 0.7811    0.7830    0.8103    0.7860    0.7888    0.7738    0.7889
% 0.7911    0.7738    0.7811    0.8016    0.7618    0.7614    0.8011
%% 函数估计

%% Plot: test
SetPlotOptions
Range2Plot1 = 1:N-1;

figure; box on; hold on; set(gcf, 'Color', 'White');
plot(Z_real, '-o');
xlabel('Time [Samples]'); title('Observation y_{1:40}');

figure; box on; hold on; set(gcf, 'Color', 'White');
Range2Plot2 = -30:1:30;
plot(Range2Plot2, f_fun_real(Range2Plot2), 'b-');
plot(Range2Plot2, arrayfun(f_fun_est1, Range2Plot2), 'r--');
legend('real', 'est1');
xlabel('x'); ylabel('f(x)');

figure; box on; set(gcf, 'Color', 'White');
semilogy(1:length(out_pdf), out_pdf, 'b-');
xlabel('Time [iteration]');
title('p(a^{(i)} | y_{1:40})');

