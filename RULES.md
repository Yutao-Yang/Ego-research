# Ego Research 构建规则

本文档是本项目**报告与幻灯片**的构建规范，供后续人工或智能体扩建时统一遵循。
内容约定（目录、命名、章节结构、样式、编译）以本文为准；具体“怎么用编辑器”见 [README.md](README.md)。

---

## 1. 目录与命名

```
ego-research/
├── main/                               # 合并入口 + 全项目共用资源
│   ├── report.tex                      # 总报告入口：\input ../reports/... 各实验 body
│   ├── beamer.tex                      # 合并幻灯片入口：\input ../beamer/... 各 deck body
│   ├── ego-report.sty                  # 报告样式（字体 / 版式 / \btt / longtable）
│   ├── ego-beamer.sty                  # 幻灯片样式（页眉 / 页脚 / 背景 / 素材）
│   ├── references.bib                  # 全项目共用参考文献
│   ├── .latexmkrc                      # main 入口配置：中间文件与 PDF 都进 ./pdf/
│   └── pdf/                            # 【自动生成】main 入口的中间文件 + PDF + synctex
│
├── reports/
│   └── 2026.10.05-2026.10.11-openwam-libero/
│       ├── .latexmkrc                  # 本实验配置：中间文件与 PDF 都进 ./pdf/
│       ├── openwam-libero.tex          # 独立入口（标题 + 摘要 + \input body）
│       ├── body.tex                    # 纯正文章节，被两处复用
│       └── pdf/                        # 【自动生成】本实验的中间文件 + PDF + synctex
│
├── beamer/
│   └── 2026.10.05-2026.10.11-openwam-libero/
│       ├── .latexmkrc                  # 本实验配置：中间文件与 PDF 都进 ./pdf/
│       ├── openwam-libero-beamer.tex   # 独立入口（导言区 + \input body）
│       ├── body.tex                    # 纯帧内容，被两处复用
│       └── pdf/                        # 【自动生成】本实验的中间文件 + PDF + synctex
│
├── figures/
│   ├── beamer_background/              # 幻灯片四张视觉素材（见 §4.1）
│   └── 2026.10.05-2026.10.11-openwam-libero/   # 与 reports/beamer 同名，放图片与 mp4
│
├── .chktexrc                           # 项目级 chktex 配置（见 §5.1）
├── .gitignore                          # 忽略各级 pdf/ 里的中间文件
├── README.md                           # 环境、编译与编辑器配置
└── RULES.md                            # 本文档
```

### 命名规则

| 对象 | 规则 | 示例 |
| --- | --- | --- |
| 实验文件夹（reports / beamer / figures 三处） | `起止日期-实验名`，三处**完全同名** | `2026.10.05-2026.10.11-openwam-libero` |
| 报告独立入口 | `实验名.tex` | `openwam-libero.tex` |
| 报告正文 | 固定叫 `body.tex` | `body.tex` |
| 幻灯片独立入口 | `实验名-beamer.tex` | `openwam-libero-beamer.tex` |
| 幻灯片正文 | 固定叫 `body.tex`（与报告正文同名但各自独立） | `body.tex` |
| 实验文件夹的编译配置 | 固定叫 `.latexmkrc`（reports / beamer 的每个实验各一份） | `.latexmkrc` |
| 实验文件夹的产物目录 | 固定叫 `pdf/`（中间文件与 PDF 都在里面） | `pdf/` |
| 委托标识（页脚中块） | 与实验文件夹名逐字一致 | `2026.10.05-2026.10.11-openwam-libero` |
| 合并入口与全项目共用资源 | 全部收在 `main/`（入口、两个 `.sty`、`references.bib`、`.latexmkrc`、`pdf/`） | `main/report.tex` |

> 实验文件夹**直接放在 `reports/`（或 `beamer/`）下**，不再有 `reports/experiments/` 这一层。
> 幻灯片目录叫 `beamer/`，不叫 `slides/`；系统生成的产物目录叫 `pdf/`，不叫 `build/`。
> 根目录只有 `main/`、`reports/`、`beamer/`、`figures/` 四个目录与若干配置文件，不再直接在根目录放源码。

---

## 2. 文档语言与字体

