# Ego Research

Ego 研究项目的 LaTeX 源码：一份**总实验报告** + 一套**汇报幻灯片**，两者共用统一样式与图片。

## 目录结构

```
ego-research/
├── report.tex                      # 总实验报告入口（\input 各实验 body）
├── slides.tex                      # 合并幻灯片入口（\input 各实验 deck body）
├── ego-report.sty                  # 报告统一样式：字体、页边距等
├── ego-beamer.sty                  # 幻灯片统一样式：页眉、页脚、背景素材
├── ego-slides.sty                  # 早期通用幻灯片样式（保留，当前无文件引用）
│
├── reports/
│   ├── 2026.10.05-2026.10.11-openwam-libero/
│   │   ├── openwam-libero.tex      # 独立入口：标题 + 摘要 + \input body
│   │   └── body.tex                # 纯正文章节，被独立入口与 report.tex 复用
│   └── 2026.10.05-2026.10.11-pi05-libero/
│       ├── pi05-libero.tex         # 同上
│       └── body.tex
│
├── slides/
│   └── 2026.10.05-2026.10.11-openwam-libero/
│       ├── openwam-libero-slides.tex   # 独立入口：导言区 + \input body
│       └── body.tex                    # 纯帧内容，被独立入口与 slides.tex 复用
│
├── figures/                        # 报告和幻灯片共用图片
│   ├── beamer_background/          # 幻灯片四张视觉素材
│   └── 2026.10.05-2026.10.11-.../  # 与 reports/slides 同名，放图片与 mp4
│
├── references.bib                  # 参考文献
│
├── .latexmkrc                      # latexmk 配置：中间文件到 build/，PDF 到 pdf/
├── .gitignore                      # 忽略 build/ 与 LaTeX 中间文件
├── .vscode/settings.json           # LaTeX Workshop 输出目录配置
│
├── build/                          # 【自动生成】所有中间文件
├── pdf/                            # 【自动生成】最终 PDF 及其 synctex.gz
├── RULES.md                        # 报告/幻灯片构建规范（目录、命名、章节、样式）
└── README.md
```

## 环境要求

- 任一 TeX 发行版（TeX Live / MiKTeX），需包含 `fontspec`、`beamer`、`libertinus`、`tex-gyre`、`titlesec`、`cleveref` 等宏包。
- **必须用 XeLaTeX（或 LuaLaTeX）编译**：样式文件通过 `fontspec` 按字体名加载 OpenType 字体，pdfLaTeX 不支持。

## 字体

**全项目只使用两个字体家族**：正文 TeX Gyre Termes，标题 Libertinus Serif。报告与幻灯片一致。

| 用途 | 字体 | 定义位置 |
| --- | --- | --- |
| 报告正文 / 幻灯片正文 | TeX Gyre Termes | `\setmainfont`（`ego-report.sty` 与 `ego-beamer.sty` 各一处） |
| 报告标题 / 幻灯片标题 | Libertinus Serif | `ego-report.sty` → `\egoheadingfont`；`ego-beamer.sty` → `family=\egoheadingfont` |

均为 TeX 发行版自带字体，无需另行安装。要更换字体，改对应 `.sty` 中的一行即可。

> 幻灯片因为 beamer 默认用无衬线字体，`ego-beamer.sty` 里额外加了一句 `\renewcommand{\familydefault}{\rmdefault}` 把正文切回衬线。
> 注意：报告正文里的 `\texttt{...}`（如 abstract 中的路径）仍会引入第三个字体 Latin Modern Mono，若要求严格两种字体，把该处 `\texttt` 去掉即可。

## 编译

所有命令都在**项目根目录**执行。目录布局：

- **结果 PDF 统一在 `pdf/`**：`pdf/report.pdf` / `pdf/slides.pdf`，根目录保持干净；
- **所有中间文件在 `build/`**：`.aux` `.log` `.toc` `.bbl` `.xdv` `*.fdb_latexmk` …
- `.synctex.gz` 跟着 PDF 一起进 `pdf/` —— 这是 SyncTeX 的硬性要求（IDE 里源码 ↔ PDF 跳转靠它），并且已被 `.gitignore` 忽略。

实现方式：`.latexmkrc` 中 `$aux_dir = 'build'` 管中间文件，`$out_dir = 'pdf'` 管最终 PDF。

```bash
latexmk report        # 编译总报告（自动 xelatex → bibtex → 重跑到收敛）
latexmk slides        # 编译合并幻灯片（两份 deck 全部帧）
latexmk reports/2026.10.05-2026.10.11-openwam-libero/openwam-libero   # 单份实验报告
latexmk slides/2026.10.05-2026.10.11-openwam-libero/openwam-libero-slides   # 单份 deck
latexmk -C            # 清理产物
```

