//
//  WalletView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

struct WalletView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            StickyHeaderView(title: "Wallet", subtitle: "Good morning", trailingButton: "person.circle.fill") {
                // Sticky Pills Section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        Button(action: { selectedTab = 0 }) {
                            Text("Invoices")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTab == 0 ? .primary : .secondary)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(selectedTab == 0 ? Color.cyan.opacity(0.2) : Color.clear)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(selectedTab == 0 ? Color.cyan : Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedTab = 1 }) {
                            Text("Purchases")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTab == 1 ? .primary : .secondary)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(selectedTab == 1 ? Color.cyan.opacity(0.2) : Color.clear)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(selectedTab == 1 ? Color.cyan : Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedTab = 2 }) {
                            Text("Errands")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTab == 2 ? .primary : .secondary)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(selectedTab == 2 ? Color.cyan.opacity(0.2) : Color.clear)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(selectedTab == 2 ? Color.cyan : Color.secondary.opacity(0.3), lineWidth: 1)
                                    )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 12)
                } content: {
                    VStack(spacing: 16) {
                        // Content based on selected tab
                        if selectedTab == 0 {
                            InvoicesList()
                        } else if selectedTab == 1 {
                            PurchasesList()
                        } else {
                            ErrandsList()
                        }
                    }
                }
            .navigationBarHidden(true)
        }
    }
}

struct PurchasesList: View {
    var body: some View {
        VStack(spacing: 12) {
            // Credit Info Box
            CreditInfoBox()
                .padding(.vertical, 8)
            
            PurchaseRow(
                title: "Coffee Shop",
                subtitle: "Today, 2:30 PM",
                amount: "45.00 SEK",
                icon: "cup.and.saucer.fill",
                color: .brown
            )
            
            PurchaseRow(
                title: "Grocery Store",
                subtitle: "Yesterday, 5:15 PM",
                amount: "678.90 SEK",
                icon: "cart.fill",
                color: .green
            )
            
            PurchaseRow(
                title: "Gas Station",
                subtitle: "Yesterday, 8:30 AM",
                amount: "452.00 SEK",
                icon: "fuelpump.fill",
                color: .orange
            )
            
            PurchaseRow(
                title: "Online Purchase",
                subtitle: "2 days ago, 7:45 PM",
                amount: "899.90 SEK",
                icon: "bag.fill",
                color: .purple
            )
            
            PurchaseRow(
                title: "Restaurant",
                subtitle: "3 days ago, 7:00 PM",
                amount: "321.50 SEK",
                icon: "fork.knife",
                color: .red
            )
            
            PurchaseRow(
                title: "Pharmacy",
                subtitle: "4 days ago, 11:20 AM",
                amount: "234.50 SEK",
                icon: "cross.fill",
                color: .pink
            )
            
            PurchaseRow(
                title: "Bookstore",
                subtitle: "5 days ago, 3:15 PM",
                amount: "189.90 SEK",
                icon: "book.fill",
                color: .indigo
            )
            
            PurchaseRow(
                title: "Movie Theater",
                subtitle: "6 days ago, 8:45 PM",
                amount: "245.00 SEK",
                icon: "tv.fill",
                color: .cyan
            )
            
            PurchaseRow(
                title: "Clothing Store",
                subtitle: "1 week ago, 2:30 PM",
                amount: "1,567.80 SEK",
                icon: "tshirt.fill",
                color: .mint
            )
        }
        .padding(.horizontal)
    }
}

struct ErrandsList: View {
    var body: some View {
        VStack(spacing: 12) {
            ErrandRow(
                title: "Renew Insurance",
                subtitle: "Due in 2 days",
                icon: "shield.fill",
                color: .blue
            )
            
            ErrandRow(
                title: "Update Payment Method",
                subtitle: "Recommended",
                icon: "creditcard.fill",
                color: .orange
            )
            
            ErrandRow(
                title: "Review Credit Limit",
                subtitle: "Action available",
                icon: "chart.bar.fill",
                color: .purple
            )
            
            ErrandRow(
                title: "Complete Profile",
                subtitle: "80% complete",
                icon: "person.fill",
                color: .green
            )
            
            ErrandRow(
                title: "Set Up Auto-Pay",
                subtitle: "Simplify payments",
                icon: "repeat.circle.fill",
                color: .cyan
            )
        }
        .padding(.horizontal)
    }
}

