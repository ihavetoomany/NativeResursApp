//
//  NativeResursAppApp.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

@main
struct NativeResursAppApp: App {
    @State private var isLoading = true
    @State private var showAbout = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if isLoading {
                    LoadingView()
                        .transition(.opacity)
                } else {
                    ContentView()
                        .transition(.opacity)
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                // Simulate app initialization
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        isLoading = false
                    }
                    // Show about dialog after loading
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        showAbout = true
                    }
                }
            }
            .alert("About this app", isPresented: $showAbout) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("This app is used to experiment and determine future solutions and information architecture. It does not represent the future app in terms of colors and design. You are welcome to provide any kind of feedback through the feedback functionality in TestFlight.")
            }
        }
    }
}
