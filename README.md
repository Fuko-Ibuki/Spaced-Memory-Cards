# Spaced Memory Cards

一个无需构建、可离线运行的中文间隔重复学习卡片应用。支持闪卡复习、即时反馈学习和模拟测试，并允许导入自己的 JSON 题库。

## 功能

- 闪卡模式：翻面查看答案，使用 Again / Hard / Good / Easy 自评，并按间隔重复安排后续复习。
- 学习模式：答题后立即反馈；答错的客观题会重新排入当前队列。
- 测试模式：完成整轮后统一判分，适合模拟考试和阶段性检查。
- 支持填空、单选、多选、判断、简答和综合分析六类题型。
- 按章节、题型、错题本和复习本筛选题目，支持自定义题量和模拟考试抽题。
- 统计仪表盘：查看学习轮次、逐题记录、连续学习天数、错题和复习进度。
- 数据导入/导出：备份并恢复设置、学习记录、错题本、复习本和间隔重复进度。
- 深色 / 浅色主题，适配桌面端和移动端，并提供键盘操作。

## 快速开始

本项目是静态 HTML，直接打开 `index.html` 即可使用。也可以在项目目录启动本地静态服务器：

```bash
python3 -m http.server 8000
```

然后访问 <http://localhost:8000>。首次进入时可选择“新手教程示例题库”体验完整流程，也可在题库页面拖入自己的 `.json` 文件。

## 题库 JSON 格式

新题库统一使用 **SMC Deck v2.1**：一个 `.json` 文件、一个 `questions` 数组、每题显式声明 `type`。新建、分享与版本管理都应使用该格式。

```json
{
  "deck": {
    "id": "physics-basics",
    "title": "力学基础",
    "subject": "物理",
    "language": "zh-CN",
    "version": "1.0.0",
    "description": "牛顿定律复习"
  },
  "assets": {
    "force-diagram": {
      "type": "image",
      "src": "assets/force-diagram.svg",
      "alt": "物体受力图"
    },
    "word-audio": {
      "type": "audio",
      "src": "assets/word.mp3",
      "transcript": "photosynthesis"
    }
  },
  "questions": [
    {
      "id": "force-001",
      "type": "single_choice",
      "chapter": "第一章：牛顿定律",
      "tags": ["公式", "基础"],
      "difficulty": 2,
      "content": [
        { "type": "text", "text": "根据牛顿第二定律 " },
        { "type": "math", "latex": "F=m a", "display": true },
        { "type": "image", "asset": "force-diagram", "caption": "受力示意图" },
        { "type": "text", "text": "若 F=6 N、m=2 kg，加速度是？" }
      ],
      "options": [
        { "key": "a", "text": "2 m/s²" },
        { "key": "b", "content": [{ "type": "math", "latex": "3\\,\\mathrm{m/s^2}" }] }
      ],
      "answer": { "keys": ["b"] },
      "explanation": [{ "type": "math", "latex": "a=F/m=3\\,\\mathrm{m/s^2}", "display": true }]
    }
  ]
}
```

### 顶层字段

| 字段 | 要求 | 说明 |
| --- | --- | --- |
| `schemaVersion` | 可选，填写时使用 `"2.1"` | 格式版本；省略时按当前 v2 规范解析。 |
| `deck` | 必填 | 题库元数据；`id`、`title` 推荐固定保存。 |
| `assets` | 可选 | 图片、音频等可复用资源表。 |
| `questions` | 必填，非空数组 | 题目列表；`id` 在一个题库中必须唯一。 |

### 题型

`type` 仅使用：`single_choice`、`multiple_choice`、`true_false`、`fill_blank`、`short_answer`、`essay`。

- 选择题的每个选项必须有唯一 `key`；`answer.keys` 只引用 key，不能引用字母、下标或选项文字。
- 判断题使用 `answer: { "value": true }` 或 `false`。
- 填空题在 `content` 内使用 `{ "type": "blank", "id": "1" }`，并用 `blanks` 按相同 ID 声明可接受答案。
- 简答题与论述题使用 `referenceAnswer`；可选 `rubric` 记录评分标准。

### 题库编写建议

- 题目 `id` 在同一题库内保持唯一、稳定，便于学习记录持续关联。
- 填空题题干使用三个下划线 `___` 表示一个填空位置；不要写 Markdown 粗体标记 `**___**`，也不要混入 HTML 实体。答案放在 `blanks[].answers`（v2）或 `answers`（旧格式）中。
- 普通文本直接写 JSON 字符串；引号使用弯引号“……”或‘……’，不要用未清洗的直引号。
- 公式使用 `math` 内容块并填写原始 LaTeX；反斜杠必须按 JSON 规则转义，例如 `"latex": "\\frac{a}{b}"`。
- 图片必须提供 `alt`，音频建议提供 `transcript`；资源路径相对于题库文件所在目录。
- 选择题为每个选项提供稳定的 `key`，正确答案只引用 `answer.keys`，不要依赖选项显示顺序。
- 新题库使用 JSON；JS 仅用于兼容旧题库，导入后建议转换并导出 JSON。

### 富媒体内容

`content`、选择题的 `options[].content` 与 `explanation` 都可由下列块组成：

| 块类型 | 必填字段 | 说明 |
| --- | --- | --- |
| `text` | `text` | 普通文本。 |
| `math` | `latex` | LaTex 公式；`display: true` 显示为独立公式块。公式由离线 KaTeX 渲染。 |
| `image` | `asset` 或 `src` | 图片；必须提供 `alt`。 |
| `audio` | `asset` 或 `src` | 音频播放器；可选 `transcript`。 |
| `blank` | `id` | 填空输入位置。 |
| `lineBreak` | 无 | 强制换行。 |

