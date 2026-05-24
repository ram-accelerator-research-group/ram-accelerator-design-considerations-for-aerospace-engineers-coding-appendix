# Extraction notes

`code_appendix_pdftotext_layout_raw.txt` is the raw output from `pdftotext -layout` over the thesis Coding Appendix pages.

`extract_from_pdftotext.py` reconstructs logical MATLAB files by removing printed PDF line numbers and joining visual line wraps. Lines listed in `extraction_issues.txt` are primarily visual wraps that begin with numeric literals, which the parser preserved by appending them to the previous logical code line.
