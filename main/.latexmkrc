# -*-perl-*-
# ============================================================
#  .latexmkrc — main/ 目录（合并入口）专用：中间文件与结果 PDF 都进 ./pdf/
#
#  用法（先 cd 到 main/ 目录，再执行）：
#      latexmk report      # 合并总报告（自动跑 xelatex + bibtex + 重跑）
#      latexmk beamer      # 合并幻灯片
#      latexmk -C          # 清理 main/ 的产物
#
#  各实验文件夹有自己的 .latexmkrc（产物进各自的 pdf/），
#  那些入口必须在对应文件夹内编译，详见 RULES.md §5。
# ============================================================

# 只设 out_dir：latexmk 会把 aux_dir 默认成同一个目录，于是
# .aux .log .toc .bbl .xdv .fls 等中间文件与最终 PDF、.synctex.gz 全部落在 ./pdf/。
# （synctex 必须与 PDF 同目录，否则 IDE 无法在源码与 PDF 之间跳转）
$out_dir = 'pdf';

# ---------- 使用 XeLaTeX ----------
$pdf_mode = 5;                                             # 5 = xelatex
$xelatex  = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# ---------- 自动处理重复编译（目录 / 交叉引用 / 页码） ----------
$max_repeat = 5;

# ---------- 参考文献 ----------
$bibtex_use = 2;
# bibtex 在 main/ 下运行，references.bib 就在当前目录。
$ENV{'BIBINPUTS'} = $ENV{'BIBINPUTS'} ? ".;$ENV{'BIBINPUTS'}" : '.';

# ---------- 清理规则 ----------
$clean_ext = 'synctex.gz nav snm xdv run.xml';
