# 📺 HLS Sandbox iOS – Apple BipBop Stream

> 🔗 URL: [https://developer.apple.com/streaming/examples/](https://developer.apple.com/streaming/examples/)

---

## 🎯 Purposes

Đây là những đoạn **video mẫu (HLS Stream)** do Apple cung cấp, dùng để **minh họa đầy đủ các tính năng tiêu chuẩn và mở rộng của HLS (HTTP Live Streaming)**, bao gồm:

- Adaptive bitrate streaming 
- Multiple audio tracks
- Subtitles
- Segmenting
- Playback compatibility testing 

---

## 🧱 Structures

### `master.m3u8`
- File playlist gốc (master manifest)
- Liệt kê nhiều phiên bản video (variant streams) với độ phân giải và bitrate khác nhau

```m3u8
#EXT-X-STREAM-INF:BANDWIDTH=234000,RESOLUTION=416x234
gear1/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=440000,RESOLUTION=640x360
gear2/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=650000,RESOLUTION=960x540
gear3/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=990000,RESOLUTION=1280x720
gear4/prog_index.m3u8
```
---

## 1. BIPBOP 4x3 
> 🔗🔗 URL: [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8)
> 🔗 Gear 0(audio only): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear0/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear0/prog_index.m3u8)
> 🔗 Gear 1(400x300): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8)
> 🔗 Gear 2(460x480): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8)
> 🔗 Gear 3(640x480): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear3/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear3/prog_index.m3u8)
> 🔗 Gear 4(960x720): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear4/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear4/prog_index.m3u8)

##### 👇 HLS Features
- Compatible with macOS v10.7 or later and iOS 4.3 or later
- 4x3 aspect ratio
H.264 @ 30Hz
- floating point durations as separate segment files
- CODECS attribute in master playlist
- 4 video variants
- Gear 1 - 400x300 @ 232 kbps
- Gear 2 - 640x480 @ 650 kbps
- Gear 3 - 640x480 @ 1 Mbps
- Gear 4 - 960x720 @ 2 Mbps
- 1 audio-only variant
- Gear 0 AAC - 22.05 kHz stereo @ 40 kbps
