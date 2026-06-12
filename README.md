# PiliTuStudy

YouTube 风格 B站客户端。**不沉迷，主动获取知识。**

红黑/纯白双主题，底部四栏导航。零推荐算法，仅主动搜索和关注动态。

## 反沉迷

**学习模式** — 一键：知识分区白名单 + 关闭推荐流 + 关弹幕 + 隐藏评论 + 隐藏相关视频

**关闭全部推荐流** — 首页移除推荐/热门/排行榜，算法投喂完全切断

**知识模式** — 推荐仅保留指定分区，支持自定义白名单

**每日限额** — 时长 0–60min / 视频数 0–15 个，上调需 24h 冷却，收藏夹可豁免

**护眼提醒** — 连续播放后自动暂停休息，默认 20min/20s

**搜索拦截** — 屏蔽词覆盖主动搜索

**内容过滤** — NSFW 100+ 词 / 性别对立 40+ 词 / 政治敏感 90+ 词

**全局关闭评论/弹幕**

## 技术

后端复用 [PiliStudy](https://github.com/CoQingH/PiliStudy)（API / 数据模型 / 播放器 / 过滤 / 限额服务），UI 层全部重写为 YouTube 风格。

Flutter 3.35 + GetX + Hive

## 编译

```bash
flutter pub get
flutter build apk --release
```

---

## 声明

本项目（PiliTuStudy）是个人为了兴趣而开发，仅用于学习和测试，请于下载后 24 小时内删除。所用 API 皆从官方网站收集，不提供任何破解内容。

## 致谢

在此致敬原作者：[bggRGjQaUbCoE/PiliPlus](https://github.com/bggRGjQaUbCoE/PiliPlus)

在此致上游作者：[guozhigq/pilipala](https://github.com/guozhigq/pilipala)

在此致敬上上游作者：[orz12/PiliPalaX](https://github.com/orz12/PiliPalaX)

感谢原作者的开源精神。

感谢使用。

---

- [bilibili-API-collect](https://github.com/SocialSisterYi/bilibili-API-collect)
- [media-kit](https://github.com/media-kit/media-kit)
- [dio](https://github.com/cfug/dio)
- 等等