- **所有 `.tex` / `.sty` / `.bib` 的正文、注释、标题、图表说明一律用英文**。中文只出现在规则文档与 README 里。
- 全项目**只用两个字体家族**：正文 `TeX Gyre Termes`，标题 `Libertinus Serif`。
  两者分别由 `ego-report.sty` 与 `ego-beamer.sty` 各自设置，正文里不要再单独指定字体。

---

## 3. 报告规范

### 3.1 为什么拆成 `xxx.tex` + `body.tex`

同一份实验正文要出现在**两个 PDF** 里：

1. 该实验自己的独立 PDF（在实验文件夹里执行 `latexmk <实验名>`）；
2. `main/` 里的总报告 `report.tex`（把两份实验合并）。

因此把正文写成**无导言区**的 `body.tex`（只有 `\section` 起的章节内容），由两处 `\input` 复用：

```latex
% reports/2026.10.05-2026.10.11-openwam-libero/openwam-libero.tex
% 在「本文件夹」里编译：latexmk openwam-libero
\documentclass[11pt, a4paper]{article}
\usepackage{ego-report}
\title{...} \author{Ego Research} \date{\today}
\begin{document}
  \maketitle
  \begin{abstract} ... \end{abstract}
  \tableofcontents
  \newpage
  \input{body}                 % 同目录，写相对本文件夹的短路径
  \bibliographystyle{plain}\bibliography{references}
\end{document}
```

```latex
% main/report.tex（在 main/ 里编译：latexmk report）
\input{../reports/2026.10.05-2026.10.11-openwam-libero/body}
\input{../reports/2026.10.05-2026.10.11-pi05-libero/body}
```

要点：

- `\input` 路径按**编译时所在目录**写：`main/` 入口用相对 `main/` 的路径（`../reports/...`），各实验入口写 `\input{body}`（同目录）。实验入口必须在**它自己的文件夹里**编译，见 §5。
- 标题/摘要/目录/参考文献只写在入口文件，`body.tex` 里**不能**出现 `\documentclass`、`\usepackage`、`\begin{document}`。
- **幻灯片采用完全相同的拆法**：每份 deck 的帧写在 `beamer/<folder>/body.tex`，由两处 `\input` 复用 —— 该 deck 的独立入口 `beamer/<folder>/<实验名>-beamer.tex`（负责 `\documentclass` 与 `\usepackage{ego-beamer}`）与 `main/` 里的合并入口 `beamer.tex`。
- 因此幻灯片 `body.tex` **不能**出现 `\documentclass` / `\usepackage` / `\begin{document}`；但 **deck 的元数据（`\title` / `\subtitle` / `\author` / `\date` / `\egodeckid`）要写在 `body.tex` 开头**，这样合并 PDF 里每份 deck 的标题页与页脚中块才会随实验正确切换。
- 合并时各 deck 的顺序即 `main/beamer.tex` 中 `\input` 的先后顺序。
- 独立 deck 入口要 `\renewcommand{\egovideoroot}{../../../figures/}`：它的 PDF 落在 `beamer/<folder>/pdf/`（比合并入口的 `main/pdf/` 深一层），视频链接的相对前缀要跟着变（见 §4.5）。

### 3.2 章节结构模板（即“Contents”目录）

每个实验按下面的层级组织，顺序固定，标题措辞固定：

```
1..  Experiment X: <模型> on LIBERO            ← \section
       1.1  Overview and Scope                  ← \subsection
       1.2  The LIBERO Benchmark
       1.3  Model and Inference Architecture
       1.4  Closed-Loop Data Pipeline
       1.5  Frozen Environment and Provenance
       1.6  Results
       1.7  Compute, Timing and Control Budget
       1.8  Failure Inventory
       1.9  Reproducibility Notes
       1.10 Teaching Case: Images, Actions and Video
       1.11 Discussion: Reading <模型> Alongside <对照模型>
       1.12 Limitations
       1.13 Summary
```

可按实验删减（例如没有失败清单就删 `Failure Inventory`），但**不得打乱顺序、不得改标题用词**，以保证多份实验在总报告里读起来一致。

`\section` 标题里出现数学符号时必须给 PDF 书签一个纯文本版本：

```latex
\section{Experiment A: \texorpdfstring{OpenWAM-$\alpha$}{OpenWAM-alpha} on LIBERO}
```

### 3.3 排版约定

