//
//  AccountsView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

struct AccountsView: View {
    var body: some View {
        NavigationStack {
            StickyHeaderView(title: "Accounts", subtitle: "Your engagements", trailingButton: "person.circle.fill") {
                VStack(spacing: 16) {
                    // Account Cards
                    VStack(spacing: 16) {
                        AccountCard(
                            title: "Checking Account",
                            accountNumber: "**** 1234",
                            balance: "$8,432.10",
                            icon: "building.columns.fill",
                            color: .blue
                        )
                        
                        AccountCard(
                            title: "Savings Account",
                            accountNumber: "**** 5678",
                            balance: "$3,913.57",
                            icon: "banknote.fill",
                            color: .green
                        )
                        
                        AccountCard(
                            title: "Investment Account",
                            accountNumber: "**** 9012",
                            balance: "$15,678.90",
                            icon: "chart.line.uptrend.xyaxis",
                            color: .purple
                        )
                    }
                    .padding(.horizontal)
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    // Recent Transactions
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recent Activity")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Button("See All") {
                                // Navigate to full transaction history
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            TransactionRow(
                                title: "Coffee Shop",
                                subtitle: "Today, 2:30 PM",
                                amount: "-$4.50",
                                icon: "cup.and.saucer.fill",
                                color: .brown
                            )
                            
                            TransactionRow(
                                title: "Salary Deposit",
                                subtitle: "Yesterday, 9:00 AM",
                                amount: "+$3,200.00",
                                icon: "arrow.down.circle.fill",
                                color: .green
                            )
                            
                            TransactionRow(
                                title: "Online Purchase",
                                subtitle: "2 days ago, 7:45 PM",
                                amount: "-$89.99",
                                icon: "bag.fill",
                                color: .orange
                            )
                            
                            TransactionRow(
                                title: "Grocery Store",
                                subtitle: "2 days ago, 5:15 PM",
                                amount: "-$127.34",
                                icon: "cart.fill",
                                color: .green
                            )
                            
                            TransactionRow(
                                title: "Gas Station",
                                subtitle: "3 days ago, 8:30 AM",
                                amount: "-$65.00",
                                icon: "fuelpump.fill",
                                color: .orange
                            )
                            
                            TransactionRow(
                                title: "Restaurant",
                                subtitle: "3 days ago, 7:00 PM",
                                amount: "-$48.50",
                                icon: "fork.knife",
                                color: .red
                            )
                            
                            TransactionRow(
                                title: "Refund",
                                subtitle: "4 days ago, 2:15 PM",
                                amount: "+$25.00",
                                icon: "arrow.uturn.backward.circle.fill",
                                color: .blue
                            )
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

struct AccountCard: View {
    let title: String
    let accountNumber: String
    let balance: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(accountNumber)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(balance)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct TransactionRow: View {
    let title: String
    let subtitle: String
    let amount: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 36, height: 36)
                .background(color.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(amount)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(amount.hasPrefix("+") ? .green : .primary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    AccountsView()
        .preferredColorScheme(.dark)
}
