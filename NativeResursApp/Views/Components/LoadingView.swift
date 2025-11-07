//
//  LoadingView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-11-07.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // App logo or brand icon
                Image(systemName: "creditcard.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                
                // Spinner
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
            }
        }
    }
}

#Preview {
    LoadingView()
        .preferredColorScheme(.dark)
}

