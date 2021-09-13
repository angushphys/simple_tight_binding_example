Simple example of tight-binding model
=======================================
It's a very simple example of matlab program to calculate electric band 
structures of graphene by numerical tight-binding model, with nearest-neighbor 
hopping constant only.
You can also calculate any other materials if modify the `wan_basis.mat` file by 
yourself. 

![image](https://github.com/angushphys/simple_tight_binding_example/blob/main/graphene_band.png)

This package including:

* Main program: `wannier_band.m`
* Input files: `KPOINTS`, `wan_basis.mat`
* Functions: `set_x_tic_name.m` `get_the_k_points.m`

## wannier_band.m
Including the main part of program.

``` matlab
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
end
```

## KPOINTS
Descript the path of plotting band structure.
This file is in format of [VASP's KPOINTS](https://www.vasp.at/wiki/index.php/KPOINTS).

## wan_basis.mat
Descript the hopping constants of graphene.
The format of wan_basis.hopping in this file is similar to the 
wannier90_hr.dat of [Wannier90](http://www.wannier.org/).

The variable in `wan_basis`:
* `n_band`: number of orbitals
* `n_hopping`: number of hoppings
* `hopping`: similar format with `wannier90_hr.dat`
  * `orbit_0`: hopping from this orbit
  * `orbit_R`: hopping to this orbit
  * `t`: hopping constance
  * `R`: hopping distance, by unit of cell with integer
  * `R_x_all`: hopping distance, by unit of cell (unused in this example)
  * `orbit_0_x_all`: positions of orbit_0 (unused in this example)
* `lattice_a`: lattice structure of real space
* `lattice_b`: reciprocal lattice
