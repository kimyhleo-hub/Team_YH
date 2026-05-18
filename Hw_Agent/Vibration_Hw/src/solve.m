% solve.m - Vibration Homework #2
% Problem 1: Harmonic force excitation  f(t) = F*sin(omega*t)
% Problem 2: Base excitation            y(t) = Y*sin(omega*t)

clear; clc; close all;

%% ── 공통 파라미터 ────────────────────────────────────────────
F     = 10;                          % N   , 가진력 진폭 (문제 1)
Y     = 0.01;                        % m   , 바닥 변위 진폭 (문제 2)
omega = linspace(0.1, 160, 3000);    % rad/s, 입력 주파수 벡터

fig_dir = fullfile(fileparts(mfilename('fullpath')), '..', 'figures');
if ~exist(fig_dir, 'dir'), mkdir(fig_dir); end

% 5케이스 구분 색상
clrs = [0.00 0.45 0.74;   % 파랑
        0.85 0.33 0.10;   % 주황
        0.47 0.67 0.19;   % 초록
        0.49 0.18 0.56;   % 보라
        0.93 0.69 0.13];  % 노랑

%% ════════════════════════════════════════════════════════════
%  문제 1  Harmonic Force Excitation
%  X = F / sqrt( (k - m*omega^2)^2 + (c*omega)^2 )
%% ════════════════════════════════════════════════════════════

fprintf('=== Problem 1: Harmonic Force Excitation ===\n');

% ── (a) m 변화 : c=50 N·s/m, k=5000 N/m 고정 ──────────────
c_f = 50;  k_f = 5000;
m_vals = [1, 3, 5, 8, 15];   % kg

fig = figure('Name','P1 Vary m', 'Position',[50 50 900 560]);
hold on;
for i = 1:length(m_vals)
    m = m_vals(i);
    X  = F ./ sqrt((k_f - m*omega.^2).^2 + (c_f*omega).^2);
    wn = sqrt(k_f / m);
    plot(omega, X*1000, 'Color', clrs(i,:), 'LineWidth', 1.8, ...
        'DisplayName', sprintf('m=%2g kg  (\\omega_n=%.1f rad/s)', m, wn));
    fprintf('  m=%2g kg  wn=%5.1f rad/s  X_peak=%7.4f mm\n', ...
        m, wn, max(X)*1000);
end
xlabel('\omega (rad/s)', 'FontSize',12);
ylabel('X (mm)', 'FontSize',12);
title('문제 1: 질량 변위 vs 입력주파수 — m 변화  (c=50 N·s/m, k=5000 N/m)', 'FontSize',12);
legend('Location','northeast','FontSize',10); grid on;
saveas(fig, fullfile(fig_dir, 'p1_vary_m.png'));
fprintf('  → p1_vary_m.png 저장\n\n');

% ── (b) c 변화 : m=5 kg, k=5000 N/m 고정 ───────────────────
m_f = 5;   k_f = 5000;
c_vals = [5, 20, 50, 100, 200];   % N·s/m

fig = figure('Name','P1 Vary c', 'Position',[50 50 900 560]);
hold on;
for i = 1:length(c_vals)
    c = c_vals(i);
    X    = F ./ sqrt((k_f - m_f*omega.^2).^2 + (c*omega).^2);
    zeta = c / (2*sqrt(m_f*k_f));
    plot(omega, X*1000, 'Color', clrs(i,:), 'LineWidth', 1.8, ...
        'DisplayName', sprintf('c=%3g N·s/m  (\\zeta=%.3f)', c, zeta));
    fprintf('  c=%3g N·s/m  zeta=%.3f  X_peak=%7.4f mm\n', ...
        c, zeta, max(X)*1000);
end
xlabel('\omega (rad/s)', 'FontSize',12);
ylabel('X (mm)', 'FontSize',12);
title('문제 1: 질량 변위 vs 입력주파수 — c 변화  (m=5 kg, k=5000 N/m)', 'FontSize',12);
legend('Location','northeast','FontSize',10); grid on;
saveas(fig, fullfile(fig_dir, 'p1_vary_c.png'));
fprintf('  → p1_vary_c.png 저장\n\n');

% ── (c) k 변화 : m=5 kg, c=50 N·s/m 고정 ───────────────────
m_f = 5;   c_f = 50;
k_vals = [1000, 3000, 5000, 8000, 15000];   % N/m

fig = figure('Name','P1 Vary k', 'Position',[50 50 900 560]);
hold on;
for i = 1:length(k_vals)
    k  = k_vals(i);
    X  = F ./ sqrt((k - m_f*omega.^2).^2 + (c_f*omega).^2);
    wn = sqrt(k / m_f);
    plot(omega, X*1000, 'Color', clrs(i,:), 'LineWidth', 1.8, ...
        'DisplayName', sprintf('k=%5g N/m  (\\omega_n=%.1f rad/s)', k, wn));
    fprintf('  k=%5g N/m  wn=%5.1f rad/s  X_peak=%7.4f mm\n', ...
        k, wn, max(X)*1000);
end
xlabel('\omega (rad/s)', 'FontSize',12);
ylabel('X (mm)', 'FontSize',12);
title('문제 1: 질량 변위 vs 입력주파수 — k 변화  (m=5 kg, c=50 N·s/m)', 'FontSize',12);
legend('Location','northeast','FontSize',10); grid on;
saveas(fig, fullfile(fig_dir, 'p1_vary_k.png'));
fprintf('  → p1_vary_k.png 저장\n\n');

