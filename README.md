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

---
## 2. BIPBOP 16x9 
> 🔗🔗 URL: [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8)

> 🔗 Gear 0(audio only): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear0/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear0/prog_index.m3u8)

> 🔗 Gear 1(416x234): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear1/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear1/prog_index.m3u8)

> 🔗 Gear 2(640x360): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear2/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear2/prog_index.m3u8)

> 🔗 Gear 3(960x540): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear3/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear3/prog_index.m3u8)

> 🔗 Gear 4(1280x720): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear4/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear4/prog_index.m3u8)

> 🔗 Gear 5(1920x1080): [https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear5/prog_index.m3u8](https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/gear4/prog_index.m3u8)

##### 👇 HLS Features
- Note: The primary audio in the stream should be used for any sync testing. The second alternate audio demonstrates the use of an alternate audio option, but was not designed as a true sync verification.
- Compatible with macOS v10.7 or later and iOS 5 or later
- 16x9 aspect ratio
- H.264 @ 30Hz
- single .ts file, with byte-ranges in the playlists
- floating point durations
- CODECS and RESOLUTION attributes in master playlist
- I-Frames (fast forward rewind support)
- closed captions
- timed metadata (timecode every 5 seconds)
- 5 video variants
- Gear 1 - 416x234 @ 265 kbps
- Gear 2 - 640x360 @ 580 kbps
- Gear 3 - 960x540 @ 910 kbps
- Gear 4 - 1280x720 @ 1 Mbps
- Gear 5 - 1920x1080 @ 2 Mbps
- 1 audio-only variant
- Gear 0 - AAC - 22.05 kHz stereo @ 40 kbps
- 1 alternate audio
- alt audio - AAC - 22.05 kHz stereo @ 40 kbps
- subtitles (WebVTT)
