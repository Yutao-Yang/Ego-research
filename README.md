# Ego Research

Ego 研究项目的 LaTeX 源码：一份**总实验报告** + 一套**汇报幻灯片**，两者共用统一样式与图片。

## 目录结构

```
ego-research/
├── main/                           # 合并入口 + 全项目共用资源
│   ├── report.tex                  # 总报告入口（\input ../reports/... 各实验 body）
│   ├── beamer.tex                  # 合并幻灯片入口（\input ../beamer/... 各 deck body）
│   ├── ego-report.sty              # 报告统一样式：字体、页边距等
│   ├── ego-beamer.sty              # 幻灯片统一样式：页眉、页脚、背景素材
│   ├── references.bib              # 全项目共用参考文献
│   ├── .latexmkrc                  # 本目录编译配置：中间文件与 PDF 都进 ./pdf/
│   └── pdf/                        # 【自动生成】main 入口的中间文件 + PDF
│
├── reports/
│   ├── 2026.10.05-2026.10.11-openwam-libero/
│   │   ├── .latexmkrc              # 本实验编译配置：中间文件与 PDF 都进 ./pdf/
│   │   ├── openwam-libero.tex      # 独立入口：标题 + 摘要 + \input body
│   │   ├── body.tex                # 纯正文章节，被独立入口与 main/report.tex 复用
│   │   └── pdf/                    # 【自动生成】本实验的中间文件 + PDF
│   └── 2026.10.05-2026.10.11-pi05-libero/
│       └── ...                     # 同上
│
├── beamer/
│   ├── 2026.10.05-2026.10.11-openwam-libero/
│   │   ├── .latexmkrc                  # 本实验编译配置：中间文件与 PDF 都进 ./pdf/
│   │   ├── openwam-libero-beamer.tex   # 独立入口：导言区 + \input body
│   │   ├── body.tex                    # 纯帧内容，被独立入口与 main/beamer.tex 复用
│   │   └── pdf/                        # 【自动生成】本实验的中间文件 + PDF
│   └── 2026.10.05-2026.10.11-pi05-libero/
│       └── ...                     # 同上
│
├── figures/                        # 报告和幻灯片共用图片
│   ├── beamer_background/          # 幻灯片四张视觉素材
│   └── 2026.10.05-2026.10.11-.../  # 与 reports/beamer 同名，放图片与 mp4
│
├── .chktexrc                       # 项目级 chktex（Problems 面板）配置
├── .gitignore                      # 忽略各级 pdf/ 里的中间文件
├── .vscode/settings.json           # LaTeX Workshop 输出目录配置
├── RULES.md                        # 报告/幻灯片构建规范（目录、命名、章节、样式）
└── README.md
```

> 合并入口（`report.tex` / `beamer.tex`）、两个 `.sty`、`references.bib` 与它们的 `.latexmkrc` 都收在 `main/` 里；
> 根目录只保留 `main/`、`reports/`、`beamer/`、`figures/` 四个目录与配置文件。

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

**每个入口都在它自己的目录里编译。** latexmk 只读取「启动目录」（你敲命令时所在的目录）下的 `.latexmkrc`，
所以进哪个目录编译，产物就落到那个目录的 `pdf/` 里。

产物布局：

| 入口 | 中间文件 + PDF 的位置 |
| --- | --- |
| `main/report.tex` / `main/beamer.tex`（在 `main/` 里编译） | `main/pdf/` |
| `reports/<folder>/<实验名>.tex` | `reports/<folder>/pdf/` |
| `beamer/<folder>/<实验名>-beamer.tex` | `beamer/<folder>/pdf/` |

每个 `pdf/` 里**同时**放中间文件与最终 PDF：`.aux` `.log` `.toc` `.bbl` `.xdv` `.fls` 等，加上 `*.pdf` 与 `*.synctex.gz`。
（`.synctex.gz` 必须与 PDF 同目录，IDE 里源码 ↔ PDF 跳转靠它，且已被 `.gitignore` 忽略。）

实现方式：每份 `.latexmkrc` 只设 `$out_dir = 'pdf'`、不设 `$aux_dir` —— latexmk 会把 aux 目录默认成同一个，
于是中间文件与 PDF 自然同处一个 `pdf/`。