%% ════════════════════════════════════════════════════════════
%  문제 2  Base Excitation
%  X  = Y * sqrt(k^2+(c*omega)^2) / sqrt((k-m*omega^2)^2+(c*omega)^2)
%  F_T = m * omega^2 * X       (Newton 2nd law: F_T = m*x'')
%% ════════════════════════════════════════════════════════════

fprintf('=== Problem 2: Base Excitation ===\n');

% ── (a) m 변화 : c=50 N·s/m, k=5000 N/m 고정 ──────────────
c_f = 50;  k_f = 5000;

fig = figure('Name','P2 Vary m', 'Position',[50 50 900 560]);
hold on;
for i = 1:length(m_vals)
    m  = m_vals(i);
    X  = Y .* sqrt(k_f^2 + (c_f*omega).^2) ./ ...
             sqrt((k_f - m*omega.^2).^2 + (c_f*omega).^2);
    FT = m .* omega.^2 .* X;
    wn = sqrt(k_f / m);
    [FTmax, idx] = max(FT);
    boundary = idx >= length(omega) - 5;
    if boundary
        tag = sprintf('[경계값, ω=%.0f]', omega(idx));
    else
        tag = sprintf('[공진, ω=%.1f]', omega(idx));
    end
    plot(omega, FT, 'Color', clrs(i,:), 'LineWidth', 1.8, ...
        'DisplayName', sprintf('m=%2g kg  (\\omega_n=%.1f rad/s)', m, wn));
    fprintf('  m=%2g kg  wn=%5.1f rad/s  FT_max=%7.3f N  %s\n', ...
        m, wn, FTmax, tag);
end
xlabel('\omega (rad/s)', 'FontSize',12);
ylabel('F_T (N)', 'FontSize',12);
title('문제 2: 전달력 vs 입력주파수 — m 변화  (c=50 N·s/m, k=5000 N/m)', 'FontSize',12);
legend('Location','northwest','FontSize',10); grid on;
saveas(fig, fullfile(fig_dir, 'p2_vary_m.png'));
fprintf('  → p2_vary_m.png 저장\n\n');

% ── (b) c 변화 : m=5 kg, k=5000 N/m 고정 ───────────────────
m_f = 5;   k_f = 5000;

fig = figure('Name','P2 Vary c', 'Position',[50 50 900 560]);
hold on;
for i = 1:length(c_vals)
    c    = c_vals(i);
    X    = Y .* sqrt(k_f^2 + (c*omega).^2) ./ ...
               sqrt((k_f - m_f*omega.^2).^2 + (c*omega).^2);
    FT   = m_f .* omega.^2 .* X;
    zeta = c / (2*sqrt(m_f*k_f));
    [FTmax, idx] = max(FT);
    boundary = idx >= length(omega) - 5;
    if boundary
        tag = sprintf('[경계값, ω=%.0f]', omega(idx));
    else
        tag = sprintf('[공진, ω=%.1f]', omega(idx));
    end
    plot(omega, FT, 'Color', clrs(i,:), 'LineWidth', 1.8, ...
        'DisplayName', sprintf('c=%3g N·s/m  (\\zeta=%.3f)', c, zeta));
    fprintf('  c=%3g N·s/m  zeta=%.3f  FT_max=%7.3f N  %s\n', ...
        c, zeta, FTmax, tag);
end
xlabel('\omega (rad/s)', 'FontSize',12);
ylabel('F_T (N)', 'FontSize',12);
title('문제 2: 전달력 vs 입력주파수 — c 변화  (m=5 kg, k=5000 N/m)', 'FontSize',12);
legend('Location','northwest','FontSize',10); grid on;
saveas(fig, fullfile(fig_dir, 'p2_vary_c.png'));
fprintf('  → p2_vary_c.png 저장\n\n');

% ── (c) k 변화 : m=5 kg, c=50 N·s/m 고정 ───────────────────
m_f = 5;   c_f = 50;

fig = figure('Name','P2 Vary k', 'Position',[50 50 900 560]);
hold on;
for i = 1:length(k_vals)
    k  = k_vals(i);
    X  = Y .* sqrt(k^2 + (c_f*omega).^2) ./ ...
             sqrt((k - m_f*omega.^2).^2 + (c_f*omega).^2);
    FT = m_f .* omega.^2 .* X;
    wn = sqrt(k / m_f);
    [FTmax, idx] = max(FT);
    boundary = idx >= length(omega) - 5;
    if boundary
        tag = sprintf('[경계값, ω=%.0f]', omega(idx));
    else
        tag = sprintf('[공진, ω=%.1f]', omega(idx));
    end
    plot(omega, FT, 'Color', clrs(i,:), 'LineWidth', 1.8, ...
        'DisplayName', sprintf('k=%5g N/m  (\\omega_n=%.1f rad/s)', k, wn));
    fprintf('  k=%5g N/m  wn=%5.1f rad/s  FT_max=%7.3f N  %s\n', ...
        k, wn, FTmax, tag);
end
xlabel('\omega (rad/s)', 'FontSize',12);
ylabel('F_T (N)', 'FontSize',12);
title('문제 2: 전달력 vs 입력주파수 — k 변화  (m=5 kg, c=50 N·s/m)', 'FontSize',12);
legend('Location','northwest','FontSize',10); grid on;
saveas(fig, fullfile(fig_dir, 'p2_vary_k.png'));
fprintf('  → p2_vary_k.png 저장\n\n');

fprintf('모든 그래프 저장 완료: %s\n', fig_dir);
