//
//  ContentView.swift
//  hls-sandbox-app
//
//  Created by Đoàn Văn Khoan on 22/5/25.
//

import SwiftUI

struct ContentView: View {
    
    @Namespace private var animation
    @State private var currentTab: String = "4x3"
    
    var body: some View {
        NavigationStack {
            VStack {
                CustomSegmentedControl()
                
                HLSBasicStreamBipBop4x3VisualizerView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    colors: [
                        Color(red: 0.2, green: 0.0, blue: 0.6),
                        Color(red: 0.0, green: 0.8, blue: 1.0),
                        Color(red: 0.0, green: 1.0, blue: 0.7)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
            )
        }
    }
    
    @ViewBuilder
    func CustomSegmentedControl() -> some View {
        HStack(spacing: 0) {
            
            ForEach(["4x3", "16x9"], id: \.self) { tab in
                VStack (spacing: 0){
                    Text(tab)
                        .font(.title3)
                        .bold()
                        .foregroundStyle(currentTab == tab ? .white : .gray)
                        .frame(width: 100, height: 40)
                        .background {
                            if currentTab == tab {
                                RoundedRectangle(cornerRadius: 15, style: .continuous)
                                    .foregroundStyle(LinearGradient(
                                        colors: [Color.gray, Color.purple.opacity(0.6), Color.indigo.opacity(0.8)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ))
                                    .matchedGeometryEffect(id: "TAB3", in: animation)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation {
                                currentTab = tab
                            }
                        }
                    
                    if currentTab == tab {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 16, height: 3)
                            .foregroundStyle(.white)
                            .matchedGeometryEffect(id: "TABSUB3", in: animation)
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 16, height: 3)
                            .foregroundStyle(.black)
                    }
                }
            }
            
        }
        .padding(2)
        .background {
            Color.black
                .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
        }
    }
}

#Preview {
    ContentView()
}
