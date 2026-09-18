# 东北农业大学读书社互动游戏

## 文件说明

- `index.html`：可直接部署的互动游戏主页。
- `stats-config.js`：跨设备统计连接配置。
- `supabase-setup.sql`：统计数据库初始化脚本。
- `东北农业大学读书社_嘉年华互动游戏.html`：与主页内容相同的中文文件名版本。

## 统计口径

- 每完成并提交一轮游戏，计 1 个参与人次。
- 本轮全部答对，计 1 个通过人次。
- 通过率 = 通过人次 ÷ 参与人次。
- 不记录姓名、学号、设备标识或具体答题内容。

## 配置跨设备同步

GitHub Pages 只能托管静态 HTML、CSS 和 JavaScript，本身不能保存多台设备共同写入的数据，因此统计数据使用 Supabase Data API 保存。

1. 注册并创建一个 Supabase 项目。
2. 在 Supabase 的 SQL Editor 中打开并运行 `supabase-setup.sql` 的全部内容。
3. 在项目的 Connect 或 Settings → API Keys 页面复制 Project URL 和 Publishable key。
4. 打开 `stats-config.js`，填入对应值：

```javascript
window.READING_CLUB_STATS_CONFIG={
  supabaseUrl:"https://你的项目编号.supabase.co",
  supabasePublishableKey:"sb_publishable_你的密钥"
};
```

只能填写 Publishable key，不能填写 Secret key 或 `service_role` key。

## 发布到 GitHub Pages

1. 将 `index.html`、`stats-config.js` 一起上传到仓库根目录。
2. `supabase-setup.sql` 和本说明文件可以一并保留在仓库中。
3. 打开仓库 Settings → Pages。
4. 在 Build and deployment 中选择 Deploy from a branch。
5. 选择 `main` 分支和 `/ (root)` 目录并保存。
6. 页面发布后，在两台设备上打开同一个网址。任意设备完成游戏后，统计会立即尝试同步，其他设备最多约 30 秒后自动更新，也可以点击“刷新统计”。

## 本机模式与断网处理

- `stats-config.js` 留空时，网页仍可正常运行，统计只保存在当前浏览器。
- 云端已配置但临时断网时，新记录会先留在本机，恢复联网后自动补传。
- 每条记录使用唯一事件编号，网络重试不会重复计数。

## 安全说明

数据库已启用行级安全策略。公开页面只能新增经过游戏编号校验的匿名结果，不能直接读取、修改或删除明细；页面只能调用汇总函数读取五个游戏的统计数字。

Publishable key 本来就是供网页等公开客户端使用的低权限密钥，但公开统计仍可能被恶意重复提交，因此适合活动现场运营统计，不应当作为需要防作弊的正式审计数据。如需更严格的防刷，可再增加登录、验证码或带限流的服务端接口。

参考资料：

- [GitHub Pages 文档](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages)
- [Supabase Data REST API](https://supabase.com/docs/guides/api)
- [Supabase API Keys](https://supabase.com/docs/guides/getting-started/api-keys)
- [Supabase API 安全与 RLS](https://supabase.com/docs/guides/api/securing-your-api)


## 大题库版更新说明
- G2：500 个内置题目位（200 个经典/读书语录 + 300 个古诗文名句）
- G3：200 组作者—作品
- G4：300 道三词猜书
- G5：20 个关键词，每个关键词 70 个识别/参考条目
- 保留原 Supabase 统计配置与 GitHub Pages 部署方式。

### 上传 GitHub
1. 解压本 ZIP。
2. 打开原 GitHub 仓库，点击 Add file → Upload files。
3. 上传解压后的 4 个文件，覆盖同名文件。
4. 点击 Commit changes。
5. 打开 Actions，等待 pages build and deployment 变成绿色对勾。
6. 刷新原 GitHub Pages 网站（必要时 Ctrl+F5）。
