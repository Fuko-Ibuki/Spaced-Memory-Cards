# Spaced Memory Cards

一个无需构建、可离线运行的中文间隔重复学习卡片应用。支持闪卡复习、即时反馈学习和模拟测试，并允许导入自己的 JSON / JavaScript 题库。

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

然后访问 <http://localhost:8000>。首次进入时可选择“新手教程示例题库”体验完整流程，也可在题库页面拖入自己的 `.json` 或 `.js` 文件。

## 题库格式

推荐使用 JSON。题库文件导出一个对象即可，`meta` 为可选元数据，至少包含一种题型数组：

```json
{
  "meta": { "title": "示例题库", "subject": "通用学习", "version": "1.0" },
  "singleChoice": [
    {
      "id": 1,
      "chapter": "第一章",
      "question": "1 + 1 等于多少？",
      "options": ["1", "2", "3", "4"],
      "answer": "B"
    }
  ],
  "trueFalse": [
    { "id": 2, "question": "地球是圆的。", "answer": true }
  ],
  "fillInTheBlank": [
    { "id": 3, "question": "中国的首都是___。", "answers": ["北京"] }
  ],
  "multipleChoice": [
    { "id": 4, "question": "哪些是水果？", "options": ["苹果", "胡萝卜", "香蕉"], "answer": ["A", "C"] }
  ],
  "shortAnswer": [
    { "id": 5, "question": "请简述答案。", "answer": "参考答案" }
  ],
  "essay": [
    { "id": 6, "question": "请进行综合分析。", "answer": "参考答案" }
  ]
}
```

填空题用 `___` 标记空位，`answers` 按空位顺序填写。简答题和综合分析题在测试结束后由学习者根据参考答案自评。

也支持 UMD / CommonJS 风格的 JavaScript 题库：

```js
module.exports = {
  meta: { title: '我的题库' },
  singleChoice: []
};
```

JavaScript 题库会在浏览器中执行，请只导入可信文件；分享题库时建议使用 JSON。

## 内置题库

- `XiThoughtQuiz.js`：习近平新时代中国特色社会主义思想概论
- `PrintingQualityQuiz.js`：印刷质量检测与标准化

应用也兼容同目录下的其他标准题库文件；文件不存在时不会影响页面启动。

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
XiThoughtQuiz.js           示例题库
PrintingQualityQuiz.js     示例题库
Apple Color Emoji.woff     本地 Emoji 字体
LICENSE                    MIT 许可证
```

## 许可证

本项目采用 [MIT License](LICENSE)。