| 场景 | 做法 |
| --- | --- |
| 长路径 / 版本号 / SHA / 文件名 | 用 `\btt{...}`（等宽且每个字符后可断行）。下划线要转义：`\btt{pi0\_config.py}` |
| 表格 | 用 `booktabs`（`\toprule`/`\midrule`/`\bottomrule`），字号 `\small`，浮动用 `[H]` |
| 超过 40 行的长表 | 用 `longtable`，并加 `\endfirsthead`/`\endhead`/`\endfoot`/`\endlastfoot` 让表头跨页重复 |
| 长文本列 | 列格式用 `p{宽度}` 或 `>{\raggedright\arraybackslash}p{宽度}`，禁止用 `l` 装长句 |
| 多子图 | 用 `subcaption` 的 `subfigure`（已由 `ego-report.sty` 载入） |
| 数字与单位 | `\,` 做千分位与单位间距：`25\,829.198`\,s、`64\,761`、`99.25\,\%` |
| 交叉引用 | 用 `cleveref`：`\cref{fig:xxx}` / `\cref{tab:xxx}`；标签统一 `sec:` / `fig:` / `tab:` 前缀 |

**必须消除的警告**：`Overfull \hbox`（常见于长路径、宽表、长英文单词）。交付前日志里不允许有 Overfull/Underfull。

---

## 4. 幻灯片规范

### 4.1 视觉素材

四张素材固定放在 `figures/beamer_background/`，由 `ego-beamer.sty` 统一引用，正文**不要**直接写这些文件名：

| 素材 | 用途 |
| --- | --- |
| `正文图片背景.png` | 所有普通内容页的整页背景 |
| `标题页图片背景2.png` | 标题背景页（封面、目录页、每个 `\section` 分隔页）的背景 |
| `页眉页脚.png` | 内容页顶部蓝色页眉条 + 底部蓝色页脚条 |
| `右上角logo.png` | 内容页右上角 logo |

版式（由 `ego-beamer.sty` 实现，无需在正文里重复设置）：

- **内容页**（`\begin{frame}{标题}`）：**页眉**是顶部 7\,mm 蓝色条，左上角是本页标题（白色加粗），右上角是 logo；**页脚**是底部 7\,mm 蓝色条，分三块 —— 左 `Yutao-Yang` ｜ 中 实验文件夹名 ｜ 右 当前页码。
- **标题背景页**（封面、目录页、每个 `\section` 分隔页）**没有页眉页脚**：没有上下蓝条、没有 logo、没有页码，整页只有标题背景图与白色文字。实现方式是这三类 frame 都用 `plain` 选项（见 §4.2）。
- **页码只出现在内容页**，只写当前页、不写总页数；取自 `\insertpagenumber`（PDF 物理页），所以编号会跳过没有页码的标题背景页，但内容页的编号与物理页一致。
- **压暗层**：标题背景图局部对比度很高，白字压上去不一定看得清，所以在该背景上叠了一层半透明黑（`\egoscrimopacity`，默认 `0.38`）。要更亮或更暗改这一个数即可。
- 因此标题页、目录页、分隔页上的文字一律是白色，目录条目颜色由 `section in toc` 单独设为白色。

### 4.2 一个 deck 的骨架

与报告同样拆成**独立入口 + `body.tex`**（见 §3.1），入口只管导言区与 `\input`：

```latex
% beamer/2026.10.05-2026.10.11-openwam-libero/openwam-libero-beamer.tex
% 在「本文件夹」里编译：latexmk openwam-libero-beamer
\documentclass[aspectratio=169,usepdftitle=false]{beamer}
\usepackage{ego-beamer}
\renewcommand{\egovideoroot}{../../../figures/}   % PDF 在 beamer/<folder>/pdf/
\hypersetup{                          % PDF 元数据只在这里设一次
  pdftitle={Reproducing OpenWAM-alpha on LIBERO},
  pdfauthor={Yutao-Yang},
}
\begin{document}
  \input{body}
\end{document}
```

> 必须带 `usepdftitle=false` 且 `\hypersetup` 只写一次：beamer 的 `\author` 在正文里会再次调用
> `\hypersetup{pdfauthor=...}`，与上面的设置重复，hyperref 会报
> `Option 'pdfauthor' has already been used`。关掉 beamer 的自动 pdfinfo 后由入口统一设置，日志即可保持干净。

