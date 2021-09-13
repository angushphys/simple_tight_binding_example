
function [n_k, k_direct_all, k_axis, n_x_tic, x_tic] = ...
        get_the_k_points(f_KPOOINTS_name, lattice_b, n_k_each_line)
    
    clear high_sym_points;
    f_kp = fopen(f_KPOOINTS_name);
    if f_kp <= 0
        error('==  Could not Opne %s!!  ==', f_KPOOINTS_name);
    end

    for i_line = 1:3
        fgets(f_kp);
    end

    kp_mod = fscanf(f_kp, '%c', 1);

    if strcmp(kp_mod, 'R') == 1 || strcmp(kp_mod, 'r') == 1 || ...
            strcmp(kp_mod, 'D') == 1 || strcmp(kp_mod, 'd') == 1

        is_k_direct_coordinate = 1;

    elseif strcmp(kp_mod, 'C') == 1 && strcmp(kp_mod, 'c') == 1

        is_k_direct_coordinate = 0;

    else
        error('== ERROR: Unknow mode of KPOINTS ==');
    end

    fgets(f_kp);
    k_high_sym_points(1, 1:3) = fscanf(f_kp, '%f', 3)';
    fgets(f_kp);
    n_k_high_sym_points = 2;
    while 1
        [sym_point, scan_count] = fscanf(f_kp, '%f', 3);
        if scan_count == 0
            break;
        end

        k_high_sym_points(n_k_high_sym_points,:) = sym_point;

        n_k_high_sym_points = n_k_high_sym_points + 1;
        fgets(f_kp);

        fscanf(f_kp, '%f', 1);
        fgets(f_kp);
    end
    fclose(f_kp);
    clear f_kp kp_mod scan_count;

    if is_k_direct_coordinate == 0
        for i_k = 1 : n_k
            k_high_sym_points(i_k, :) = (lattice_b \ k_high_sym_points(i_k, :)')';
        end
    end

    n_k_high_sym_points = size(k_high_sym_points, 1);
    n_k = n_k_each_line * (n_k_high_sym_points - 1);
    k_direct_all = zeros(3, n_k);

    % Generate kpoints from high_sym_points
    for i_k = 1:(n_k_high_sym_points-1)
        for i_direction = 1 : 3
            k_begin = n_k_each_line*(i_k - 1) + 1;
            k_end = n_k_each_line*i_k;

            k_direct_all(i_direction, k_begin : k_end) = linspace( ...
                k_high_sym_points(i_k, i_direction), ...
                k_high_sym_points(i_k+1, i_direction), ...
                n_k_each_line);
        end
    end

    k_axis = zeros(n_k, 1);
    k_axis(1) = 0;
    n_x_tic = 1;
    x_tic = zeros(2,1);

    for i_k = 2 : n_k
        distance = norm( ...
            lattice_b' * (k_direct_all(:, i_k) - k_direct_all(:, i_k-1)) );

        if distance == 0.0
            distance = eps*100;

            n_x_tic = n_x_tic + 1;
            x_tic(n_x_tic) = k_axis(i_k-1);
        end
        k_axis(i_k) = k_axis(i_k-1) + distance;
    end
    n_x_tic = n_x_tic + 1;
    x_tic(n_x_tic) = k_axis(i_k);

    clear distance;
end

