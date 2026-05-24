# Ram Accelerator Thesis MATLAB Code

This repository contains MATLAB code extracted from the Coding Appendices of Conor Stewart McGibboney's thesis, **Ram Accelerator Design Considerations for Aerospace Engineers** (May 2023).

## Provenance

- Source thesis: *Ram Accelerator Design Considerations for Aerospace Engineers*
- Author: Conor Stewart McGibboney
- Degree: Master of Science in Integrated Science and Technology, Southeastern Louisiana University
- Date: May 2023
- DOI supplied for the release: `10.13140/RG.2.2.23186.02248/1`
- Intended GitHub organization: `ram-accelerator-research-group`

## Contents

- Extracted MATLAB files: **90**
- `src/chapter1` through `src/chapter7`: MATLAB files grouped by thesis Coding Appendix chapter.
- `manifest.csv` / `manifest.json`: file-by-file inventory with thesis section IDs and extracted line counts.
- `extraction/code_appendix_pdftotext_layout_raw.txt`: raw `pdftotext -layout` output for the Coding Appendices.
- `extraction/extract_from_pdftotext.py`: reproducibility script for parsing the raw extraction into `.m` files.

## Extracted file inventory

### Coding Appendix 1

- `src/chapter1/billig_diagram.m` - CA1.a Billig Diagram Plotter (359 lines)
- `src/chapter1/integrate_precooled_air_Cp.m` - CA1.b Cool Down Air to Vapor Stagnation Temperature Enthalpy Change (195 lines)
- `src/chapter1/find_T_given_P_for_H.m` - CA1.c Find Temperature for Given Enthalpies and Pressures (74 lines)
- `src/chapter1/MachCalc2.m` - CA1.d Mach Number at Altitude Finder (34 lines)
- `src/chapter1/HFcalc2.m` - CA1.e Intake Heat Flux Calculator (101 lines)
- `src/chapter1/HFntgrnd.m` - CA1.f Differential Heat Flux Per Unit Area (33 lines)
- `src/chapter1/kro.m` - CA1.g Keep Range Only Function (70 lines)
- `src/chapter1/lace_cr_calc_2.m` - CA1.h Condensation Ratio Performance Calculator (222 lines)
- `src/chapter1/billig_anim_3.m` - CA1.i Animated Billig Plotter (500 lines)
- `src/chapter1/aces_cr_calc_5.m` - CA1.k Frontend ACES Function (239 lines)
- `src/chapter1/const_mass_flux_flight_profile_2.m` - CA1.l Air-Breathing Vehicle's Flight Profile (71 lines)
- `src/chapter1/TempAltCS6.m` - CA1.m Atmospheric Temperature Data Lookup (44 lines)
- `src/chapter1/BarForm2.m` - CA1.n Atmospheric Pressure Data Lookup (46 lines)
- `src/chapter1/MachCalc3.m` - CA1.o Mach Numbers that Correspond to the Flight Conditions (50 lines)
- `src/chapter1/StagTemp.m` - CA1.p Calculate Stagnation Temperatures (14 lines)
- `src/chapter1/StagPress.m` - CA1.q Calculate Stagnation Pressures (14 lines)
- `src/chapter1/T_intermediate_calc_4.m` - CA1.r Temperature of the Precooled Air After air/N2 Heat Exchanger (287 lines)
- `src/chapter1/liquefy_air.m` - CA1.s Amount of Enthalpy Needs to be Removed from Air to Liquefy It (68 lines)
- `src/chapter1/integrate_paraH2_Pcrit_Cp_3.m` - CA1.t Integrate the Constant-Pressure Heat Capacity of Parahydrogen (111 lines)
- `src/chapter1/Cp_air_Cp_paraH2_anim.m` - CA1.u ACES Animation (150 lines)

### Coding Appendix 2

- `src/chapter2/gun_calc_SC_ideal.m` - CA2.a Model General Gun Behavior for Nitroglycerin (682 lines)
- `src/chapter2/Maxwell_Boltzmann_1D_molar_mass_abs_temp_vx_vec.m` - CA2.b Maxwell Boltzmann Probability Distributions (43 lines)
- `src/chapter2/PPIG_gun_barrel_length.m` - CA2.c Calculate Length of Barrel of Prelauncher Stage of a Ram Accelerator (34 lines)
- `src/chapter2/shell_w_linearly_varying_P.m` - CA2.d Calculate Section Lengths A Ram Accelerator in Thermally Choked Mode and Oblique Detonation Mode (27 lines)

### Coding Appendix 3

- `src/chapter3/StagTempExpanded.m` - CA3.a Stagnation temperature function for when M = V2 / c2 (15 lines)
- `src/chapter3/lowering_freestream_temp.m` - CA3.b Lowering the freestream temperature plot (20 lines)
- `src/chapter3/adiabatic_flame_temperature_calc_O2_CH4_Ludwig.m` - CA3.c Adiabatic Flame Temperature Calculator (150 lines)

### Coding Appendix 5

