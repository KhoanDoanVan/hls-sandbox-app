//
//  HLSVisualizerView.swift
//  hls-sandbox-ios-app
//
//  Created by Đoàn Văn Khoan on 21/5/25.
//

import SwiftUI
import AVKit

struct HLSBasicStreamBipBop4x3VisualizerView: View {
    @StateObject private var viewModel = HLSBasicStreamBipBop4x3VisualizerViewModel()

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                VideoPlayer(player: viewModel.player)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.cyan.opacity(0.5), lineWidth: 1))
                    .shadow(color: .cyan.opacity(0.3), radius: 10, x: 0, y: 4)

                VStack(alignment: .leading, spacing: 8) {
                    Text("📺 Resolution: \(viewModel.currentResolution)")
                    Text("📶 Bitrate: \(viewModel.currentBitrate) kbps")
                    Text("🔊 Audio Only: \(viewModel.isAudioOnly ? "Yes" : "No")")
                    Text("🔗 URI: \(viewModel.currentGear.uri)")
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
                
                Button("🔄 Restart Monitoring") {
                    viewModel.stopMonitoring()
                    viewModel.startMonitoring()
                }
                .font(.headline)
                .foregroundStyle(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(.indigo)
                .clipShape(Capsule())
                
                Button("⛮ Settings Qualities") {
                    viewModel.isOpenSheet.toggle()
                }
                .font(.headline)
                .foregroundStyle(.black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(LinearGradient(
                    colors: [Color.gray, Color.purple.opacity(0.6), Color.indigo.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ))
                .clipShape(Capsule())


                
            }
            .padding()
            .onAppear {
                viewModel.startMonitoring()
            }
            .onDisappear {
                viewModel.stopMonitoring()
            }
            .sheet(isPresented: $viewModel.isOpenSheet) {
                sheetSettings()
            }
        }
    }

    @ViewBuilder
    private func sheetSettings() -> some View {
        NavigationStack {
            ZStack {

                LinearGradient(
                    colors: [Color.black, Color.purple.opacity(0.6), Color.indigo.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 4) {
                    // Auto Bitrate
                    buttonGearItem(
                        label: BipBop4x3Gear.abrUri.label,
                        isSelected: viewModel.currentGear.uri == BipBop4x3Gear.abrUri.uri
                    ) {
                        viewModel.setGear(BipBop4x3Gear.abrUri)
                    }

                    ForEach(BipBop4x3Gear.gears, id: \.id) { gear in
                        buttonGearItem(
                            label: gear.label,
                            isSelected: viewModel.currentGear.uri == gear.uri
                        ) {
                            viewModel.setGear(gear)
                        }
                    }

                    /// Close button
                    Button {
                        viewModel.isOpenSheet.toggle()
                    } label: {
                        Image(systemName: "xmark.diamond.fill")
                            .font(.title)
                            .frame(width: 50, height: 50)
                            .background(
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .shadow(color: .cyan.opacity(0.6), radius: 10)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.cyan.opacity(0.7), lineWidth: 1.5)
                            )
                            .foregroundStyle(.cyan)
                            .scaleEffect(1.05)
                            .shadow(color: .cyan.opacity(0.5), radius: 8, x: 0, y: 0)
                    }
                    .padding(.top, 12)
                }
                .padding(.vertical, 20)
                .navigationTitle("Quality Video")
                .navigationBarTitleDisplayMode(.inline)
                .presentationDetents([.medium])
            }
        }
    }

    /// Reusable button style for gear items
    @ViewBuilder
    private func buttonGearItem(label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(
                    (isSelected
                     ? AnyShapeStyle(LinearGradient(colors: [.mint, .cyan], startPoint: .topLeading, endPoint: .bottomTrailing))
                     : AnyShapeStyle(Color.white.opacity(0.1)))
                )
                .foregroundStyle(isSelected ? .black : .white)
                .clipShape(Capsule())
                .shadow(color: isSelected ? .cyan.opacity(0.4) : .clear, radius: 8)
                .padding(.horizontal, 24)
        }
    }
}
