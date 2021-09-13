function x_tic_name = set_x_tic_name(n_x_tic, x_tic_name, flag_tic_label_add_bar)

    if size(x_tic_name, 2) < n_x_tic
        for i_tic_name = size(x_tic_name, 2) + 1 : n_x_tic
            x_tic_name{i_tic_name} = 'X';
        end
    end
    
    for i_x_tic = 1 : n_x_tic
        tic_length = length(x_tic_name{i_x_tic});

        if strcmp(x_tic_name{i_x_tic}(1), 'G')
            x_tic_name{i_x_tic} = sprintf('\\Gamma%s',x_tic_name{i_x_tic}(2:tic_length));
        elseif tic_length >= 2 && strcmp(x_tic_name{i_x_tic}(1:2), 'Sg')
            x_tic_name{i_x_tic} = sprintf('\\Sigma%s',x_tic_name{i_x_tic}(3:tic_length));
        end
        tic_length = length(x_tic_name{i_x_tic});

        index_sub = 0;
        x_tic_sub = '';
        if tic_length > 2 && x_tic_name{i_x_tic}(tic_length-1) == '_'
            index_sub = 1;
            x_tic_sub = x_tic_name{i_x_tic}(tic_length);
            x_tic_name{i_x_tic} = x_tic_name{i_x_tic}(1:tic_length-2);
        elseif tic_length > 1 && strcmp(x_tic_name{i_x_tic}(tic_length), '''')
            index_sub = 2;
            x_tic_name{i_x_tic} = x_tic_name{i_x_tic}(1:tic_length-1);
            fprintf('2\n');
        end

        if flag_tic_label_add_bar == 0
            x_tic_name{i_x_tic} = sprintf('%s', x_tic_name{i_x_tic});
        elseif flag_tic_label_add_bar == 1
            x_tic_name{i_x_tic} = sprintf('\\bar{%s}', x_tic_name{i_x_tic});
        elseif flag_tic_label_add_bar == 2
            x_tic_name{i_x_tic} = sprintf('\\tilde{%s}', x_tic_name{i_x_tic});
        elseif flag_tic_label_add_bar == 3
            x_tic_name{i_x_tic} = sprintf('\\hat{%s}', x_tic_name{i_x_tic});
        elseif flag_tic_label_add_bar == 4
            x_tic_name{i_x_tic} = sprintf('\\check{%s}', x_tic_name{i_x_tic});
        end

        if index_sub == 1
            x_tic_name{i_x_tic} = sprintf('%s_%s', x_tic_name{i_x_tic}, x_tic_sub);
        elseif index_sub == 2
            x_tic_name{i_x_tic} = sprintf('%s''', x_tic_name{i_x_tic});
        end
        x_tic_name{i_x_tic} = sprintf('$$\\mathrm{%s}$$', x_tic_name{i_x_tic});
    end
end

