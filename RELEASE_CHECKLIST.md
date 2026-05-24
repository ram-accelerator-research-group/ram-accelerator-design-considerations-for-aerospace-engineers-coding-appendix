# Release checklist

Before making the GitHub repository public:

- Confirm the selected MIT License text in `LICENSE`.
- Add or regenerate missing MATLAB data files: `alttemp2.mat` and `altpress2.mat`.
- Confirm REFPROP / `refpropm` installation instructions for the target platform.
- Replace hardcoded Windows REFPROP paths if the repository should run on Linux/macOS.
- Run a MATLAB smoke test of the major Chapter 1, 5, and 6 routines.
- Decide whether extracted code should remain historically exact or receive a formatting/portability cleanup pass.
- Add example scripts or notebooks showing expected inputs and outputs for the main routines.