```latex
% beamer/2026.10.05-2026.10.11-openwam-libero/body.tex
% 元数据写在 body 开头，合并 PDF 才会随实验正确切换标题页与页脚
\egodeckid{2026.10.05-2026.10.11-openwam-libero}   % 页脚中块，必须与实验文件夹同名
\title{Reproducing OpenWAM-\texorpdfstring{$\alpha$}{alpha} on LIBERO}
\subtitle{Closed-loop success rate on a single A100}
\author{Yutao-Yang}
\date{2026.10.05--2026.10.11}

\egotitleframe      % 标题页（标题背景，自动切回正文背景）
\egooutline         % 目录页（标题背景）

\section{Motivation}          % 自动生成一张分隔页
\begin{frame}{...} ... \end{frame}

\section{Result}
\begin{frame}{...} ... \end{frame}
```

`main/` 里的合并入口 `beamer.tex` 依次 `\input` 各实验的 `body`：

```latex
% main/beamer.tex（在 main/ 里编译：latexmk beamer）
\documentclass[aspectratio=169,usepdftitle=false]{beamer}
\usepackage{ego-beamer}
\hypersetup{
  pdftitle={Ego Research --- LIBERO reproductions, consolidated slide deck},
  pdfauthor={Yutao-Yang},
}
\begin{document}
  \input{../beamer/2026.10.05-2026.10.11-openwam-libero/body}
  \input{../beamer/2026.10.05-2026.10.11-pi05-libero/body}
\end{document}
```

可用命令：

| 命令 | 作用 |
| --- | --- |
| `\egodeckid{<文件夹名>}` | 设置页脚中块文字 |
| `\egotitleframe` | 标题页，用标题背景，结束后自动切回正文背景 |
| `\egooutline` | 目录页（`\tableofcontents`），用标题背景 |
| `\section{...}` | 除生成目录条目外，自动插入一张标题背景分隔页 |
| `\egosectionpage{<标题>}` | 手动插入一张分隔页（一般不直接用） |
| `\egovideolink[按钮文字]{<文件夹>/<文件名>.mp4}` | 生成“Play video”按钮；链接前缀取 `\egovideoroot`（合并 deck 用默认 `../../figures/`，独立 deck 覆写为 `../../../figures/`） |

> 上表前三类（`\egotitleframe`、`\egooutline`、`\section` 触发的分隔页）内部都用 beamer 的 `plain` 帧，
> 所以它们**没有页眉页脚**（无蓝条、无 logo、无页码）。因为 `plain` 帧不显示 `frametitle`，
> 这类页的标题都写在帧正文里（`\egooutline` 的 “Contents” 即为手工排版的居中标题），
> 新增此类页面时也要遵守这一点，不要在 `\begin{frame}` 上传标题参数。

### 4.3 内容取舍

幻灯片**只讲最重要的事**：结论、动机、关键数字，主体是**图片与视频**。

- 一个 deck 的骨架：`Motivation → Benchmark/Setup → Result → Compute → Teaching cases → Takeaway → Reference`。
- 一页只讲一件事，尽量用图；数字用加粗结论句，不要搬报告里的长段落。
- 需要保留的“边界条件”放一页 `What this shows --- and what it does not`，不要散落各处。
- 最后一页放 `Reference`（出处 + `\texttt{reports/<folder>/}` 指向完整报告）。

### 4.4 版式尺寸经验值

16:9 页面 160\,mm × 90\,mm，去掉上下各 7\,mm 页眉页脚后，正文可用高度约 **71\,mm（≈200\,pt）**。
按下面的上限放图，可避免 `Overfull \vbox`：

| 排布 | 单图宽度上限 | 说明 |
| --- | --- | --- |
| 单图独占一页 | `0.92\linewidth` | 宽高比 ≥ 3 的横幅图（如 40 任务总览） |
| 左文右图 | `0.46\linewidth` | 宽高比 ≈ 1.8 的图 |
| 2×2 网格 | `0.30\linewidth` | 宽高比 ≈ 1.67 的图（一行两图） |
| 2×3 或 2×4 网格 | `0.23\linewidth` | 正方形图（一行三/四图，两行） |
| 一页两行图片 | 每图高度 ≤ 75\,pt | 两行合计 ≤ 150\,pt |

### 4.5 视频

beamer 的 `media9`/`multimedia` 依赖特定阅读器，不采用。统一做法是：

