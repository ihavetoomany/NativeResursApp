//
//  WalletView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

struct WalletView: View {
    @State private var selectedTab = 0
    
    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<11:
            return "Good morning"
        case 11..<16:
            return "Good day"
        case 16..<23:
            return "Good evening"
        default:
            return "Good night"
        }
    }
    
    var body: some View {
        NavigationStack {
            StickyHeaderView(title: "Wallet", subtitle: greeting, trailingButton: "person.circle.fill") {
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
    @State private var showCreditDetails = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Credit Info Box
            CreditInfoBox(showDetails: $showCreditDetails)
                .padding(.vertical, 8)
            
            PurchaseRow(
                title: "Coffee Shop",
                subtitle: "Today, 2:30 PM",
                amount: "45 SEK",
                icon: "creditcard.fill",
                color: .brown
            )
            
            NavigationLink(destination: TransactionDetailView(
                merchant: "IKEA",
                amount: "23 000 SEK",
                date: "Nov 2, 2025",
                time: "5:15 PM"
            )) {
                PurchaseRow(
                    title: "IKEA",
                    subtitle: "Yesterday, 5:15 PM",
                    amount: "23 000 SEK",
                    icon: "heart.fill",
                    color: .cyan
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            PurchaseRow(
                title: "Gas Station",
                subtitle: "Yesterday, 8:30 AM",
                amount: "452 SEK",
                icon: "creditcard.fill",
                color: .brown
            )
            
            PurchaseRow(
                title: "Online Purchase",
                subtitle: "2 days ago, 7:45 PM",
                amount: "900 SEK",
                icon: "heart.fill",
                color: .cyan
            )
            
            PurchaseRow(
                title: "Restaurant",
                subtitle: "3 days ago, 7:00 PM",
                amount: "322 SEK",
                icon: "heart.fill",
                color: .cyan
            )
            
            PurchaseRow(
                title: "Pharmacy",
                subtitle: "4 days ago, 11:20 AM",
                amount: "235 SEK",
                icon: "creditcard.fill",
                color: .brown
            )
            
            PurchaseRow(
                title: "Bookstore",
                subtitle: "5 days ago, 3:15 PM",
                amount: "190 SEK",
                icon: "creditcard.fill",
                color: .brown
            )
            
            PurchaseRow(
                title: "Movie Theater",
                subtitle: "6 days ago, 8:45 PM",
                amount: "245 SEK",
                icon: "creditcard.fill",
                color: .brown
            )
            
            PurchaseRow(
                title: "Clothing Store",
                subtitle: "1 week ago, 2:30 PM",
                amount: "1 568 SEK",
                icon: "creditcard.fill",
                color: .brown
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
                amount: "2 457 SEK",
                icon: "doc.text.fill",
                color: .orange,
                isOverdue: true
            )
            
            InvoiceRow(
                title: "Gekås",
                subtitle: "Overdue by 1 day",
                amount: "895 SEK",
                icon: "doc.text.fill",
                color: .orange,
                isOverdue: true
            )
            
            // Due within 4 days (yellow)
            InvoiceRow(
                title: "Netonnet",
                subtitle: "Due in 3 days",
                amount: "1 568 SEK",
                icon: "doc.text.fill",
                color: .yellow,
                isOverdue: false
            )
            
            // Regular due dates (cyan)
            InvoiceRow(
                title: "Elgiganten",
                subtitle: "Due in 1 week",
                amount: "900 SEK",
                icon: "doc.text.fill",
                color: .yellow,
                isOverdue: false
            )
            
            // Paid invoices at the bottom
            InvoiceRow(
                title: "Clas Ohlson",
                subtitle: "Paid on Nov 15",
                amount: "785 SEK",
                icon: "doc.text.fill",
                color: .green,
                isOverdue: false
            )
            
            InvoiceRow(
                title: "Stadium",
                subtitle: "Paid on Nov 8",
                amount: "2 340 SEK",
                icon: "doc.text.fill",
                color: .green,
                isOverdue: false
            )
            
            InvoiceRow(
                title: "ICA",
                subtitle: "Paid on Nov 3",
                amount: "452 SEK",
                icon: "doc.text.fill",
                color: .green,
                isOverdue: false
            )
            
            InvoiceRow(
                title: "Åhléns",
                subtitle: "Paid on Oct 28",
                amount: "300 SEK",
                icon: "doc.text.fill",
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
    @Binding var showDetails: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Available credit title
            Text("Available Credit")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Credit accounts
            VStack(alignment: .leading, spacing: 8) {
                CreditAccountRow(name: "Resurs Gold", available: "25 000 SEK", limit: "50 000 SEK")
                CreditAccountRow(name: "Resurs Family", available: "15 000 SEK", limit: "30 000 SEK")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(Color.green.opacity(0.1))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            showDetails = true
        }
        .sheet(isPresented: $showDetails) {
            CreditDetailsSheet()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
    }
}

struct CreditDetailsSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var showPIN = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // PIN Code Section
                VStack(spacing: 12) {
                    Text("Credit Account PIN")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    // PIN Display
                    HStack(spacing: 12) {
                        ForEach(showPIN ? ["1", "2", "3", "4"] : ["*", "*", "*", "*"], id: \.self) { digit in
                            Text(digit)
                                .font(.system(size: 32, weight: .bold))
                                .foregroundColor(.cyan)
                                .frame(width: 55, height: 65)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.cyan.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                    
                    Text("Use this PIN for credit account purchases")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 24)
                
                Spacer()
                    .frame(height: 40)
                
                // Show PIN Button
                Button(action: {
                    withAnimation {
                        showPIN.toggle()
                    }
                }) {
                    HStack {
                        Image(systemName: showPIN ? "eye.slash.fill" : "eye.fill")
                            .font(.title3)
                        Text(showPIN ? "Hide PIN" : "Show PIN")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.cyan)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color(UIColor.systemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(.cyan)
                }
            }
        }
    }
}

struct CreditAccountRow: View {
    let name: String
    let available: String
    let limit: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("\(available) available of \(limit)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            HStack(spacing: 6) {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundColor(.green)
                Text("***")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.green)
                    .tracking(2)
            }
        }
        .padding(.vertical, 10)
        .background(Color.clear)
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
                
                Text("5 820 SEK")
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
        .background(Color.orange.opacity(0.1))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    WalletView()
        .preferredColorScheme(.dark)
}
