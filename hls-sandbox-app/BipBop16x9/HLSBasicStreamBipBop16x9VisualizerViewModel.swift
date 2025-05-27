//
//  HLSBasicStreamBipBop16x9VisualizerViewModel.swift
//  hls-sandbox-app
//
//  Created by Đoàn Văn Khoan on 23/5/25.
//

import AVFoundation

class HLSBasicStreamBipBop16x9VisualizerViewModel: ObservableObject {

    @Published var player: AVPlayer?
    @Published var currentVariant: VideoVariant?
    @Published var availableVariants: [VideoVariant] = []
    
    @Published var audioOptions: [MediaOption] = []
    @Published var subtitleOptions: [MediaOption] = []

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
                
                
                if line.hasPrefix("#EXT-X-MEDIA:") {
                    let info = line.replacingOccurrences(of: "#EXT-X-MEDIA", with: "")
                    let type = extractValue(from: info, key: "TYPE") ?? "UNKNOWN"
                    let groupID = extractValue(from: info, key: "GROUP-ID") ?? "UNKNOWN"
                    let name = extractValue(from: info, key: "NAME") ?? "UNKNOWN"
                    let language = extractValue(from: info, key: "LANGUAGE") ?? "und"
                    let uriStr = extractValue(from: info, key: "URI")
                    let uri = uriStr.flatMap { URL(string: $0, relativeTo: self.masterURL) }
                    
                    let option = MediaOption(type: type, groupID: groupID, name: name, uri: uri, language: language)
                    
                    if type == "AUDIO" {
                        print("🎧 Found audio track: \(name) (\(language)) → \(uri?.absoluteString ?? "embedded")")
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.audioOptions.append(option)
                        }
                        
                    } else if type == "SUBTITLES" {
                        print("💬 Found subtitle track: \(name) (\(language)) → \(uri?.absoluteString ?? "embedded")")
                        
                        DispatchQueue.main.async { [weak self] in
                            self?.subtitleOptions.append(option)
                        }
                    
                    }
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
                
                print("List Audio: \(self.audioOptions)")
                print("List SUBTITLES: \(self.subtitleOptions)")
            }
        }.resume()
    }

    func selectVariant(_ variant: VideoVariant) {
        print("🕹️ Switching to variant: \(variant.label)")
        
        guard let currentVariant = self.currentVariant else { return }
        
        self.player?.pause()
        
        self.currentVariant = currentVariant
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
            var value = String(string[range].replacingOccurrences(of: "\(key)=", with: ""))
            // Remove surrounding quotes if present
            if value.hasPrefix("\""), value.hasSuffix("\"") {
                value.removeFirst()
                value.removeLast()
            }
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
    
    
    func selectMediaOption(type: AVMediaCharacteristic, name: String) {
        guard let playerItem = player?.currentItem else { return }

        Task {
            do {
                let group = try await playerItem.asset.loadMediaSelectionGroup(for: type)
                
                print("📦 Available options for \(type.rawValue):")
                group?.options.forEach {
                    print("• \($0.displayName) | locale: \($0.locale?.identifier ?? "nil") | tag: \($0.extendedLanguageTag ?? "nil")")
                }

                if let option = group?.options.first(where: { $0.displayName == name }) {
                    playerItem.select(option, in: group!)
                    print("✅ Selected \(type.rawValue): \(name)")
                } else {
                    print("⚠️ No option named '\(name)' found for \(type.rawValue)")
                }
            } catch {
                print("Error Select Media Option: \(error.localizedDescription)")
            }
        }
    }
    
    func deselectMediaOption(type: AVMediaCharacteristic) {
        guard let playerItem = player?.currentItem else { return }
        
        Task {
            do {
                if let group = try await playerItem.asset.loadMediaSelectionGroup(for: type) {
                    
                    playerItem.select(nil, in: group)
                    print("❌ Deselected \(type.rawValue)")
                    
                }
            } catch {
                print("Error DeSelect Media Option: \(error.localizedDescription)")
            }
        }
    }
    
    func enableSubtitle(name: String) {
        selectMediaOption(type: .legible, name: name)
    }

    func disableSubtitle() {
        deselectMediaOption(type: .legible)
    }

    func switchAudioTrack(name: String) {
        selectMediaOption(type: .audible, name: name)
    }
}
