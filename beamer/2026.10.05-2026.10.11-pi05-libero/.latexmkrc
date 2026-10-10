# -*-perl-*-
# ============================================================
#  .latexmkrc — 本实验文件夹自包含：中间文件与结果 PDF 全部进 ./pdf/
#
#  用法（必须先 cd 到本文件夹，再执行）：
#      latexmk pi05-libero-beamer      # 编译本实验的独立幻灯片
#      latexmk -C                      # 清理本文件夹的产物
#
#  为什么必须在本文件夹里执行：latexmk 只读取「启动目录」下的 .latexmkrc，
#  根目录与 main/ 各有自己的配置，跨目录执行会拿到别人的配置。
# ============================================================

# 只设 out_dir：latexmk 会把 aux_dir 默认成同一个目录，于是
# .aux .log .nav .snm .xdv .fls 等中间文件与最终 PDF、.synctex.gz 全部落在 ./pdf/。
$out_dir = 'pdf';

# ---------- 使用 XeLaTeX ----------
$pdf_mode = 5;
$xelatex  = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# ---------- 自动重复编译（目录 / 交叉引用 / 页码） ----------
$max_repeat = 5;

# ---------- 参考文献 ----------
$bibtex_use = 2;
# bibtex 在本文件夹下运行，全项目共用的 references.bib 在 main/（../../main/）。
$ENV{'BIBINPUTS'} = $ENV{'BIBINPUTS'} ? "../../main/;.;$ENV{'BIBINPUTS'}" : '../../main/;.';

# ---------- 样式与类文件搜索路径 ----------
# ego-report.sty / ego-beamer.sty 放在 main/（../../main/），而编译目录是本实验文件夹，
# 所以要把 main/ 加进 TEXINPUTS。末尾的分号表示仍保留 TeX 发行版的默认搜索路径。
$ENV{'TEXINPUTS'} = "../../main/;" . (defined $ENV{'TEXINPUTS'} ? $ENV{'TEXINPUTS'} : '');

# ---------- 清理规则 ----------
$clean_ext = 'synctex.gz nav snm xdv run.xml';
