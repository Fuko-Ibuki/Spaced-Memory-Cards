# Spaced Memory Cards

一个无需构建、可离线运行的中文学习应用：导入题库与结构化笔记，在闪卡、学习、测试和浏览整卷之间切换，并将学习进度保存在浏览器本地。

## 功能概览

- **三种学习模式**：闪卡（Again / Hard / Good / Easy 间隔重复）、学习（即时反馈与错题重排）、测试（完成后统一判分）。
- **题库能力**：支持填空、单选、阅读、多选、判断、简答和综合分析；可按章节、题型、错题本、复习本与数量抽题。
- **笔记能力**：导入 HTML / HTM 笔记或本应用导出的笔记 ZIP；提供目录、搜索、高亮、收藏、图片放大、日历与章节测试入口。
- **多笔记管理**：同一学科的笔记合并显示；没有学科字段时按无后缀文件名区分；菜单可切换全部或单个来源，正文与目录同步筛选。
- **关联学习**：笔记可通过题目 ID、笔记 ID 或标题关联题库；章节可携带测试配置并直接开始测试。
- **数据与界面**：本地保存设置、进度、题库库、笔记、注释和高亮；支持深浅主题、桌面端与移动端、键盘操作。

## 快速开始

本项目是静态网页。建议从项目根目录启动本地服务器：

```bash
python3 -m http.server 8000
```

访问 <http://localhost:8000>，然后：

1. 在学习页导入 `.json`、兼容 `.js`、题库 ZIP、HTML 笔记或笔记 ZIP。
2. 选择题库、学习模式和题目范围。
3. 在“笔记”页导入、搜索、切换或导出笔记。

直接打开 `index.html` 也可运行；使用本地服务器更适合加载同目录资源和相对路径媒体。

## 项目结构

```text
.
├── index.html              # 静态入口
├── app.js                  # 应用状态、导入、学习、笔记与存储逻辑
├── style.css               # 深浅主题、桌面端与移动端样式
├── MEDIA_V2_SAMPLE.json    # 富媒体 v2 题库示例
├── 高数题库.json            # 本地示例题库
├── 高数笔记.html            # 本地示例笔记
├── 英语.html                # 本地示例笔记
├── fonts/                  # 浏览器使用的字体资源
└── vendor/katex/           # 离线公式渲染资源（发布时需保留）
```

## 题库格式

新题库建议使用 JSON v2 格式。`deck.id` 应稳定且唯一；题目 `id` 在同一题库中也应唯一。

```json
{
  "deck": {
    "id": "math-basics",
    "title": "数学基础",
    "subject": "数学",
    "version": "1.0.0"
  },
  "questions": [
    {
      "id": "math-001",
      "type": "single_choice",
      "chapter": "第一章",
      "question": "1 + 1 = ?",
      "options": ["1", "2", "3", "4"],
      "answer": "B",
      "explanation": "1 + 1 = 2"
    }
  ]
}
```

### 支持的题型

| `type` | 说明 |
| --- | --- |
| `fill_blank` | 填空题；题干使用 `___`，答案使用 `answers` 或 v2 `blanks[].answers`。 |
| `single_choice` | 单选题。 |
| `reading` | 阅读题；与单选题相同，并支持 `article` / `passage` 与 `articleId`。 |
| `multiple_choice` | 多选题。 |
| `true_false` | 判断题。 |
| `short_answer` | 简答题。 |
| `essay` | 综合分析题。 |

题目可使用 `content`、`options[].content` 与 `explanation` 内容块。支持 `text`、`math`、`image`、`audio`、`blank` 和 `lineBreak`；公式 LaTeX 在 JSON 内需转义反斜杠，例如 `"\\frac{a}{b}"`。完整示例见 [`MEDIA_V2_SAMPLE.json`](MEDIA_V2_SAMPLE.json)。

### 兼容输入

- 推荐新建、分享和维护使用 `.json`。
- 仍兼容历史 `.js` / CommonJS / UMD 题库以及旧字段格式；`.js` 会在浏览器中执行，只导入可信来源。
- 题库 ZIP 为本应用导出的未压缩 ZIP，可恢复其中的 JSON / JS 来源文件。

## 笔记格式与题库关联

笔记支持 `.html`、`.htm`，也支持本应用导出的笔记 ZIP。导入器只读取约定正文结构，过滤脚本、样式、表单、内联事件和不安全链接。

