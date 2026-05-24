#!/usr/bin/env python3
"""Extract line-numbered MATLAB files from thesis Coding Appendices.

Input: `pdftotext -layout` output from the coding appendix pages.
Output: source files under `extracted_src/src/chapter*/` plus manifest files.

The parser removes printed code line numbers and joins visual wraps that were introduced
by the PDF layout. It does not rewrite algorithms or validate MATLAB execution.
"""
from pathlib import Path
import re, csv, json, shutil
RAW_PATH = Path("code_appendix_pdftotext_layout_raw.txt")
OUT_ROOT = Path("extracted_src")
safe_dir_map={'1':'chapter1','2':'chapter2','3':'chapter3','4':'chapter4','5':'chapter5','6':'chapter6','7':'chapter7'}
appendix_re=re.compile(r'^\s*CODING APPENDIX\.(\d+)')
section_re=re.compile(r'^\s*(CA\d+\.[a-z]{1,2})\s+(.+?)\s*$')
filename_re=re.compile(r'^\s*Filename:\s*(.+?)\s*$')
standalone_filename_re=re.compile(r'^\s*([A-Za-z][A-Za-z0-9_]*\.m)\s*$')
numbered_re=re.compile(r'^\s*(\d+)\s?(.*)$')

def main():
    raw=RAW_PATH.read_text(errors='replace'); lines=raw.splitlines()
    if OUT_ROOT.exists(): shutil.rmtree(OUT_ROOT)
    (OUT_ROOT/'src').mkdir(parents=True)
    files=[]; current_appendix=None; current_section_id=''; current_section_title=''; collecting_title=False
    current_filename=None; current_lines=[]; expected=1; last_num=0
    def cline(i): return lines[i].replace('\x0c','')
    def next_nonempty_after(i, max_ahead=8):
        for j in range(i+1, min(len(lines), i+1+max_ahead)):
            line=cline(j); s=line.strip()
            if not s: continue
            if s.isdigit() and int(s)>100: continue
            return line
        return ''
    def is_code_start(line):
        m=numbered_re.match(line); return bool(m and int(m.group(1))==1)
    def finalize():
        nonlocal current_filename,current_lines,expected,last_num
        if current_filename is None: return
        subdir=safe_dir_map.get(str(current_appendix), f'appendix{current_appendix or "unknown"}')
        out_dir=OUT_ROOT/'src'/subdir; out_dir.mkdir(parents=True, exist_ok=True)
        out_path=out_dir/current_filename
        if out_path.exists():
            stem=out_path.stem; suff=out_path.suffix; n=2
            while (out_dir/f"{stem}_{n}{suff}").exists(): n+=1
            out_path=out_dir/f"{stem}_{n}{suff}"
        out_path.write_text('\n'.join(current_lines).rstrip()+'\n', encoding='utf-8')
        files.append({'appendix':current_appendix,'section_id':current_section_id,
                      'section_title':' '.join(current_section_title.split()),'filename':current_filename,
                      'path':str(out_path.relative_to(OUT_ROOT)),'line_count':len(current_lines),
                      'last_pdf_line_number':last_num or len(current_lines)})
        current_filename=None; current_lines=[]; expected=1; last_num=0
    for i,raw_line in enumerate(lines):
        line=raw_line.replace('\x0c',''); s=line.strip()
        appm=appendix_re.match(line); secm=section_re.match(line); fnm=filename_re.match(line); sf=standalone_filename_re.match(line)
        if appm:
            finalize(); current_appendix=appm.group(1); current_section_id=''; current_section_title=''; collecting_title=False; continue
        if secm:
            finalize(); current_section_id=secm.group(1); current_section_title=secm.group(2).strip(); collecting_title=True; continue
        if fnm or (sf and current_filename is None and current_section_id and is_code_start(next_nonempty_after(i))):
            finalize(); current_filename=(fnm.group(1) if fnm else sf.group(1)).strip(); current_lines=[]; expected=1; last_num=0; collecting_title=False; continue
        if current_filename is None:
            if collecting_title and s and not s.isdigit() and not s.startswith(('CODING APPENDIX','This is a collection','Resilience |')) and not standalone_filename_re.match(s):
                if len(s)<120 and not s.endswith('.'):
                    current_section_title += ' ' + s
            continue
        if not s or s.startswith('Resilience |') or (not current_lines and s.startswith('(See Coding Appendices')):
            continue
        m=numbered_re.match(line)
        if m:
            num=int(m.group(1)); content=m.group(2)
            if num==expected:
                current_lines.append(content.rstrip()); expected+=1; last_num=num; continue
            if content.strip()=='' and num!=expected:
                continue
        if current_lines:
            current_lines[-1]=current_lines[-1].rstrip()+(' ' if current_lines[-1].strip() else '')+s
    finalize()
    with (OUT_ROOT/'manifest.csv').open('w', newline='', encoding='utf-8') as f:
        writer=csv.DictWriter(f, fieldnames=['appendix','section_id','section_title','filename','path','line_count','last_pdf_line_number'])
        writer.writeheader(); writer.writerows(files)
    (OUT_ROOT/'manifest.json').write_text(json.dumps(files, indent=2, ensure_ascii=False), encoding='utf-8')
if __name__ == '__main__': main()
