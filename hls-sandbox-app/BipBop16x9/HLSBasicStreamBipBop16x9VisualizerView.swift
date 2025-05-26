//
//  HLSBasicStreamBipBop16x9VisualizerView.swift
//  hls-sandbox-app
//
//  Created by Đoàn Văn Khoan on 26/5/25.
//

import Foundation
import SwiftUI
import AVFoundation
import AVKit

struct HLSBasicStreamBipBop16x9VisualizerView: View {
    
    @StateObject var vm: HLSBasicStreamBipBop16x9VisualizerViewModel
    
    var body: some View {
        
        VStack {
            
            if let player = vm.player {
                VideoPlayer(player: player)
                    .frame(height: 240)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("📺 Resolution: \(vm.currentVariant?.resolution ?? "0")")
                Text("📶 Bitrate: \(vm.currentVariant?.bitrate ?? 0) kbps")
                Text("🔗 URI: \(vm.currentVariant?.url)")
                    .lineLimit(4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.indigo)
            .bold()
            .padding()
            .background(.white.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 12).stroke(.cyan.opacity(0.4), lineWidth: 0.5))
            
            Spacer()
            
            Picker("Quality", selection: $vm.currentVariant) {
                ForEach(vm.availableVariants) { variant in
                    Text(variant.label)
                        .tag(variant as VideoVariant?)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: vm.currentVariant) { oldValue, newValue in
                if let variant = newValue {
                    vm.selectVariant(variant)
                    print("Change Variant: \(variant.label)")
                }
            }
            .onAppear {
                vm.fetchAvailableVariants()
            }
        }
        .padding()
        
    }
    
}
