%%
% Calculate band structure by Wannier/tight-binding 
%
% @Date   2021-09-13
% @Author YC Angus Huang
%
% This program need 2 input
% KPOINTS    Path of band calculation
% wan.mat    Wannier hopping parameters
%
% function
%  get_the_k_points
%  set_x_tic_name

clear;

%%

% Fermi level
E_f = 0;

% Energy Max and min, 0 = Fermi level
E_min =  -12;
E_max =   12;

% kpoint number for each k line
n_k_each_line = 31;

% Name of High symmetry points
x_tic_name = {'G' 'M' 'K' 'G'};

% 0 => not thing, 1 => bar, 2 => tilde, 3 => hat, 4 => check
flag_tic_label_add_bar = 0;

%%
% Load hopping constant
load wan_basis

lattice_b = wan_basis.lattice_b;
hopping = wan_basis.hopping;

%%
% Read line mode KPOINTS to get the all k-points for draw band structure
[n_k, k_direct_all, k_axis, n_x_tic, x_tic] = ...
    get_the_k_points('KPOINTS', lattice_b, n_k_each_line);

%%
% Main Part of Program

% Prepare matrix to store hamitonian and eigenval
H_k = zeros(wan_basis.n_band, wan_basis.n_band);
H_eig_0 = zeros(n_k, wan_basis.n_band);

fprintf('  Begin To Calculate Eigenvalues...\n');

% The Main Loop, Get Eigenvalues for each k-points
for i_k = 1 : n_k
    k_direct = k_direct_all(:, i_k);

    % generate Hamitonian from hopping constant
    % Hk(a, b) = sum(over R){ t(a, b) * exp(i * 2 pi * k dot R) }
    H_k = full(sparse( ...
            hopping.orbit_0, hopping.orbit_R,...
            exp(2i * pi* hopping.R * k_direct) .* hopping.t, ...
            wan_basis.n_band, wan_basis.n_band));

    H_k = (H_k + H_k') / 2;  % H_k = H_k + h.c.

    % Get the band structure by solving eigenvalue problem
    H_eig_0(i_k, :) = eig(H_k);

    % Print Process
    if mod(i_k, n_k_each_line) == 0
        fprintf('  Finish Calculate %2d line...\n', i_k/n_k_each_line);
    end

    if mod(i_k, 200) == 0
        fprintf('  --->Finish Calculate %4d k-points...\n', i_k);
    end
end

fprintf('  Finish All Eigenvalues Calculations\n\n');

%%
% Set the format of axis tick
% change G -> Gamma, Sg -> Sigma
x_tic_name = set_x_tic_name(n_x_tic, x_tic_name, flag_tic_label_add_bar);

%%
% Plot the result

H_eig = H_eig_0 - E_f;
is_plot_E_f_line = true;
is_plot_tic_line = true;

figure('Position', [20, 60, 560, 600]);
subplot('Position', [0.16, 0.08, 0.80, 0.85]);

if is_plot_E_f_line
    plot( ...
        [x_tic(1) x_tic(n_x_tic)], ...
        [0 0], '--', ...
        'Color', [0.7 0.7 0.7], ...
        'LineWidth', 2);
    hold on;
end

if is_plot_tic_line
    for i_x_tic = 2 : n_x_tic - 1
        plot( ...
            [x_tic(i_x_tic) x_tic(i_x_tic)], ...
            [E_min E_max], '--', ...
            'Color', [0.7 0.7 0.7], ...
            'LineWidth', 2);
        hold on;
    end
end

plot(k_axis, H_eig, '-b', 'LineWidth', 2);
hold on;
axis([-inf, Inf, E_min, E_max]);

ylhand = get(gca, 'ylabel');
set(ylhand, 'string', 'Energy (eV)', ...
    'fontsize', 20, ...
    'color', 'k');
set(gca, ...
    'XTick', x_tic, ...
    'XTickLabel', x_tic_name, ...
    'LineWidth', 1, ...
    'FontSize', 18, ...
    'TickLabelInterpreter', 'latex', ...
    'FontName', 'Times New Roman' , ...
    'TickDir', 'out', ...
    'TickLength', 1.5*get(gca,'TickLength') );

