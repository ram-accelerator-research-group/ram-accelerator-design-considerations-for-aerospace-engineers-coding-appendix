# Ram Accelerator Thesis MATLAB Code v0.1.0

This is the first release candidate for the MATLAB code extracted from the Coding Appendices of Conor Stewart McGibboney's thesis, *Ram Accelerator Design Considerations for Aerospace Engineers*.

## Included

- 90 extracted MATLAB source files.
- Chapter-based source layout under `src/`.
- File inventory in both CSV and JSON formats.
- Extraction notes and the raw `pdftotext -layout` source used for reconstruction.
- Citation metadata in `CITATION.cff`.

## Known Limitations

- No open-source license has been selected yet.
- `alttemp2.mat` and `altpress2.mat` are referenced by Chapter 1 routines but are not included in the thesis PDF extraction.
- Several Chapter 1 scripts rely on REFPROP and may need local path updates before running.
- The extracted code preserves thesis appendix logic and has not yet received a full MATLAB validation pass.

## Suggested GitHub Release

- Tag: `v0.1.0`
- Title: `Ram Accelerator Thesis MATLAB Code v0.1.0`
- Attachments:
  - GitHub-generated source archive
  - Optional local release archive generated from this repository

## Validation

- File inventory reviewed.
- Repository metadata prepared.
- MATLAB scientific results not independently validated for this release candidate.
