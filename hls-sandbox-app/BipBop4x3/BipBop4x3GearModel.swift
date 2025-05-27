//
//  BipBop4x3GearModel.swift
//  hls-sandbox-ios-app
//
//  Created by Đoàn Văn Khoan on 22/5/25.
//

struct BipBop4x3Gear {
    let id: Int
    let uri: String
    let label: String
    
    static let abrUri: BipBop4x3Gear = BipBop4x3Gear(
        id: 999,
        uri: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/bipbop_4x3_variant.m3u8",
        label: "📶 Adaptive Bitrate Streaming"
    )
    
    static let gears: [BipBop4x3Gear] = [
        BipBop4x3Gear(
            id: 0,
            uri: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear0/prog_index.m3u8",
            label: "🎧 Gear 0 - Audio only"
        ),
        BipBop4x3Gear(
            id: 1,
            uri: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear1/prog_index.m3u8",
            label: "🎥 Gear 1 - 400x300 @ 232 kbps"
        ),
        BipBop4x3Gear(
            id: 2,
            uri: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear2/prog_index.m3u8",
            label: "🎥 Gear 2 - 640x480 @ 650 kbps"
        ),
        BipBop4x3Gear(
            id: 3,
            uri: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear3/prog_index.m3u8",
            label: "🎥 Gear 3 - 640x480 @ 1 Mbps"
        )
        ,BipBop4x3Gear(
            id: 4,
            uri: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_4x3/gear4/prog_index.m3u8",
            label: "🎥 Gear 4 - 960x720 @ 2 Mbps"
        )
    ]
}
