//
//  ContentView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

// Notification for scroll to top
extension Notification.Name {
    static let scrollToTop = Notification.Name("scrollToTop")
}

struct ContentView: View {
    @State private var selectedTab = 0
    @StateObject private var paymentPlansManager = PaymentPlansManager()
    @State private var hasAppeared = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Wallet Tab
            WalletView()
                .tabItem {
                    Label("Wallet", systemImage: selectedTab == 0 ? "creditcard.fill" : "creditcard")
                }
                .tag(0)
            
            // Accounts Tab (lazy loaded)
            Group {
                if hasAppeared || selectedTab == 1 {
                    AccountsView()
                } else {
                    Color.clear
                }
            }
            .tabItem {
                Label("Accounts", systemImage: selectedTab == 1 ? "building.columns.fill" : "building.columns")
            }
            .tag(1)
            
            // Explore Tab (lazy loaded)
            Group {
                if hasAppeared || selectedTab == 2 {
                    ExploreView()
                } else {
                    Color.clear
                }
            }
            .tabItem {
                Label("Explore", systemImage: selectedTab == 2 ? "safari.fill" : "safari")
            }
            .tag(2)
            
            // Support Tab (lazy loaded)
            Group {
                if hasAppeared || selectedTab == 3 {
                    ChatView()
                } else {
                    Color.clear
                }
            }
            .tabItem {
                Label("Support", systemImage: selectedTab == 3 ? "message.fill" : "message")
            }
            .tag(3)
        }
        .environmentObject(paymentPlansManager)
        .tint(.blue) // Native iOS blue tint for selected items
        .onAppear {
            // Defer loading of other tabs to improve startup performance
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                hasAppeared = true
            }
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            // Haptic feedback on tab change
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // If same tab tapped, post notification to scroll to top
            if oldValue == newValue {
                NotificationCenter.default.post(name: .scrollToTop, object: nil)
            }
        }
    }
}

#Preview("Light Mode") {
    ContentView()
        .preferredColorScheme(.light)
}

#Preview("Dark Mode") {
    ContentView()
        .preferredColorScheme(.dark)
}