```html
<!doctype html>
<html lang="zh-CN">
<head>
  <meta charset="utf-8">
  <meta name="subject" content="数学">
  <title>函数笔记</title>
</head>
<body>
  <main data-subject="数学" data-deck-id="math-basics">
    <h1>函数笔记</h1>
    <section class="chap">
      <h2>第一章</h2>
      <section class="sec" data-deck-id="math-basics">
        <h3>函数概念</h3>
        <article class="kp" data-id="math-function" data-question-id="math-001"
          data-type="concept" data-test-config='{"questionLimit":10}'>
          <h4>函数的定义</h4>
          <div class="md"><p>笔记正文。</p></div>
          <div class="src">来源（可选）</div>
        </article>
      </section>
    </section>
  </main>
</body>
</html>
```

### 结构与字段

- 使用 `main > section.chap > section.sec > article.kp` 组织内容；每个 `article.kp` 必须包含 `.md` 正文。
- 标题使用 `h1`、`h2`、`h3`、`h4`；小节说明使用 `.desc`，来源使用 `.src`。
- 建议填写 1～4 个汉字的学科：`main[data-subject]` 或 `<meta name="subject">`，并与题库 `deck.subject` 保持一致。
- `data-deck-id` 可写在 `main` 或 `section.sec`，用于选择关联题库。
- `data-question-id` 优先关联 `questions[].id`；随后依次尝试笔记 `data-id` 和笔记标题与题干的完全匹配。
- `data-type` 支持 `rule`、`concept`、`contrast`、`method`、`example`、`pitfall`、`memo`、`vocabulary`。
- `data-test-config` 可包含 `questionLimit`、`timeLimitEnabled`、`timeLimitMinutes`、`shuffleQuestions`、`shuffleOptions`、`includeTypes`、`chapterFilter`。
- 正文支持 `$...$`、`$$...$$`、`\(...\)`、`\[...\]` LaTeX；公式由本地 KaTeX 渲染。

### 多笔记合并、筛选与导出

- 多文件导入按照串行队列合并，避免同时选择多份笔记时互相覆盖。
- 内容相同的知识点会跳过；每个小节保留自己的关联题库 ID。
- 相同学科字段的笔记归为同一来源项；未填写学科时使用不带 `.html` / `.htm` 的文件名。
- “更多”菜单：单份笔记只显示当前名称；多份笔记显示“显示全部”和各来源名称。切换后正文、目录与章节测试入口同步更新。
- “导出笔记”生成一个 ZIP，包含全部原始笔记 HTML 与 `manifest.json`；在笔记页导入 ZIP 可恢复其中全部笔记。

## 笔记媒体与排版

- 图片建议使用 `<figure class="note-image">`、`<img alt="…">` 和 `<figcaption>`；可添加 `float-right`，移动端会取消绕排。
- 图片、链接应使用相对路径或 HTTPS 地址；图片提供准确 `alt`。
- SVG 的文字显式指定 `font-size`；需要随主题变化的黑白文字使用 `currentColor`，彩色图形使用固定颜色。
- 导入笔记不执行自带脚本。交互需求请使用本应用提供的目录、搜索、收藏、高亮、图片缩放和测试入口。

## 数据、导入与隐私

- 应用使用浏览器本地存储保存设置、学习进度、题库来源、笔记、收藏、高亮、图片缩放和注释。
- 设置页可导出题库 ZIP；笔记页可导出笔记 ZIP；数据导出功能用于备份应用学习数据。
- “清空缓存”会删除当前题库、笔记和未完成会话等缓存内容，不会删除学习记录、错题本和复习本。
- 数据不依赖服务端上传；清除浏览器站点数据会移除本地保存内容，请在操作前导出备份。

## 键盘操作

- `Space`：在闪卡模式翻面或继续。
- `1`～`4`：选择或评分（依当前题型 / 模式显示）。
- `Enter`：提交当前答案或继续。
- `Esc`：关闭弹窗。

## 开发与验证

无需依赖安装或构建。修改 JavaScript 后可运行：

```bash
node --check app.js
git diff --check -- app.js style.css README.md
```

修改界面后，请通过 `index.html` 的实际运行入口验证桌面端、移动端、深浅主题以及涉及的导入流程。

## 许可证

[MIT](LICENSE)