1. 用一张**代表性静帧** PNG 占位（末帧或接触表）；
2. 用 `\egovideolink{<folder>/<file>.mp4}` 生成按钮；
3. 视频文件放在 `figures/<folder>/`；按钮里的路径是**相对 PDF 所在目录**的，而 PDF 位置随入口而变，所以前缀由宏 `\egovideoroot` 给出：合并 deck（`main/pdf/xxx.pdf`）用默认值 `../../figures/`，独立 deck（`beamer/<folder>/pdf/xxx.pdf`）在入口文件里 `\renewcommand{\egovideoroot}{../../../figures/}`。

### 4.6 图片引用路径

两个样式里的 `\graphicspath` 同时含 `../figures/`（供在 `main/` 里编译合并入口时使用）与 `../../figures/`（供在实验文件夹里编译时使用），所以正文只写「实验文件夹名/文件名」，不写 `figures/` 前缀：

```latex
\includegraphics[width=0.46\linewidth]{2026.10.05-2026.10.11-openwam-libero/official-comparison.png}
```

§4.1 的四张背景素材同理：`ego-beamer.sty` 里用**裸文件名**引用它们，靠 `\graphicspath` 命中 `figures/beamer_background/`（或 `../../figures/beamer_background/`），因此合并 deck 与独立 deck 都能正常取图。

---

## 5. 编译与产物

**每个入口都在它自己的目录里编译。** latexmk 只读取「启动目录」（也就是你敲命令时所在的目录）下的 `.latexmkrc`，
所以进哪个目录编译，产物就按哪个目录的配置落到那个目录的 `pdf/` 里。

```bash
# 合并入口 —— 产物进 main/pdf/
cd main
latexmk report                                          # 总报告（合并两份实验）
latexmk beamer                                          # 合并幻灯片

# 实验独立报告 —— 产物进 reports/<folder>/pdf/
cd ../reports/2026.10.05-2026.10.11-openwam-libero
latexmk openwam-libero
cd ../2026.10.05-2026.10.11-pi05-libero
latexmk pi05-libero

# 实验独立幻灯片 —— 产物进 beamer/<folder>/pdf/
cd ../../beamer/2026.10.05-2026.10.11-openwam-libero
latexmk openwam-libero-beamer
cd ../2026.10.05-2026.10.11-pi05-libero
latexmk pi05-libero-beamer

latexmk -C                                              # 清理「当前目录」的产物
```

产物布局（每个入口目录一份 `pdf/`，中间文件与 PDF 同放其中）：

| 入口 | 中间文件 + PDF 的位置 |
| --- | --- |
| `main/report.tex` / `main/beamer.tex` | `main/pdf/` |
| `reports/<folder>/<实验名>.tex` | `reports/<folder>/pdf/` |
| `beamer/<folder>/<实验名>-beamer.tex` | `beamer/<folder>/pdf/` |

- 必须 **XeLaTeX**（样式用 `fontspec` 按字体名加载 OpenType 字体）。
- 目录由各级 `.latexmkrc` 控制：只设 `$out_dir='pdf'`、**不设** `$aux_dir`（latexmk 会把 aux 目录默认成同一个），
  于是 `.aux .log .toc .bbl .xdv .fls` 等中间文件与最终 PDF、`.synctex.gz` **全部落在同一个 `pdf/`**。
  不要手动加 `-output-directory`。
- 实验文件夹的 `.latexmkrc` 另外设了两条搜索路径：`TEXINPUTS=../../main/;…`（找到 `main/` 里的 `ego-report.sty` / `ego-beamer.sty`）
  与 `BIBINPUTS=../../main/;…`（找到 `main/` 里的 `references.bib`）。
- **不要**在别的目录编译实验入口：latexmk 只读「启动目录」的 `.latexmkrc`，跨目录执行会拿到别的配置、把产物放错地方。
  同理别用 `latexmk -cd` 从外部跨目录编译——`-cd` 只改工作目录，不改读取的配置文件。

### 交付前自检（每次都要做）

1. 编译日志中**没有** `Error`、`Overfull`、`Underfull`、未解决的 `LaTeX Warning`（`Rerun to get ...` 重跑一次即可消失）。
2. 六个入口的 `pdf/` 下 PDF 齐全：`main/pdf/` = `report` + `beamer`；`reports/<folder>/pdf/` 各 1 份；`beamer/<folder>/pdf/` 各 1 份。
3. 中间文件与 PDF 都收在各自的 `pdf/` 里，源码目录（`main/`、各实验文件夹）除 `pdf/` 外没有被编译产物污染；根目录不出现 `build/` 或 `pdf/`。
4. 用 `pdftoppm` 把 PDF 渲染成 PNG 抽查版式（页眉条、左上角标题、右上角 logo、页脚三块、背景图是否正常）：

