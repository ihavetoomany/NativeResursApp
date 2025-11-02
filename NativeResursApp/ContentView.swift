//
//  ContentView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WalletView()
                .tabItem {
                    Image(systemName: selectedTab == 0 ? "creditcard.fill" : "creditcard")
                    Text("Wallet")
                }
                .tag(0)
            
            AccountsView()
                .tabItem {
                    Image(systemName: selectedTab == 1 ? "building.columns.fill" : "building.columns")
                    Text("Accounts")
                }
                .tag(1)
            
            ExploreView()
                .tabItem {
                    Image(systemName: selectedTab == 2 ? "safari.fill" : "safari")
                    Text("Explore")
                }
                .tag(2)
            
            ChatView()
                .tabItem {
                    Image(systemName: selectedTab == 3 ? "message.fill" : "message")
                    Text("Chat")
                }
                .tag(3)
        }
        .tint(Color(UIColor.systemCyan))
        .onAppear {
            // Configure tab bar appearance for Liquid Glass effect in dark mode
            let appearance = UITabBarAppearance()
            appearance.configureWithTransparentBackground()
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            
            // Apply dark mode blur effect
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
            appearance.backgroundEffect = blurEffect
            
            // Dark mode tab bar styling
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.lightGray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.lightGray]
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemCyan
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemCyan]
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
            
            // Customize tab bar styling for dark mode
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().backgroundColor = UIColor.clear
        }
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
