//
//  AccountsView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

struct AccountsView: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            StickyHeaderView(title: "Accounts", subtitle: "Your engagements", trailingButton: "person.circle.fill") {
                VStack(spacing: 16) {
                    // Account Cards
                    VStack(spacing: 16) {
                        Button {
                            navigationPath.append("ResursFamily")
                        } label: {
                            AccountCard(
                                title: "Resurs Family",
                                accountType: "Joint Credit Account",
                                accountNumber: "**** 1234",
                                balance: "56 005 SEK",
                                icon: "heart.fill",
                                color: .blue,
                                balanceLabel: "Available Balance"
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                        
                        AccountCard(
                            title: "Dirt Bike Savings",
                            accountType: "Savings Account",
                            accountNumber: "**** 5678",
                            balance: "39 136 SEK",
                            icon: "chart.line.uptrend.xyaxis",
                            color: .green,
                            balanceLabel: "Available Balance"
                        )
                        
                        AccountCard(
                            title: "Jula Credit Account",
                            accountType: "Jula",
                            accountNumber: "**** 9012",
                            balance: "20 000 SEK",
                            icon: "link.circle.fill",
                            color: .purple,
                            balanceLabel: "Available Balance"
                        )
                        
                        AccountCard(
                            title: "Toyota Billån",
                            accountType: "Consumer Loan",
                            accountNumber: "**** 4567",
                            balance: "114 300 SEK",
                            icon: "dollarsign.circle.fill",
                            color: .orange,
                            balanceLabel: "Current Debt"
                        )
                        
                        AccountCard(
                            title: "Komplett Phone Trade In",
                            accountType: "Komplett",
                            accountNumber: "**** 7890",
                            balance: "8 200 SEK",
                            icon: "link.circle.fill",
                            color: .blue,
                            balanceLabel: "Balance"
                            )
                        }
                        .padding(.horizontal)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: String.self) { value in
                if value == "ResursFamily" {
                    ResursFamilyAccountView()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
                // If not at root level, pop to root
                if !navigationPath.isEmpty {
                    navigationPath.removeLast(navigationPath.count)
                }
                // If at root, the StickyHeaderView will handle scrolling to top
            }
        }
    }
}

struct AccountCard: View {
    let title: String
    let accountType: String?
    let accountNumber: String
    let balance: String
    let icon: String
    let color: Color
    let balanceLabel: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Icon with account type
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 44, height: 44)
                    .background(color.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                if let accountType = accountType {
                    Text(accountType)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Title
            Text(title)
                        .font(.title2)
                        .fontWeight(.bold)
            
            Spacer()
                .frame(height: 2)
            
            // Available amount at bottom
            VStack(alignment: .leading, spacing: 3) {
                Text(balanceLabel)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(balance)
                    .font(.system(size: 22, weight: .bold))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(18)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    AccountsView()
        .preferredColorScheme(.dark)
}