struct ErrandRow: View {
    let title: String
    let subtitle: String
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
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InvoicesList: View {
    var body: some View {
        VStack(spacing: 12) {
            // Quick Info Box
            WalletInfoBox()
                .padding(.vertical, 8)
            
            // Overdue invoices at the top
            InvoiceRow(
                title: "Bauhaus",
                subtitle: "Overdue by 2 days",
                amount: "2,456.70 SEK",
                icon: "hammer.fill",
                color: .orange,
                isOverdue: true
            )
            
            InvoiceRow(
                title: "Gekås",
                subtitle: "Overdue by 1 day",
                amount: "894.50 SEK",
                icon: "bag.fill",
                color: .orange,
                isOverdue: true
            )
            
            // Due within 4 days (yellow)
            InvoiceRow(
                title: "Netonnet",
                subtitle: "Due in 3 days",
                amount: "1,567.80 SEK",
                icon: "laptopcomputer",
                color: .yellow,
                isOverdue: false
            )
            
            InvoiceRow(
                title: "IKEA",
                subtitle: "Due tomorrow",
                amount: "12,000.00 SEK",
                icon: "bed.double.fill",
                color: .yellow,
                isOverdue: false
            )
            
            // Regular due dates (cyan)
            InvoiceRow(
                title: "Elgiganten",
                subtitle: "Due in 1 week",
                amount: "899.90 SEK",
                icon: "tv.fill",
                color: .cyan,
                isOverdue: false
            )
            
            InvoiceRow(
                title: "Clas Ohlson",
                subtitle: "Due in 2 weeks",
                amount: "785.00 SEK",
                icon: "wrench.and.screwdriver.fill",
                color: .cyan,
                isOverdue: false
            )
            
            InvoiceRow(
                title: "Stadium",
                subtitle: "Due in 1 month",
                amount: "2,340.00 SEK",
                icon: "figure.run",
                color: .cyan,
                isOverdue: false
            )
            
            // Paid invoices at the bottom
            InvoiceRow(
                title: "ICA",
                subtitle: "Paid on Dec 1",
                amount: "452.00 SEK",
                icon: "cart.fill",
                color: .green,
                isOverdue: false
            )
            
            InvoiceRow(
                title: "Åhléns",
                subtitle: "Paid on Nov 28",
                amount: "299.90 SEK",
                icon: "storefront.fill",
                color: .green,
                isOverdue: false
            )
        }
        .padding(.horizontal)
    }
}

struct PurchaseRow: View {
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
                .foregroundColor(.primary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct InvoiceRow: View {
    let title: String
    let subtitle: String
    let amount: String
    let icon: String
    let color: Color
    let isOverdue: Bool
    
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
                    .foregroundColor(isOverdue ? color : .secondary)
            }
            
            Spacer()
            
            Text(amount)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct CreditInfoBox: View {
    var body: some View {
        VStack(spacing: 16) {
            // Total available credit
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Available Credit")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("40,000 SEK")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Credit accounts
            VStack(alignment: .leading, spacing: 12) {
                CreditAccountRow(name: "Resurs Credit Card", available: "25,000 SEK", limit: "50,000 SEK")
                CreditAccountRow(name: "Resurs Flex Account", available: "15,000 SEK", limit: "30,000 SEK")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct CreditAccountRow: View {
    let name: String
    let available: String
    let limit: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(available) available of \(limit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color.cyan.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct WalletInfoBox: View {
    var body: some View {
        VStack(spacing: 16) {
            // Amount to pay
            VStack(alignment: .leading, spacing: 8) {
                Text("Amount to Pay")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("16,918.90 SEK")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                        .foregroundColor(.orange)
                    Text("2 overdue invoices")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Payment options
            HStack(spacing: 8) {
                Image(systemName: "square.grid.2x2.fill")
                    .foregroundColor(.cyan)
                Text("Part payment options available")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    WalletView()
        .preferredColorScheme(.dark)
}
