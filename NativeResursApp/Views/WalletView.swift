//
//  WalletView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

struct TransactionData: Hashable {
    let merchant: String
    let amount: String
    let date: String
    let time: String
}

struct WalletView: View {
    @State private var selectedTab = 0
    @State private var navigationPath = NavigationPath()
    @State private var showProfile = false
    
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
        NavigationStack(path: $navigationPath) {
            StickyHeaderView(
                title: "John",
                subtitle: greeting,
                trailingButton: "person.circle.fill",
                trailingButtonAction: {
                    showProfile = true
                }
            ) {
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
                                .background(selectedTab == 0 ? Color.blue.opacity(0.2) : Color.clear)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(selectedTab == 0 ? Color.blue : Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedTab = 1 }) {
                                Text("Purchases")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                                .foregroundColor(selectedTab == 1 ? .primary : .secondary)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(selectedTab == 1 ? Color.blue.opacity(0.2) : Color.clear)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(selectedTab == 1 ? Color.blue : Color.secondary.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Button(action: { selectedTab = 2 }) {
                            Text("Actions")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(selectedTab == 2 ? .primary : .secondary)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 12)
                                .background(selectedTab == 2 ? Color.blue.opacity(0.2) : Color.clear)
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule()
                                        .stroke(selectedTab == 2 ? Color.blue : Color.secondary.opacity(0.3), lineWidth: 1)
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
                            InvoicesList(navigationPath: $navigationPath)
                        } else if selectedTab == 1 {
                            PurchasesList(navigationPath: $navigationPath)
                        } else {
                            ActionsList()
                        }
                    }
                }
            .navigationBarHidden(true)
            .navigationDestination(for: TransactionData.self) { transaction in
                TransactionDetailView(
                    merchant: transaction.merchant,
                    amount: transaction.amount,
                    date: transaction.date,
                    time: transaction.time
                )
            }
            .navigationDestination(for: InvoiceData.self) { invoice in
                InvoiceDetailView(invoice: invoice)
            }
            .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
                // If not at root level, pop to root
                if !navigationPath.isEmpty {
                    navigationPath.removeLast(navigationPath.count)
                }
                // If at root, the StickyHeaderView will handle scrolling to top
            }
            .sheet(isPresented: $showProfile) {
                ProfileView()
            }
        }
    }
}