- `src/chapter5/Kantrowitz5.m` - CA5.a Kantrowitz Area Ratio Calculator (36 lines)
- `src/chapter5/Isentropic_Area_Ratio_calc.m` - CA5.b Isentropic Area Ratio Calculator (27 lines)
- `src/chapter5/Ram_Area_Ratio_calc.m` - CA5.c Ram Accelerator Projectile Throat to Bore Area Ratio Calculator (25 lines)
- `src/chapter5/inlet_throat_plots_isentropic.m` - CA5.d Isentropic Area Ratio 2D Busemann Geometry Plots (63 lines)
- `src/chapter5/r_throat_calc.m` - CA5.e Throat Radius Calculator (8 lines)
- `src/chapter5/inlet_throat_plots_kantrowitz2.m` - CA5.f Kantrowitz Ratio 2D Busemann Geometry Plots (59 lines)
- `src/chapter5/given_theta_shock_find_theta_cone_4.m` - CA5.g Given θshock find θcone (141 lines)
- `src/chapter5/given_supersonic_cone_find_shock_4.m` - CA5.h Given θcone find θshock (257 lines)
- `src/chapter5/delta_m2_behind_cone_shock.m` - CA5.i Find Delta and M2 Behind Cone Shock (56 lines)
- `src/chapter5/V_prime_r_theta.m` - CA5.j Find the Nondimensional Velocity of Flow Immediately Behind an Oblique Shock (47 lines)
- `src/chapter5/find_v_primes_behind_shock_6.m` - CA5.k Determine The Velocity Components of The Supersonic Flow Over a Quasi- Infinite Cone (70 lines)
- `src/chapter5/taylor_maccoll_3.m` - CA5.l Expression of the Taylor-Maccoll Equation (94 lines)
- `src/chapter5/m2_behind_cone_shock.m` - CA5.m Find M2 Behind an Oblique Shock (57 lines)
- `src/chapter5/delta_behind_cone_shock.m` - CA5.n Find The M2 Deflection Angle Behind an Oblique Shockwave (39 lines)
- `src/chapter5/StagTemp.m` - CA5.o Stagnation Temperature Calculator (16 lines)
- `src/chapter5/StagPress.m` - CA5.p Stagnation Pressure Calculator (18 lines)
- `src/chapter5/tm_plotter_25_curved_shock_intersection.m` - CA5.q Taylor-Maccoll Oblique Shock Relations Model (1166 lines)
- `src/chapter5/V_prime_sys.m` - CA5.r V Prime Function (11 lines)
- `src/chapter5/Mach_sys.m` - CA5.s Find Mach Numbers in System (12 lines)
- `src/chapter5/actual_temp_relationship.m` - CA5.t Find System Temperatures (19 lines)
- `src/chapter5/y_delta.m` - CA5.u Aid for Finding Points in First Ray After Shockwave (8 lines)
- `src/chapter5/Mach_2_2nd_shock.m` - CA5.v M2 Calculator (24 lines)
- `src/chapter5/beta_new_calc.m` - CA5.w βnew Calculator (36 lines)
- `src/chapter5/TM_Busemann_Dimensions.m` - CA5.x Taylor-Maccoll Oblique Shock Relations Busemann Dimensions (92 lines)
- `src/chapter5/toroid_volume_calc.m` - CA5.y Taylor-Maccoll Toroid Volume Calculator (22 lines)
- `src/chapter5/toroid_volume_calc_cone_half_angle.m` - CA5.z Kantrowitz Toroid Volume Calculator (25 lines)
- `src/chapter5/TM_kantro12.m` - CA5.aa Volume Iterations to Satisfy Kantrowitz Limit and the Taylor-Maccoll Oblique Shock Relations (77 lines)

### Coding Appendix 6

