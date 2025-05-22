//
//  HLSVisualizerViewModel.swift
//  hls-sandbox-ios-app
//
//  Created by Đoàn Văn Khoan on 21/5/25.
//

import Foundation
import AVKit
import Combine


class HLSBasicStreamBipBop4x3VisualizerViewModel: ObservableObject {
    
    /// Property Logic
    let player = AVPlayer(
        url: URL(string: BipBop4x3Gear.abrUri.uri)!
    )

    @Published var resolution: String = "Loading..."
    @Published var bitrate: Int = 0
    
    private var monitorTimer: Timer?
    private var statusObserver: AnyCancellable?
    
    @Published var currentGear: BipBop4x3Gear = BipBop4x3Gear.abrUri
    @Published var currentBitrate: Int = 0
    @Published var currentResolution: String = "Loading..."
    @Published var isAudioOnly: Bool = false
    @Published var currentTime: AVPlayerItem?
    var isABR: Bool {
        return currentGear.uri == BipBop4x3Gear.abrUri.uri
    }

    @Published var isOpenSheet: Bool = false
    
    // MARK: - Method
    
    /// Start AVPLAYER and set Observervale status AVPlayer
    func startMonitoring() {
        print("🚀 Starting AVPlayer")

        player.play()

        // Observe status changes
        statusObserver = player.publisher(for: \.currentItem?.status)
            .sink { [weak self] status in
                guard let self = self else { return }
                if status == .readyToPlay {
                    print("✅ AVPlayer is ready to play")

                    self.startTimer(timeInterval: 1.0)
                }
            }
    }
    
    /// Set schedule timer with repeat time to update Status
    /// - Parameter timeInterval: Time to repeat a schedule
    private func startTimer(
        timeInterval: TimeInterval
    ) {
        monitorTimer?.invalidate()

        monitorTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            guard self.player.currentItem != nil else {
                print("⚠️ player.currentItem is nil")
                return
            }

            Task { @MainActor in
                await self.updateStats()
            }
        }
    }
    
    /// STOP Timer and Observervable
    func stopMonitoring() {
        print("🛑 Stopping monitoring")
        monitorTimer?.invalidate()
        monitorTimer = nil
        statusObserver = nil
    }
    
    /// Pause AVPLAYER
    func pauseMonitoring() {
        print("⏸️ Pause AVPlayer")
        player.pause()
    }
    
    /// Update status of current AVPlayer, also update features to UI
    @MainActor
    private func updateStats() async {
        guard let currentItem = player.currentItem else {
            print("❌ currentItem is nil")
            self.isAudioOnly = false
            self.currentResolution = "_"
            self.currentBitrate = 0
            return
        }

        /// Try AVAsset.loadTracks first (Decline)

        //     •    ✅ AVPlayerItem.tracks: will obiviously see at the time playback ready
        //     •    ❌ AVAsset.loadTracks(withMediaType:): don't see anything until playback fully resolved in manifest/playlist
        
        /// Fallback to AVPlayerItem.tracks
        for itemTrack in currentItem.tracks {
            
            if let track = itemTrack.assetTrack,
               track.mediaType == .video
            {
                
                do {
                    let naturalSize = try await track.load(.naturalSize)
                    let dataRate = try await track.load(.estimatedDataRate)
                    
                    let width = Int(abs(naturalSize.width))
                    let height = Int(abs(naturalSize.height))
                    let kbps = Int(dataRate / 1000)
                    
                    print("✅ Fallback: Resolution \(width)x\(height), Bitrate \(kbps) kbps")
                    
                    self.currentResolution = "\(width)x\(height)"
                    self.currentBitrate = kbps
                    self.isAudioOnly = false
                    
                    return
                } catch {
                    print("⚠️ Error loading fallback track info: \(error)")
                }
                
            }
            
        }

        /// Still no video
        print("❌ No video track found at all")
        self.isAudioOnly = true
        self.currentResolution = "_"
        self.currentBitrate = 0
    }
    
    
    /// Function can set new gear while playing AVPlayer with correctly time paused it
    /// - Parameter gear: BipBop4x3Gear
    public func setGear(_ gear: BipBop4x3Gear) {
        
        /// Get current time
        let currentTime = player.currentTime()
        
        self.stopMonitoring()
        self.pauseMonitoring()
        
        let newItem = AVPlayerItem(url: URL(string: gear.uri)!)
        
        player.replaceCurrentItem(with: newItem)
        
        /// Set Gear
        self.currentGear = gear
        
        self.statusObserver = player.publisher(for: \.currentItem?.status)
            .sink { [weak self] status in
                
                guard let self else { return }
                
                if status == .readyToPlay {
                    
                    /// Seek
                    player.seek(to: currentTime) { _ in
                        self.player.play()
                        self.startTimer(timeInterval: 1.0)
                    }
                    
                }
                
            }
    }
}