资源 `src` 可使用相对路径、HTTPS URL 或合规的 Base64 Data URL。图片支持 PNG、JPEG、WebP、GIF、SVG；音频支持 MP3、M4A、OGG、WAV、WebM。推荐目录：

```text
my-deck/
├── deck.json
└── assets/
    ├── images/
    └── audio/
```

完整可导入示例见 [`MEDIA_V2_SAMPLE.json`](MEDIA_V2_SAMPLE.json)。

### 旧格式与 JavaScript 兼容策略

**不建议立即删除运行时的 JS 兼容层。** 当前仓库仍有同目录旧版 `.js` 题库，并且已有用户题库可能依赖它；直接移除会造成存量题库无法加载。

但应立即停止把 JS 作为公开格式：新建、文档、示例和分享只使用 `.json`。JS/旧版六数组格式仅作为迁移兼容输入；迁移后请导出并维护 v2.1 JSON。下一次破坏性主版本可删除 JS 执行器，同时将内置题库迁移为 JSON。

#### 旧版 `.js` 题库说明

导入器目前兼容 CommonJS / UMD 导出和裸对象表达式。最小 CommonJS 示例：

```js
module.exports = {
  meta: { title: '旧版题库' },
  singleChoice: [
    { id: 1, question: '1 + 1 = ?', options: ['1', '2'], answer: 'B' }
  ]
};
```

`.js` 文件会在浏览器中执行，**仅导入可信来源**。它适合读取历史题库，不应用于新建题库；请将其转换为 `.json` 后再编辑、分享或发布。旧版字段为六个按题型分组的数组：`fillInTheBlank`、`singleChoice`、`multipleChoice`、`trueFalse`、`shortAnswer`、`essay`。

| 阶段 | 行为 |
| --- | --- |
| 当前 | JSON v2.1 为唯一推荐格式；保留 `.js` / 旧格式导入以迁移存量题库。 |
| 下个小版本 | UI 对 JS 导入显示“旧格式兼容”提示，并提供转换/导出 v2.1 JSON。 |
| 下个破坏性主版本 | 删除 `.js` 执行与裸对象求值，仅接收 JSON。 |

## 内置题库

内置题库应逐步迁移为 `.json` 并采用 v2.1。缺失的可选同目录题库不会影响应用启动。

## 键盘操作

- 闪卡模式：`Space` 翻面，`1`–`4` 选择 Again / Hard / Good / Easy。
- 测试模式：`←` / `→` 浏览已作答题目；`Esc` 退出当前学习轮次。
- 客观题通常可使用 `Enter` 提交；判断题使用 `1` / `2` 选择正误。
- 简答题：桌面端使用 `Shift + Enter` 提交。

## 数据与隐私

学习设置、记录、题库进度和错题信息默认保存在浏览器本地 `localStorage` 中；在提供 `window.storage` 的运行环境中会优先使用该存储。项目不依赖后端服务，题库和学习记录不会自动上传。

可在“统计”页面导出数据 JSON 进行备份。导入数据时会与已有记录合并；清空全部数据前请先导出备份。

## 项目结构

```text
index.html                 页面入口
app.js                     应用逻辑、题库解析、学习模式与数据存储
style.css                  页面样式、主题和响应式布局
MEDIA_V2_SAMPLE.json      富媒体 v2.1 题库示例
vendor/katex/              本地公式渲染资源
Apple Color Emoji.woff     内嵌 Emoji 资源
LICENSE                    MIT 许可证
```

## 许可证

本项目采用 [MIT License](LICENSE)。

## 本地字体与公式排版

仓库只发布必要的字体资源：`fonts/minion3/` 提供 Minion 3 的 8 个常用字重与斜体文件；`fonts/minion-math/` 提供 Minion Math 的常规、中等、半粗和粗体文件；`fonts/sf-pro/` 提供 SF Pro 实际用到字符的子集；`fonts/fz-new-book/FZNewBook-Full.woff2` 是由完整 `方正新书宋_GB18030.TTF` 转换并压缩的全字形 WOFF2；`fonts/hy-qihei/` 按 300/400/500/600/700/800/900 七个字重各保留一份“实际用到字符”子集，不再按字符范围拆分；`fonts/punctuation/` 是从方正 FW 筑紫 A 老明朝整理出的中文标点子集，提供 300/400/500/600/700/800 六个字重（覆盖通用标点、CJK 标点、竖排标点、兼容标点及全角标点）。完整字体包仍放在本机 `font/` 目录，并由 `.gitignore` 排除，不参与提交。


完整字体包仅用于本地开发，不纳入 Git 跟踪或发布包；仓库只保留上述必要的字体资源，以控制授权与资源体积；方正新书宋虽然保留全字形，但使用 WOFF2 压缩以降低传输体积。保留本地字体文件时，UI 使用本地 SF Pro 与汉仪旗黑，正文使用 Minion 3 与方正新书宋，符号使用 SF Pro Symbol；Emoji 使用内嵌的 Apple Color Emoji WOFF。

公式继续由本地 KaTeX 渲染，以保证浏览器中的数学字形度量、上下标和伸缩符号正确；当公式渲染器不可用时，回退为 Minion Math。仓库中的 MathTime Professional 2 为 TeX Type-1 资源包，不能直接作为浏览器 Web Font 使用，因此不会覆盖 KaTeX 的度量字体。