struct PurchasesList: View {
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 12) {
            // Filter Section Header
            HStack(spacing: 6) {
                Text("FILTER")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Image(systemName: "chevron.down")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.top, 4)
            .padding(.bottom, 4)
            
            PurchaseRow(
                title: "Coffee Shop",
                subtitle: "Today, 2:30 PM",
                amount: "45 SEK",
                icon: "creditcard.fill",
                color: .brown
            )
            
            Button {
                navigationPath.append(TransactionData(
                    merchant: "IKEA",
                    amount: "23 000 SEK",
                    date: "Nov 2, 2025",
                    time: "5:15 PM"
                ))
            } label: {
                PurchaseRow(
                    title: "IKEA",
                    subtitle: "Yesterday, 5:15 PM",
                    amount: "23 000 SEK",
                    icon: "heart.fill",
                    color: .blue
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
                color: .blue
            )
            
            PurchaseRow(
                title: "Restaurant",
                subtitle: "3 days ago, 7:00 PM",
                amount: "322 SEK",
                icon: "heart.fill",
                color: .blue
            )
            
            Button {
                navigationPath.append(TransactionData(
                    merchant: "Bauhaus",
                    amount: "4 356 kr",
                    date: "4 days ago",
                    time: "11:20 AM"
                ))
            } label: {
                PurchaseRow(
                    title: "Bauhaus",
                    subtitle: "4 days ago, 11:20 AM",
                    amount: "4 356 kr",
                    icon: "diamond.fill",
                    color: .orange
                )
            }
            .buttonStyle(PlainButtonStyle())
            
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

struct ActionsList: View {
    var body: some View {
        VStack(spacing: 12) {
            // "QUICK PEAK" Section Header
            HStack {
                Text("QUICK PEAK")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.top, 4)
            .padding(.bottom, 4)
            
            ActionRow(
                title: "View PIN",
                subtitle: "Access your PIN code",
                icon: "eye.fill",
                color: .blue
            )
            
            ActionRow(
                title: "Check Balance",
                subtitle: "View account balance",
                icon: "dollarsign.circle.fill",
                color: .green
            )
            
            // "Suggestions" Section Header
            HStack {
                Text("Suggestions")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.top, 12)
            .padding(.bottom, 4)
            
            ActionRow(
                title: "Connect Bank Account",
                subtitle: "Link your bank",
                icon: "building.columns.fill",
                color: .blue
            )
            
            ActionRow(
                title: "Complete Loan Application",
                subtitle: "Finish your application",
                icon: "doc.text.fill",
                color: .orange
            )
            
            ActionRow(
                title: "Update KYC",
                subtitle: "Verify your identity",
                icon: "person.text.rectangle.fill",
                color: .purple
            )
            
            ActionRow(
                title: "Activate Click to Pay",
                subtitle: "Enable quick payments",
                icon: "hand.tap.fill",
                color: .cyan
            )
        }
        .padding(.horizontal)
    }
}

struct ActionRow: View {
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
    @Binding var navigationPath: NavigationPath
    
    var body: some View {
        VStack(spacing: 12) {
            // Quick Info Box
            WalletInfoBox()
                .padding(.vertical, 8)
            
            // "TO PAY" Section Header
            HStack {
                Text("TO PAY")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.top, 4)
            .padding(.bottom, 4)
            
            // Overdue invoices at the top
            Button {
                navigationPath.append(InvoiceData(
                    merchant: "Bauhaus",
                    amount: "726 kr",
                    dueDate: "Nov 7, 2025",
                    invoiceNumber: "INV-2025-11-001",
                    issueDate: "Nov 7, 2025",
                    status: "Overdue by 2 days",
                    color: .orange
                ))
            } label: {
                InvoiceRow(
                    title: "Bauhaus",
                    subtitle: "Nov 7, 2025",
                    amount: "726 kr",
                    icon: "clock.fill",
                    color: .orange,
                    isOverdue: true
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                navigationPath.append(InvoiceData(
                    merchant: "Gekås",
                    amount: "895 SEK",
                    dueDate: "Nov 8, 2025",
                    invoiceNumber: "INV-2025-10-052",
                    issueDate: "Oct 25, 2025",
                    status: "Overdue by 1 day",
                    color: .orange
                ))
            } label: {
                InvoiceRow(
                    title: "Gekås",
                    subtitle: "Oct 25, 2025",
                    amount: "895 SEK",
                    icon: "clock.fill",
                    color: .orange,
                    isOverdue: true
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Due within 4 days (yellow) - Tappable
            Button {
                navigationPath.append(InvoiceData(
                    merchant: "Netonnet",
                    amount: "1 568 SEK",
                    dueDate: "Nov 12, 2025",
                    invoiceNumber: "INV-2025-11-001",
                    issueDate: "Nov 5, 2025",
                    status: "Due in 3 days",
                    color: .yellow
                ))
            } label: {
                InvoiceRow(
                    title: "Netonnet",
                    subtitle: "Nov 12, 2025",
                    amount: "1 568 SEK",
                    icon: "clock.fill",
                    color: .yellow,
                    isOverdue: false,
                    statusOverride: "3 days"
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Regular due dates
            Button {
                navigationPath.append(InvoiceData(
                    merchant: "Elgiganten",
                    amount: "900 SEK",
                    dueDate: "Nov 16, 2025",
                    invoiceNumber: "INV-2025-11-003",
                    issueDate: "Nov 2, 2025",
                    status: "Due in 1 week",
                    color: .yellow
                ))
            } label: {
                InvoiceRow(
                    title: "Elgiganten",
                    subtitle: "Nov 16, 2025",
                    amount: "900 SEK",
                    icon: "clock.fill",
                    color: .yellow,
                    isOverdue: false,
                    statusOverride: "1 week"
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // "Handled" Section Header
            HStack {
                Text("Handled")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
            }
            .padding(.horizontal, 4)
            .padding(.top, 12)
            .padding(.bottom, 4)
            
            // Scheduled invoices
            Button {
                navigationPath.append(InvoiceData(
                    merchant: "Clas Ohlson",
                    amount: "785 SEK",
                    dueDate: "Nov 15, 2025",
                    invoiceNumber: "INV-2025-11-002",
                    issueDate: "Nov 1, 2025",
                    status: "Scheduled for Nov 15",
                    color: .cyan
                ))
            } label: {
                InvoiceRow(
                    title: "Clas Ohlson",
                    subtitle: "Nov 1, 2025",
                    amount: "785 SEK",
                    icon: "checkmark",
                    color: .cyan,
                    isOverdue: false
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            // Paid invoices
            Button {
                navigationPath.append(InvoiceData(
                    merchant: "Stadium",
                    amount: "2 340 SEK",
                    dueDate: "Nov 8, 2025",
                    invoiceNumber: "INV-2025-10-058",
                    issueDate: "Oct 25, 2025",
                    status: "Paid on Nov 8",
                    color: .green
                ))
            } label: {
                InvoiceRow(
                    title: "Stadium",
                    subtitle: "Oct 25, 2025",
                    amount: "2 340 SEK",
                    icon: "checkmark",
                    color: .green,
                    isOverdue: false
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                navigationPath.append(InvoiceData(
                    merchant: "ICA",
                    amount: "452 SEK",
                    dueDate: "Nov 3, 2025",
                    invoiceNumber: "INV-2025-10-045",
                    issueDate: "Oct 20, 2025",
                    status: "Paid on Nov 3",
                    color: .green
                ))
            } label: {
                InvoiceRow(
                    title: "ICA",
                    subtitle: "Oct 20, 2025",
                    amount: "452 SEK",
                    icon: "checkmark",
                    color: .green,
                    isOverdue: false
                )
            }
            .buttonStyle(PlainButtonStyle())
            
            Button {
                navigationPath.append(InvoiceData(
                    merchant: "Åhléns",
                    amount: "300 SEK",
                    dueDate: "Oct 28, 2025",
                    invoiceNumber: "INV-2025-10-038",
                    issueDate: "Oct 14, 2025",
                    status: "Paid on Oct 28",
                    color: .green
                ))
            } label: {
                InvoiceRow(
                    title: "Åhléns",
                    subtitle: "Oct 14, 2025",
                    amount: "300 SEK",
                    icon: "checkmark",
                    color: .green,
                    isOverdue: false
                )
            }
            .buttonStyle(PlainButtonStyle())
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
    var statusOverride: String? = nil
    
    var body: some View {
        HStack(spacing: 16) {
            // Left: Status icon
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.white)
                .frame(width: 44, height: 44)
                .background(color)
                .clipShape(Circle())
            
            // Middle: Invoice number and date
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Right: Amount and status
            VStack(alignment: .trailing, spacing: 4) {
                Text(amount)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                if !statusText.isEmpty {
                    Text(statusText)
                        .font(.subheadline)
                        .foregroundColor(statusColor)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var statusText: String {
        if let override = statusOverride {
            return override
        }
        if isOverdue {
            return "Overdue"
        } else if color == .green {
            return "Paid"
        } else if color == .cyan {
            return "Scheduled"
        } else {
            return ""
        }
    }
    
    private var statusColor: Color {
        return color
    }
}

struct CreditInfoBox: View {
    @Binding var showDetails: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            // Available credit title
            Text("Your Credit Cards")
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
                                .foregroundColor(.blue)
                                .frame(width: 55, height: 65)
                                .background(.ultraThinMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
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
                    .background(Color.blue)
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
                    .foregroundColor(.blue)
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
        HStack(alignment: .top) {
            Image(systemName: "creditcard.fill")
                .font(.subheadline)
                .foregroundColor(.green)
                .frame(width: 28, height: 28)
                .offset(y: -4)
            
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
    // Invoices in "TO PAY" section: overdue and due invoices
    private let invoices: [(amount: String, isOverdue: Bool)] = [
        ("726 kr", true),      // Bauhaus - overdue
        ("895 SEK", true),     // Gekås - overdue
        ("1 568 SEK", false), // Netonnet - due
        ("900 SEK", false)     // Elgiganten - due
    ]
    
    private var totalAmount: String {
        let total = invoices.reduce(0) { sum, invoice in
            let amountString = invoice.amount
            let cleaned = amountString.replacingOccurrences(of: "kr", with: "")
                .replacingOccurrences(of: "SEK", with: "")
                .replacingOccurrences(of: " ", with: "")
                .trimmingCharacters(in: .whitespaces)
            if let value = Double(cleaned) {
                return sum + value
            }
            return sum
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 0
        if let formatted = formatter.string(from: NSNumber(value: total)) {
            return "\(formatted) SEK"
        }
        return "\(Int(total)) SEK"
    }
    
    private var overdueCount: Int {
        invoices.filter { $0.isOverdue }.count
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Amount to pay
            VStack(alignment: .leading, spacing: 8) {
                Text("Amount to Pay")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(totalAmount)
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.primary)
                
                if overdueCount > 0 {
                    HStack(spacing: 4) {
                        Image(systemName: "exclamationmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("\(overdueCount) overdue invoice\(overdueCount == 1 ? "" : "s")")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            // Payment options
            HStack(spacing: 8) {
                Image(systemName: "square.grid.2x2.fill")
                    .foregroundColor(.blue)
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
