# Ego Research

Ego 研究项目的 LaTeX 源码：一份**总实验报告** + 一套**汇报幻灯片**，两者共用统一样式与图片。

## 目录结构

```
ego-research/
├── report.tex                      # 总实验报告入口
├── slides.tex                      # 当前汇报幻灯片入口
│
├── ego-report.sty                  # 报告统一样式：字体、页边距等
├── ego-slides.sty                  # 幻灯片统一样式：封面、正文、页脚等
│
├── reports/
│   └── experiments/
│       └── ex.tex                  # 单个实验章节
│
├── slides/
│   └── meetings/
│       └── ex.tex                  # 某次汇报正文
│
├── figures/                        # 报告和幻灯片共用图片
│
├── references.bib                  # 参考文献
│
├── .latexmkrc                      # latexmk 配置：产物统一输出到 build/
├── .gitignore                      # 忽略 build/ 与 LaTeX 中间文件
├── .vscode/settings.json           # LaTeX Workshop 输出目录配置
│
├── build/                          # 【自动生成】所有中间文件与结果 PDF
└── README.md
```

## 环境要求

- 任一 TeX 发行版（TeX Live / MiKTeX），需包含 `fontspec`、`beamer`、`libertinus`、`tex-gyre`、`titlesec`、`cleveref` 等宏包。
- **必须用 XeLaTeX（或 LuaLaTeX）编译**：样式文件通过 `fontspec` 按字体名加载 OpenType 字体，pdfLaTeX 不支持。

## 字体

**全项目只使用两个字体家族**：正文 TeX Gyre Termes，标题 Libertinus Serif。报告与幻灯片一致。

| 用途 | 字体 | 定义位置 |
| --- | --- | --- |
| 报告正文 / 幻灯片正文 | TeX Gyre Termes | `\setmainfont`（两个 `.sty` 各一处） |
| 报告标题 / 幻灯片标题 | Libertinus Serif | `ego-report.sty` → `\egoheadingfont`；`ego-slides.sty` → `family=\egoheadingfont` |

均为 TeX 发行版自带字体，无需另行安装。要更换字体，改对应 `.sty` 中的一行即可。

> 幻灯片因为 beamer 默认用无衬线字体，`ego-slides.sty` 里额外加了一句 `\renewcommand{\familydefault}{\rmdefault}` 把正文切回衬线。
> 注意：报告正文里的 `\texttt{...}`（如 abstract 中的路径）仍会引入第三个字体 Latin Modern Mono，若要求严格两种字体，把该处 `\texttt` 去掉即可。

## 编译

所有命令都在**项目根目录**执行。目录布局：

- **结果 PDF 与 `.tex` 同目录**：`report.pdf` / `slides.pdf` 就躺在项目根，方便直接查看；
- **所有中间文件在 `build/`**：`.aux` `.log` `.toc` `.bbl` `.xdv` `*.fdb_latexmk` …
- `.synctex.gz` 会跟着 PDF 留在根目录 —— 这是 SyncTeX 的硬性要求（IDE 里源码 ↔ PDF 跳转靠它），并且已被 `.gitignore` 忽略。

实现方式：`.latexmkrc` 中 `$aux_dir = 'build'` 管中间文件，`$out_dir = ''` 表示 PDF 输出到当前目录。

```bash
latexmk report        # 编译报告（自动 xelatex → bibtex → 重跑到收敛）
latexmk slides        # 编译幻灯片
latexmk -C            # 清理产物
```

> 若连 `.synctex.gz` 也不想留在根目录，把 `.latexmkrc` 里的 `-synctex=1` 改成 `-synctex=0`；代价是 IDE 中无法在源码与 PDF 之间互相跳转。

产物位置：

- 根目录：`report.pdf`、`slides.pdf`（与对应 `.tex` 同目录），以及 `report.synctex.gz`、`slides.synctex.gz`
- `build/`：`.aux`、`.log`、`.toc`、`.bbl`、`.xdv`、`*.fdb_latexmk` 等全部中间文件

目录布局由 [.latexmkrc](.latexmkrc) 控制：`$aux_dir = 'build'`（中间文件）+ `$out_dir = ''`（PDF 用当前目录），同时在这里指定用 XeLaTeX。
若坚持手动编译，可写 `xelatex -output-directory=build report`，但需要自己按 `xelatex → bibtex → xelatex ×2` 的顺序跑，且 PDF 会留在 `build/`，因此**推荐直接用 `latexmk`**。

## 编辑器配置（VS Code / Trae + LaTeX Workshop）

`.vscode/settings.json` 已配置好，让编辑器用 latexmk + XeLaTeX，并按上面的布局放置产物：

- `latex-workshop.latex.outDir = "%DIR%"` —— 告诉编辑器去 `.tex` 同目录找 PDF / synctex。**关键是不要在 `tools.args` 里加 `%OUTDIR%`**，那会覆盖 `.latexmkrc` 的 `$aux_dir` / `$out_dir` 设置。
- `latex-workshop.latex.recipes` / `latex-workshop.latex.tools` —— 定义 `latexmk (xelatex)` 配方并设为默认。
- `latex-workshop.latex.autoBuild.run = "onSave"` —— 保存即编译；想改成手动触发设为 `"never"` 即可。

> 设置改完需要重载窗口（命令面板 → `Developer: Reload Window`）才会生效。

## 目录使用说明

- **新增一个实验**：在 `reports/experiments/` 下新建 `xxx.tex`（参考 `ex.tex`），然后在 `report.tex` 中加一行 `\input{reports/experiments/xxx}`。
- **新增一次汇报**：在 `slides/meetings/` 下新建 `2026-10-08.tex`（参考 `ex.tex`），然后在 `slides.tex` 中把 `\input` 指向该文件，即可切换当前汇报。
- **样式调整**：报告样式统一改 `ego-report.sty`，幻灯片样式统一改 `ego-slides.sty`，不要在正文里零散地改格式。
- **语言约定**：所有 `.tex` / `.sty` / `.bib` 的正文内容与注释统一用**英文**书写。

## 图片同步

- 报告与幻灯片**共用** `figures/` 目录，两个 `.sty` 中已通过 `\graphicspath` 指向该目录，正文里直接写文件名即可，例如 `\includegraphics{method.png}`。
- 建议图片按用途命名（如 `exp1_curve.png`、`arch.png`），避免重名；同一张图在两处复用时无需复制。
- 图源文件（如 `.svg`、`.drawio`、绘图脚本）也建议放在 `figures/` 或其子目录，便于后续更新导出。
