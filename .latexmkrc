# -*-perl-*-
# ============================================================
#  .latexmkrc — 中间文件进 build/，结果 PDF 与 .tex 同目录
#  用法（在项目根目录执行）：
#      latexmk report      # 编译报告（自动跑 xelatex + bibtex + 重跑）
#      latexmk slides      # 编译幻灯片
#      latexmk -C          # 清理全部产物
# ============================================================

# ---------- 目录布局 ----------
# aux_dir：所有中间文件（.aux .log .toc .bbl .xdv .synctex.gz ...）→ build/
$aux_dir = 'build';
# out_dir：空字符串 = 当前目录，即最终 PDF 与对应 .tex 放在一起
$out_dir = '';

# ---------- 使用 XeLaTeX ----------
$pdf_mode = 5;                                             # 5 = xelatex
$xelatex  = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# ---------- 自动处理重复编译（目录 / 交叉引用 / 页码） ----------
$max_repeat = 5;

# ---------- 参考文献 ----------
$bibtex_use = 2;
# bibtex 在 build/ 下运行，需让它同时在源码根目录查找 .bib
$ENV{'BIBINPUTS'} = $ENV{'BIBINPUTS'} ? ".;$ENV{'BIBINPUTS'}" : '.';

# ---------- 清理规则 ----------
$clean_ext = 'synctex.gz nav snm xdv run.xml';
