//
//  Bip.swift
//  hls-sandbox-app
//
//  Created by Đoàn Văn Khoan on 27/5/25.
//

import Foundation

struct VideoVariant: Identifiable, Hashable {
    let id = UUID()
    let resolution: String
    let bitrate: Int
    let url: URL

    var label: String {
        "\(resolution) • \(bitrate / 1000) kbps"
    }
}


struct MediaOption: Identifiable, Hashable {
    let id = UUID()
    let type: String // AUDIO or SUBTITLES
    let groupID: String
    let name: String
    let uri: URL?
    let language: String
}
