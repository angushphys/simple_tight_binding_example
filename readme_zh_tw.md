緊束縛模型 (tight-binding model) 的簡單範例
=======================================
這是一個用 matlab 寫成，用只包含最近鄰跳躍常數 (hopping constant)
的緊束縛模型 (tight-binding model) 來計算石墨烯 (graphene) 能帶結構
的簡單例子。
你可以自行修改檔案 `wan_basis.mat` 來計算其他材料。

![image](https://github.com/angushphys/simple_tight_binding_example/blob/main/graphene_band.png)

這個套件包含:

* 主程式: `wannier_band.m`
* 輸入檔: `KPOINTS`, `wan_basis.mat`
* 函式檔: `set_x_tic_name.m` `get_the_k_points.m`

## wannier_band.m
包含程式的主要部分

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
描述繪製能帶結構的路徑。
這個檔案和 [VASP's KPOINTS](https://www.vasp.at/wiki/index.php/KPOINTS) 格式相同。

## wan_basis.mat
描述跳躍常數 (hopping constants) 和石墨烯的其他參數。

`wan_basis` 中的變數:
* `n_band`: 軌域的數目
* `hopping`: 與 [Wannier90](http://www.wannier.org/) 的 `wannier90_hr.dat` 格式類似
  * `orbit_0`: 跳躍起始的軌域
  * `orbit_R`: 跳躍結束的軌域
  * `t`: 跳躍常數 (單位 eV)
  * `R`: 跳躍的距離 (以晶格大小為單位)
* `lattice_a`: 實空間晶格結構 (單位 Angstrom)
* `lattice_b`: 倒空間晶格 (單位 Angstrom^-1)

石墨烯在這個例子的 `wan_basis.hopping` (`n_band = 2`)
|orbit_0|orbit_R|   t   |  R(1) |  R(2) |  R(3) |
| :---: | :---: | :---: | :---: | :---: | :---: |
|   1   |   2   |  3.16 |  -1   |   0   |   0   |
|   2   |   1   |  3.16 |   0   |  -1   |   0   |
|   1   |   2   |  3.16 |   0   |   0   |   0   |
|   2   |   1   |  3.16 |   0   |   0   |   0   |
|   1   |   2   |  3.16 |   0   |   1   |   0   |
|   2   |   1   |  3.16 |   1   |   0   |   0   |

石墨烯的 `wan_basis.lattice_b` (`lattice_b(3,3)` 取決於真空層大小)
|  b(:,1)  |  b(:,2)  |  b(:,3)  |
| :------: | :------: | :------: |
| 2.554140 | 0.000000 | 0.000000 |
| 1.474634 | 2.949267 | 0.000000 |
| 0.000000 | 0.000000 | 0.314159 |