> 报告与幻灯片都采用「独立入口 + `body.tex`」的拆法：`report.tex` / `slides.tex` 是合并入口，各实验的入口文件是它自己的独立 PDF。改 `body.tex` 后两处都要重编。

> 若连 `.synctex.gz` 也不想留在 `pdf/`，把 `.latexmkrc` 里的 `-synctex=1` 改成 `-synctex=0`；代价是 IDE 中无法在源码与 PDF 之间互相跳转。

产物位置：

- `pdf/`：`report.pdf`（总报告）、`slides.pdf`（合并幻灯片）、两份独立报告 PDF、两份独立 deck PDF，以及各自的 `*.synctex.gz`
- `build/`：`.aux`、`.log`、`.toc`、`.bbl`、`.xdv`、`*.fdb_latexmk` 等全部中间文件
- 根目录：只剩源码与配置（`.tex`、`.sty`、`.bib`、`.latexmkrc` 等）

目录布局由 [.latexmkrc](.latexmkrc) 控制：`$aux_dir = 'build'`（中间文件）+ `$out_dir = 'pdf'`（最终 PDF），同时在这里指定用 XeLaTeX。
若坚持手动编译，可写 `xelatex -output-directory=build report`，但需要自己按 `xelatex → bibtex → xelatex ×2` 的顺序跑，且 PDF 会留在 `build/`，因此**推荐直接用 `latexmk`**。

## 编辑器配置（VS Code / Trae + LaTeX Workshop）

`.vscode/settings.json` 已配置好，让编辑器用 latexmk + XeLaTeX，并按上面的布局放置产物：

- `latex-workshop.latex.build.fromFolder = "."` —— 所有入口都从工作区根目录编译，确保子目录的独立报告与幻灯片能读取 `.latexmkrc`、共享样式和图片。
- `latex-workshop.latex.outDir = "%WORKSPACE_FOLDER%/pdf"`、`latex-workshop.latex.auxDir = "%WORKSPACE_FOLDER%/build"` —— 告诉编辑器去根目录的 `pdf/` 找 PDF / synctex，去 `build/` 找中间文件。**关键是不要在 `tools.args` 里加 `%OUTDIR%`**，那会覆盖 `.latexmkrc` 的 `$aux_dir` / `$out_dir` 设置。
- `latex-workshop.latex.recipes` / `latex-workshop.latex.tools` —— 定义 `latexmk (xelatex)` 配方并设为默认。
- `latex-workshop.latex.autoBuild.run = "onSave"` —— 保存即编译；想改成手动触发设为 `"never"` 即可。

> 设置改完需要重载窗口（命令面板 → `Developer: Reload Window`）才会生效。

## 目录使用说明

详细的目录、命名、章节结构与样式规范见 **[RULES.md](RULES.md)**。要点：

- **新增一个实验**：建 `reports/<起止日期>-<实验名>/`，写 `body.tex`（纯正文章节）与 `<实验名>.tex`（独立入口），并在 `report.tex` 中加一行 `\input{reports/<起止日期>-<实验名>/body}`。
- **新增一份幻灯片**：建 `slides/<起止日期>-<实验名>/`（文件夹名与 reports 下同名），写 `body.tex`（帧 + `\egodeckid{<文件夹名>}` 填页脚中块）与 `<实验名>-slides.tex`（导言区 + `\input`），并在根 `slides.tex` 中加一行 `\input{slides/<起止日期>-<实验名>/body}`。
- **图片与视频**：放到 `figures/<起止日期>-<实验名>/`，目录名与前两处一致。
- **样式调整**：报告样式统一改 `ego-report.sty`，幻灯片样式统一改 `ego-beamer.sty`，不要在正文里零散地改格式。
- **语言约定**：所有 `.tex` / `.sty` / `.bib` 的正文内容与注释统一用**英文**书写。

## 图片同步

- 报告与幻灯片**共用** `figures/` 目录，两个 `.sty` 中已通过 `\graphicspath` 指向该目录，正文里直接写文件名即可，例如 `\includegraphics{method.png}`。
- 建议图片按用途命名（如 `exp1_curve.png`、`arch.png`），避免重名；同一张图在两处复用时无需复制。
- 图源文件（如 `.svg`、`.drawio`、绘图脚本）也建议放在 `figures/` 或其子目录，便于后续更新导出。