- `src/chapter6/convective_heat_flux.m` - CA6.a Convective Heat Transfer Calculation (94 lines)
- `src/chapter6/kantrowitz_hiroshima_ram_tube.m` - CA6.b Efficiency of Radiative Heat Transfer Process for Busemann Toroid That Meets Kantrowitz Ratio Requirements with Internal Hyperbolic Toroid Filled With CubeSats (127 lines)
- `src/chapter6/isentropic_hiroshima_ram_tube.m` - CA6.c Efficiency of Radiative Heat Transfer Process for Busemann Toroid That Meets Isentropic Ratio Requirements with Internal Hyperbolic Toroid (142 lines)
- `src/chapter6/Busemann_toroid_7.m` - CA6.d Construct Meshgrid Matrices for Busemann Toroid (230 lines)
- `src/chapter6/hyperbolic_toroid_for_Busemann_11.m` - CA6.e Construct Hyperbolic Toroid Inside Busemann Toroid (665 lines)
- `src/chapter6/hyperbola_in_right_triangle_4.m` - CA6.e Construct Hyperbolic Toroid Inside Busemann Toroid (154 lines)
- `src/chapter6/A_and_C_equidistant_from_O.m` - CA6.f Complementary Points Equidistant From Origin (34 lines)
- `src/chapter6/hyperbola.m` - CA6.g Hyperbola Generator (20 lines)
- `src/chapter6/largest_quadrilateral_in_hyperbolic_toroid.m` - CA6.h Find Largest Quadrilateral in Hyperbolic Toroid (136 lines)
- `src/chapter6/largest_circle_in_hyperbolic_toroid.m` - CA6.i Find Largest Circle in Hyperbolic Toroid (111 lines)
- `src/chapter6/create_ring_of_boxes_7.m` - CA6.j Create Ring of Boxes Inside Hyperbolic Toroid (693 lines)
- `src/chapter6/Monte_Carlo_view_factor_obstructed_fix_par_2.m` - CA6.k Monte Carlo View Factor Analysis Between Two Obstructed Surfaces (996 lines)
- `src/chapter6/Monte_Carlo_view_factor_27.m` - CA6.l Monte Carlo Unobstructed View Factor Calculator (609 lines)
- `src/chapter6/quadrilateral_pairs_select.m` - CA6.m Sobol Quadrilateral Point Pairs Generator (266 lines)
- `src/chapter6/aug_sobol_select_8.m` - CA6.n Generate Quasi-Randomly Selected Vectors of Adjacent Points on a Surface using Sobol-set Based Routine (267 lines)
- `src/chapter6/diff_view_factor_8.m` - CA6.o Differential View Factor Calculator with Three Normal Orientation Checks (654 lines)
- `src/chapter6/surf_to_area.m` - CA6.p Meshgrid X,Y,Z Surface Points to Area (88 lines)
- `src/chapter6/Bretschneider.m` - CA6.q Bretschneider Calculation Routine (49 lines)
- `src/chapter6/probabilistic_n_point_pairs_select_w_obstruction_3.m` - CA6.r Probabilistic Point Pair Selector (498 lines)
- `src/chapter6/Sobol_learning_system_3.m` - CA6.s Augmented Sobol-set Matrix Probabilistic Weight Assigner (134 lines)
- `src/chapter6/is_ray_obstructed_by_surface_4.m` - CA6.t Check if Ray is Obstructed by a Surface (556 lines)
- `src/chapter6/validate_is_ray_obstructed_by_surface.m` - CA6.u Validate Ray Obstruction Data (230 lines)
- `src/chapter6/make_and_expand_truth_matrix.m` - CA6.v Make and Expand Truth Matrix (183 lines)
- `src/chapter6/scan_meshgrids_for_intersection.m` - CA6.w Scan Meshgrids for Intersection (160 lines)
- `src/chapter6/line_line_intersection.m` - CA6.x Find Intersection of Two Lines (21 lines)
- `src/chapter6/double_check_if_ray_obstructed.m` - CA6.y Rotation Checks for Obstructed Rays (143 lines)
- `src/chapter6/cross_product.m` - CA6.z Cross Product Calculator (18 lines)
- `src/chapter6/dot_product.m` - CA6.aa Dot Product Calculator (10 lines)
- `src/chapter6/line_intersects_plane.m` - CA6.bb Find Where a Line Intersects a Plane (150 lines)
- `src/chapter6/magnitude.m` - CA6.cc Functions for Finding Magnitude (15 lines)
- `src/chapter6/magnitude_for_matrices.m` - CA6.cc Functions for Finding Magnitude (15 lines)
- `src/chapter6/right_triangle_with_quasi_hyperbola.m` - CA6.dd Right Triangle with Quasi Hyperbola (107 lines)
- `src/chapter6/square_annular_toroid.m` - CA6.ee Square Annular Toroid Symmetric Around the Z-axis (103 lines)
- `src/chapter6/circular_toroid.m` - CA6.ff Draw Circular Toroid (94 lines)
- `src/chapter6/plot_Monte_Carlo_obstructed_view_factor_stuff.m` - CA6.gg Plot View Factors from Specified Monte Carlo Run (213 lines)

### Coding Appendix 7

- `src/chapter7/integrated_torque_on_frustum_as_fxn_of_z_offset.m` - CA7.a Calculate Torque on Frustrum (50 lines)


## External files not present in the PDF

The extracted code references two MATLAB data files that were not embedded in the thesis PDF and therefore are not included here:

- `alttemp2.mat` used by `src/chapter1/TempAltCS6.m`
- `altpress2.mat` used by `src/chapter1/BarForm2.m`

Those should be added separately, regenerated from the U.S. Standard Atmosphere 1976 tables used in the thesis, or replaced with code that computes the lookup tables directly.

## MATLAB dependencies and portability notes

Several Chapter 1 routines call NIST REFPROP via `refpropm` and include Windows-specific REFPROP paths such as `C:\Program Files (x86)\REFPROP`. Before running those files, update REFPROP installation paths for your machine and confirm that the REFPROP MATLAB interface is installed and on the MATLAB path.

The extraction process removed PDF line numbers and joined visual line wraps. It did **not** rewrite algorithms, modernize MATLAB style, or validate scientific results. Review and test all code before public release.

## Suggested first GitHub commit

```bash
git init
git add .
git commit -m "Extract MATLAB code from thesis coding appendices"
git branch -M main
# Replace <repo-name> with the repository you create under the group organization:
git remote add origin git@github.com:ram-accelerator-research-group/<repo-name>.git
git push -u origin main
```

## Licensing

No open-source license has been selected in this extraction bundle. Add a `LICENSE` file before public release if you want others to have explicit reuse rights.
