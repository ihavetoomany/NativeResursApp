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
    @State private var isChatPressed = false
    @StateObject private var paymentPlansManager = PaymentPlansManager()
    
    var body: some View {
        ZStack {
            // Tab content
            TabView(selection: $selectedTab) {
                WalletView()
                    .tag(0)
                
                AccountsView()
                    .tag(1)
                
                ExploreView()
                    .tag(2)
                
                ChatView()
                    .tag(3)
            }
            .environmentObject(paymentPlansManager)
            
            // Custom Tab Bar with separated Chat bubble
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    
                    HStack(alignment: .center, spacing: 12) {
                        // Main Tab Bar - Liquid Glass Pill
                        HStack(spacing: 0) {
                            // Wallet Tab
                            TabBarButton(
                                icon: selectedTab == 0 ? "creditcard.fill" : "creditcard",
                                label: "Wallet",
                                isSelected: selectedTab == 0
                            ) {
                                selectedTab = 0
                            }
                            
                            // Accounts Tab
                            TabBarButton(
                                icon: selectedTab == 1 ? "building.columns.fill" : "building.columns",
                                label: "Accounts",
                                isSelected: selectedTab == 1
                            ) {
                                selectedTab = 1
                            }
                            
                            // Explore Tab
                            TabBarButton(
                                icon: selectedTab == 2 ? "safari.fill" : "safari",
                                label: "Explore",
                                isSelected: selectedTab == 2
                            ) {
                                selectedTab = 2
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 70)
                        .background(.ultraThinMaterial)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule()
                                .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5)
                        )
                        .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 5)
                        
                    // Chat Bubble (separated)
                    Button {
                        // Haptic feedback
                        let impact = UIImpactFeedbackGenerator(style: .light)
                        impact.impactOccurred()
                        
                        // If already selected, post notification to scroll to top
                        if selectedTab == 3 {
                            NotificationCenter.default.post(name: .scrollToTop, object: nil)
                        }
                        
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = 3
                        }
                    } label: {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                
                                Circle()
                                    .strokeBorder(Color.white.opacity(0.15), lineWidth: 0.5)
                                
                                Image(systemName: "message.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(selectedTab == 3 ? .blue : .secondary)
                            }
                            .frame(width: 70, height: 70)
                            .scaleEffect(isChatPressed ? 0.90 : 1.0)
                            .brightness(isChatPressed ? -0.05 : 0)
                            .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: 5)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .simultaneousGesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    withAnimation(.easeOut(duration: 0.1)) {
                                        isChatPressed = true
                                    }
                                }
                                .onEnded { _ in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        isChatPressed = false
                                    }
                                }
                        )
                    }
                    .padding(.horizontal, 12)
                    .padding(.bottom, 12 - geometry.safeAreaInsets.bottom)
                }
            }
            .ignoresSafeArea(edges: .bottom)
        }
        .onAppear {
            // Hide default tab bar
            UITabBar.appearance().isHidden = true
        }
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
            
            // If already selected, post notification to scroll to top
            if isSelected {
                NotificationCenter.default.post(name: .scrollToTop, object: nil)
            }
            
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                action()
            }
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(isSelected ? .blue : .secondary)
                
                Text(label)
                    .font(.caption2)
                    .foregroundColor(isSelected ? .blue : .secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                isSelected ? 
                Color.white.opacity(0.12) : Color.clear
            )
            .clipShape(Capsule())
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .brightness(isPressed ? -0.05 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        isPressed = false
                    }
                }
        )
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
