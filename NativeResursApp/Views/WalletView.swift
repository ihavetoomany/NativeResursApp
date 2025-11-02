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
                VStack(spacing: 16) {
                    // Quick Info Box
                    WalletInfoBox()
                        .padding(.horizontal)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                    
                    // Tab selection
                    HStack(spacing: 0) {
                        Button(action: { selectedTab = 0 }) {
                            VStack(spacing: 8) {
                                Text("Invoices")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedTab == 0 ? .cyan : .secondary)
                                
                                Rectangle()
                                    .fill(selectedTab == 0 ? .cyan : .clear)
                                    .frame(height: 2)
                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        Button(action: { selectedTab = 1 }) {
                            VStack(spacing: 8) {
                                Text("Purchases")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedTab == 1 ? .cyan : .secondary)
                                
                                Rectangle()
                                    .fill(selectedTab == 1 ? .cyan : .clear)
                                    .frame(height: 2)
                                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .frame(height: 44) // Fixed height for tab buttons

                    // Content based on selected tab
                    if selectedTab == 0 {
                        InvoicesList()
                    } else {
                        PurchasesList()
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

struct InvoicesList: View {
    var body: some View {
        VStack(spacing: 12) {
            // Overdue invoices at the top
            InvoiceRow(
                title: "Bauhaus",
                subtitle: "Overdue by 2 days",
                amount: "2,456.70 SEK",
                icon: "hammer.fill",
                color: .red,
                isOverdue: true
            )
            
            InvoiceRow(
                title: "Gekås",
                subtitle: "Overdue by 1 day",
                amount: "894.50 SEK",
                icon: "bag.fill",
                color: .red,
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
                    .foregroundColor(isOverdue ? .red : .secondary)
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