```bash
pdftoppm -png -r 100 -f <首页> -l <末页> <某个 pdf/<file>.pdf> <临时目录>/<prefix>
```

抽查完成后删除临时预览目录。

5. Problems 面板（chktex）为 0，见 §5.1。

### 5.1 Lint（chktex）

编辑器（LaTeX Workshop）用 `chktex` 做静态检查，结果进 Problems 面板。项目根目录的
`.chktexrc` 是**项目级**配置：LaTeX Workshop 会自动以 `-l <.chktexrc 绝对路径>` 传给 chktex，
所以它就是这个工作区「Problems 面板显示什么」的开关，不需要（也不应）去改编辑器全局设置。

原则：**真实问题在源码里改掉，不用配置把它掩盖过去。**

已修的真实问题（数字为 chktex 消息号）：

| 消息号 | 含义 | 修法 |
| --- | --- | --- |
| 1 | 控制词被空格终止 | 命令后紧跟 `%`，如 `\egotitleframe%` |
| 2 | 缺不断行空格 | 交叉引用之间用 `~`，如 `Figures~\ref{a},~\ref{b}` |
| 6 | 缺斜体校正 | 斜体片段结尾的 `\\` 写成 `\/\\` |

静音的消息类别（`.chktexrc` 中 `CmdLine { -n8 -n9 -n12 -n13 -n21 -n24 -n36 -n41 -n46 }`），
都是技术文档里固有的误报或纯风格建议：

| 消息号 | 含义 | 为什么是本项目噪声 |
| --- | --- | --- |
| 8 | 连字符长度 | 标识符、路径、ISO 日期里的 `-`，以及刻意写的 `--` |
| 9 | 括号不配对 | `\texttt{...}` 里跨组的 Python 片段 |
| 12 / 13 | 句间 / 句后空格 | 英文缩写与 `\emph{...}` 紧接句子 |
| 21 / 46 | 行内数学写法 | 全项目统一写 `$...$` 而非 `\(...\)` |
| 24 | `\label` 前的空格 | `\label` 另起一行跟在 `\section{...}` 后 |
| 36 | 函数名后的空格 | `\texttt{...}` 里的 `env.reset()` 之类 |
| 41 | 原生 TeX 原语 | 两个 `.sty` 里刻意的 `\vskip` / `\def` |

以上三类静音之外不再有例外：背景素材改用**裸文件名 + `\graphicspath`** 加载（见 §4.6），
不再需要在 chktex 里为某个宏开 `Silent` 白名单。

改完 `.chktexrc` 要做**反向验证**，避免出现“把检查关掉”的假清零：

```bash
chktex -wall -n22 -n30 -e16 -q -I0 <file>                    # 不带 rc：应仍报大量警告
chktex -wall -n22 -n30 -e16 -q -l .chktexrc -I0 <file>       # 带 rc：应为 0
```

---

## 6. 智能体执行清单

新增一个实验时按序完成：

1. 建 `reports/<日期-实验名>/`，写 `body.tex`（按 §3.2 章节结构，纯英文）、`<实验名>.tex`（标题 + 摘要 + `\input{body}`），并放一份该文件夹的 `.latexmkrc`（可复制同级实验的）。
2. 在 `main/report.tex` 里 `\input{../reports/<日期-实验名>/body}`。
3. 在 `figures/<日期-实验名>/` 放图片与 mp4（目录名与上一步一致）。
4. 建 `beamer/<日期-实验名>/`，写 `body.tex`（按 §4.2，`\egodeckid` 填文件夹名）、`<实验名>-beamer.tex`（导言区 + `\input{body}` + `\renewcommand{\egovideoroot}{../../../figures/}`）与一份 `.latexmkrc`；页脚作者与他人保持一致。
5. 在 `main/beamer.tex` 里 `\input{../beamer/<日期-实验名>/body}`。
6. 六个入口各自**在自己目录里**编译一次（`main/` 里 `latexmk report`、`latexmk beamer`，四个实验目录各 `latexmk <入口名>`），确认 §5 的自检项全部通过。
7. 若改了 `ego-beamer.sty` 的通用版式，两份独立 deck 与合并 `beamer` 共三份都要重新编译验证。