```bash
# 合并入口（产物进 main/pdf/）
cd main
latexmk report                                   # 编译总报告（自动 xelatex → bibtex → 重跑到收敛）
latexmk beamer                                   # 编译合并幻灯片（两份 deck 全部帧）

# 实验独立报告（产物进 reports/<folder>/pdf/）
cd reports/2026.10.05-2026.10.11-openwam-libero
latexmk openwam-libero

# 实验独立幻灯片（产物进 beamer/<folder>/pdf/）
cd beamer/2026.10.05-2026.10.11-openwam-libero
latexmk openwam-libero-beamer

latexmk -C                                       # 清理「当前目录」的产物
```

> 报告与幻灯片都采用「独立入口 + `body.tex`」的拆法：`main/report.tex` / `main/beamer.tex` 是合并入口，各实验文件夹里的入口是它自己的独立 PDF。改 `body.tex` 后两处都要重编。
> 实验文件夹的 `.latexmkrc` 里额外设了 `TEXINPUTS`（找到 `main/` 里的 `ego-report.sty` / `ego-beamer.sty`）与 `BIBINPUTS`（找到 `main/` 里的 `references.bib`），所以样式与参考文献不用复制到子目录。

> 若连 `.synctex.gz` 也不想留，把各级 `.latexmkrc` 里的 `-synctex=1` 改成 `-synctex=0`；代价是 IDE 中无法在源码与 PDF 之间互相跳转。

## 编辑器配置（VS Code / Trae + LaTeX Workshop）

`.vscode/settings.json` 需要按下面的方式配置，让编辑器用 latexmk + XeLaTeX，并按上面的布局放置产物：

- **不设** `latex-workshop.latex.build.fromFolder` —— 让 latexmk 在「root file 所在目录」运行，这样才会读到该目录下的 `.latexmkrc`（latexmk 只读启动目录的配置）。
- `latex-workshop.latex.outDir = "%DIR%/pdf"`、`latex-workshop.latex.auxDir = "%DIR%/pdf"` —— `%DIR%` 是当前 root file 所在目录（`main/`、`reports/<folder>/`、`beamer/<folder>/` 都适用），因此每个入口各自输出到自己的 `pdf/`。**关键是不要在 `tools.args` 里加 `%OUTDIR%`**，那会覆盖 `.latexmkrc` 的目录设置。
- `latex-workshop.latex.recipes` / `latex-workshop.latex.tools` —— 定义 `latexmk (xelatex)` 配方并设为默认。
- `latex-workshop.latex.autoBuild.run = "onSave"` —— 保存即编译；想改成手动触发设为 `"never"` 即可。

> 设置改完需要重载窗口（命令面板 → `Developer: Reload Window`）才会生效。

## 目录使用说明

详细的目录、命名、章节结构与样式规范见 **[RULES.md](RULES.md)**。要点：

- **新增一个实验**：建 `reports/<起止日期>-<实验名>/`（含一份 `.latexmkrc`），写 `body.tex`（纯正文章节）与 `<实验名>.tex`（独立入口），并在 `main/report.tex` 中加一行 `\input{../reports/<起止日期>-<实验名>/body}`。
- **新增一份幻灯片**：建 `beamer/<起止日期>-<实验名>/`（文件夹名与 reports 下同名，含一份 `.latexmkrc`），写 `body.tex`（帧 + `\egodeckid{<文件夹名>}` 填页脚中块）与 `<实验名>-beamer.tex`（导言区 + `\input{body}` + `\renewcommand{\egovideoroot}{../../../figures/}`），并在 `main/beamer.tex` 中加一行 `\input{../beamer/<起止日期>-<实验名>/body}`。
- **图片与视频**：放到 `figures/<起止日期>-<实验名>/`，目录名与前两处一致。
- **样式调整**：报告样式统一改 `main/ego-report.sty`，幻灯片样式统一改 `main/ego-beamer.sty`，不要在正文里零散地改格式。
- **语言约定**：所有 `.tex` / `.sty` / `.bib` 的正文内容与注释统一用**英文**书写。

## 图片同步

- 报告与幻灯片**共用** `figures/` 目录。两个 `.sty` 里的 `\graphicspath` 同时含 `../figures/`（供在 `main/` 里编译合并入口时使用）与 `../../figures/`（供在实验文件夹里编译时使用），所以正文里直接写「实验文件夹名/文件名」即可，例如 `\includegraphics{2026.10.05-2026.10.11-openwam-libero/method.png}`。
- 建议图片按用途命名（如 `exp1_curve.png`、`arch.png`），避免重名；同一张图在两处复用时无需复制。
- 图源文件（如 `.svg`、`.drawio`、绘图脚本）也建议放在 `figures/` 或其子目录，便于后续更新导出。
