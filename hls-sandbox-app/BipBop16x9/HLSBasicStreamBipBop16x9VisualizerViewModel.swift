//
//  HLSBasicStreamBipBop16x9VisualizerViewModel.swift
//  hls-sandbox-app
//
//  Created by Đoàn Văn Khoan on 23/5/25.
//

import AVFoundation

struct VideoVariant: Identifiable, Hashable {
    let id = UUID()
    let resolution: String
    let bitrate: Int
    let url: URL

    var label: String {
        "\(resolution) • \(bitrate / 1000) kbps"
    }
}

class HLSBasicStreamBipBop16x9VisualizerViewModel: ObservableObject {

    @Published var player: AVPlayer?
    @Published var currentVariant: VideoVariant?
    @Published var availableVariants: [VideoVariant] = []

    private let masterURL = URL(string: "https://devstreaming-cdn.apple.com/videos/streaming/examples/bipbop_16x9/bipbop_16x9_variant.m3u8")!


    func fetchAvailableVariants() {
        print("🌐 Fetching master playlist from \(masterURL.absoluteString)...")
        URLSession.shared.dataTask(with: self.masterURL) { [weak self] data, response, error in

            guard let self = self else {
                print("❌ ViewModel no longer exists")
                return
            }

            if let error = error {
                print("❌ Failed to fetch playlist: \(error.localizedDescription)")
                return
            }

            guard let data = data,
                  let m3u8 = String(data: data, encoding: .utf8) else {
                print("❌ Unable to parse data as UTF-8 string")
                return
            }

            print("✅ Successfully fetched playlist. Parsing...")
            let lines = m3u8.components(separatedBy: "\n")
            var variants: [VideoVariant] = []

            for (index, line) in lines.enumerated() {
                if line.hasPrefix("#EXT-X-STREAM-INF:") {
                    let info = line.replacingOccurrences(of: "#EXT-X-STREAM-INF:", with: "")
                    let resolution = extractValue(from: info, key: "RESOLUTION") ?? "UNKNOWN"
                    let bandwidth = Int(extractValue(from: info, key: "BANDWIDTH") ?? "") ?? 0

                    let uriLine = lines.indices.contains(index + 1) ? lines[index + 1] : ""
                    guard let variantURL = URL(string: uriLine, relativeTo: self.masterURL) else {
                        print("⚠️ Skipping invalid URL on line \(index + 1): \(uriLine)")
                        continue
                    }

                    let variant = VideoVariant(resolution: resolution, bitrate: bandwidth, url: variantURL)
                    print("🔍 Found variant: \(variant.label) → \(variant.url.absoluteString)")
                    variants.append(variant)
                }
            }

            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.availableVariants = variants
                print("📦 Loaded \(variants.count) variant(s)")
                if let first = variants.first {
                    print("▶️ Auto-selecting first variant: \(first.label)")
                    self.currentVariant = first
                }
            }
        }.resume()
    }

    func selectVariant(_ variant: VideoVariant) {
        print("🕹️ Switching to variant: \(variant.label)")
        self.currentVariant = variant
        self.playing()
    }
    
    func playing() {
        guard let url = self.currentVariant?.url else { return }
        
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player?.play()
        print("🎥 Started playing variant: \(url)")
    }

    private func extractValue(from string: String, key: String) -> String? {
        let pattern = "\(key)=([^,]*)"
        if let range = string.range(of: pattern, options: .regularExpression) {
            let value = String(string[range].replacingOccurrences(of: "\(key)=", with: ""))
            print("🔧 Extracted \(key): \(value)")
            return value
        } else {
            print("⚠️ Could not extract \(key) from line: \(string)")
        }
        return nil
    }
    
    func stopMonitoring() {
        player?.pause()
        print("16x9 has been paused !")
        self.currentVariant = nil
    }
}
