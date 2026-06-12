# PiliTuStudy

YouTube-style BiliBili client — knowledge focused, anti-addiction.

## Design

Red/black dark theme. Bottom navigation: Home / Search / Library / Settings.
No recommendation algorithm feed — search-first, active learning.

## Anti-Addiction System

| Feature | Description |
|---------|-------------|
| Study Mode | One-tap: knowledge zone whitelist + disable recs + clean playback |
| Knowledge Mode | Whitelist-filter recs/hot/rank to educational zones only |
| Recommendation Kill Switch | Hide rcmd/hot/rank tabs entirely |
| Daily Time Limit | 0–60 min, with 24h cooldown on increase |
| Daily Video Limit | 0–15 videos, with 24h cooldown on increase |
| Favorite Exemption | Watching in exempted folders doesn't count toward limits |
| Eye Care | 20-20-20 rule — auto-pause every N min for M sec |
| Search Blocking | Content filter keywords block active search queries |
| Global Comment Off | Force-hide all comments app-wide |
| Global Danmaku Off | Force-hide all danmaku app-wide |
| NSFW Filter | 100+ softcore/ASMR/dance/livestream/cosplay keywords |
| Gender Filter | 40+ gender conflict keywords |
| Political Filter | 90+ sensitive keywords |

## Build

```bash
flutter pub get
flutter build apk --release
```

## Credits

Backend modules (API, models, player, gRPC) adapted from [PiliPlus](https://github.com/ZnnnnnH2/PiliPlus-personal).

Co-Authored-By: Claude <noreply@anthropic.com>
