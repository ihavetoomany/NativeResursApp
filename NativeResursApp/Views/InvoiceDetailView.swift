//
//  InvoiceDetailView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-11-09.
//

import SwiftUI

struct InvoiceData: Hashable {
    let merchant: String
    let amount: String
    let dueDate: String
    let invoiceNumber: String
    let issueDate: String
    let status: String
    let color: Color
}

struct InvoiceDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.hideTabBar) var hideTabBar
    @StateObject private var scrollObserver = ScrollOffsetObserver()
    @State private var showPaymentSheet = false
    @State private var isPaying = false
    @State private var isPaid = false
    
    let invoice: InvoiceData
    
    private var isInvoicePaid: Bool {
        invoice.status.contains("Paid on")
    }
    
    private var isInvoiceScheduled: Bool {
        invoice.status.contains("Scheduled")
    }
    
    private var shouldShowPayButton: Bool {
        !isInvoicePaid && !isPaid && !isInvoiceScheduled
    }
    
    var body: some View {
        let scrollProgress = min(scrollObserver.offset / 100, 1.0)
        
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Scrollable Content
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: 0) {
                            // Tracking element
                            GeometryReader { geo in
                                Color.clear
                                    .onChange(of: geo.frame(in: .named("scroll")).minY) { oldValue, newValue in
                                        scrollObserver.offset = max(0, -newValue)
                                    }
                            }
                            .frame(height: 0)
                            .id("scrollTop")
                            
                            // Account for header height
                            Color.clear.frame(height: 80)
                        
                        VStack(spacing: 16) {
                            // Invoice Details Card
                            InvoiceDetailsCard(invoice: invoice, isPaid: isPaid || isInvoicePaid)
                                .padding(.horizontal)
                                .padding(.top, 36)
                                .frame(width: geometry.size.width)
                        
                            // Payment Information Card
                            if !isInvoicePaid {
                                PaymentInformationCard(isScheduled: isInvoiceScheduled)
                                    .padding(.horizontal)
                                    .frame(width: geometry.size.width)
                            }
                            
                            // Invoice Items
                            InvoiceItemsCard(merchant: invoice.merchant)
                                .padding(.horizontal)
                                .frame(width: geometry.size.width)
                            
                            // Payment Options
                            if shouldShowPayButton {
                                PaymentOptionsCard()
                                    .padding(.horizontal)
                                    .frame(width: geometry.size.width)
                            }
                        }
                        .padding(.top, 20)
                        .padding(.bottom, 120)
                        .frame(width: geometry.size.width)
                    }
                    .frame(width: geometry.size.width)
                        .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                proxy.scrollTo("scrollTop", anchor: .top)
                            }
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
            
                // Sticky Header
                VStack(spacing: 0) {
                    ZStack {
                        // Back button
                        HStack {
                            Button(action: { dismiss() }) {
                                Image(systemName: "chevron.left")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                                    .frame(width: 32, height: 32)
                                    .background(.ultraThinMaterial)
                                    .clipShape(Circle())
                            }
                            Spacer()
                        }
                        
                        // Minimized title
                        if scrollProgress > 0.5 {
                            Text(invoice.merchant)
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, scrollProgress > 0.5 ? 8 : 12)
                    
                    // Title and subtitle
                    if scrollProgress <= 0.5 {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Invoice Details")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .opacity(1.0 - scrollProgress * 2)
                            
                            Text(invoice.merchant)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.bottom, 16)
                    }
                }
                .background(Color.black.opacity(0.85))
                .background(.ultraThinMaterial)
                .animation(.easeInOut(duration: 0.2), value: scrollProgress)
                .frame(width: geometry.size.width)
                
                // Floating Pay Button
                if shouldShowPayButton {
                    VStack(spacing: 0) {
                        Spacer()
                        
                        Button(action: {
                            showPaymentSheet = true
                        }) {
                            HStack {
                                Image(systemName: "creditcard.fill")
                                    .font(.title3)
                                Text("Pay Invoice")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.blue)
                            .clipShape(Capsule())
                            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                    }
                    .ignoresSafeArea(edges: .bottom)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar.wrappedValue = true
        }
        .onDisappear {
            hideTabBar.wrappedValue = false
        }
        .sheet(isPresented: $showPaymentSheet) {
            PaymentSheet(
                invoice: invoice,
                onPaymentCompleted: {
                    withAnimation {
                        isPaid = true
                    }
                }
            )
            .presentationDetents([.medium, .large])
            .presentationDragIndicator(.visible)
        }
    }
}

struct InvoiceDetailsCard: View {
    let invoice: InvoiceData
    let isPaid: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            // Status Badge
            if isPaid {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.green)
                    Text("Payment Successful")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.green)
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(Color.green.opacity(0.1))
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            // Amount
            VStack(spacing: 8) {
                Text(invoice.amount)
                    .font(.system(size: 48, weight: .bold))
                
                HStack(spacing: 8) {
                    Image(systemName: "doc.text.fill")
                        .font(.caption)
                        .foregroundColor(invoice.color)
                    Text(isPaid ? "Paid" : invoice.status)
                        .font(.subheadline)
                        .foregroundColor(isPaid ? .green : invoice.color)
                }
            }
            
            Divider()
            
            // Details
            VStack(spacing: 12) {
                DetailRow(label: "Merchant", value: invoice.merchant)
                DetailRow(label: "Invoice Number", value: invoice.invoiceNumber)
                DetailRow(label: "Issue Date", value: invoice.issueDate)
                DetailRow(label: "Due Date", value: invoice.dueDate)
                DetailRow(label: "Status", value: isPaid ? "Paid" : invoice.status)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct PaymentInformationCard: View {
    let isScheduled: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: isScheduled ? "calendar.circle.fill" : "info.circle.fill")
                    .font(.title3)
                    .foregroundColor(isScheduled ? .cyan : .blue)
                
                Text(isScheduled ? "Scheduled Payment" : "Payment Information")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            if isScheduled {
                VStack(spacing: 8) {
                    HStack {
                        Text("Status")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Auto-pay scheduled")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Payment Method")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "creditcard.fill")
                                .font(.caption)
                                .foregroundColor(.cyan)
                            Text("Resurs Gold")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                }
            } else {
                VStack(spacing: 8) {
                    HStack {
                        Text("Payment Method")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        HStack(spacing: 6) {
                            Image(systemName: "creditcard.fill")
                                .font(.caption)
                                .foregroundColor(.blue)
                            Text("Resurs Gold")
                                .font(.subheadline)
                                .fontWeight(.medium)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Payment Options")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("Full or Part Payment")
                            .font(.subheadline)
                            .fontWeight(.medium)
                    }
                }
            }
        }
        .padding(20)
        .background((isScheduled ? Color.cyan : Color.blue).opacity(0.1))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct InvoiceItemsCard: View {
    let merchant: String
    
    private var items: [(name: String, quantity: String, price: String, total: String)] {
        switch merchant {
        case "Netonnet":
            return [
                ("TV Wall Mount", "1", "399 SEK", "1 568 SEK"),
                ("HDMI Cable 3m", "2", "298 SEK", "1 568 SEK"),
                ("Power Strip", "1", "249 SEK", "1 568 SEK"),
                ("Cable Management", "1", "179 SEK", "1 568 SEK"),
                ("Universal Remote", "1", "443 SEK", "1 568 SEK")
            ]
        case "Bauhaus":
            return [
                ("Paint Roller Set", "2", "298 SEK", "2 457 SEK"),
                ("Interior Paint 10L", "3", "1 347 SEK", "2 457 SEK"),
                ("Painter's Tape", "4", "236 SEK", "2 457 SEK"),
                ("Drop Cloth", "2", "238 SEK", "2 457 SEK"),
                ("Paint Tray Kit", "1", "338 SEK", "2 457 SEK")
            ]
        case "Gekås":
            return [
                ("Winter Jacket", "1", "495 SEK", "895 SEK"),
                ("Wool Socks 3-pack", "1", "149 SEK", "895 SEK"),
                ("Thermal Underwear", "1", "251 SEK", "895 SEK")
            ]
        case "Elgiganten":
            return [
                ("Bluetooth Speaker", "1", "549 SEK", "900 SEK"),
                ("Phone Case", "1", "199 SEK", "900 SEK"),
                ("USB-C Cable 2m", "1", "152 SEK", "900 SEK")
            ]
        case "Clas Ohlson":
            return [
                ("LED Desk Lamp", "1", "349 SEK", "785 SEK"),
                ("Batteries AA 20-pack", "1", "179 SEK", "785 SEK"),
                ("Extension Cord 3m", "1", "257 SEK", "785 SEK")
            ]
        case "Stadium":
            return [
                ("Running Shoes", "1", "1 299 SEK", "2 340 SEK"),
                ("Sports Bag", "1", "549 SEK", "2 340 SEK"),
                ("Water Bottle", "2", "246 SEK", "2 340 SEK"),
                ("Gym Towel", "1", "246 SEK", "2 340 SEK")
            ]
        case "ICA":
            return [
                ("Groceries", "1", "452 SEK", "452 SEK")
            ]
        case "Åhléns":
            return [
                ("Face Cream", "1", "189 SEK", "300 SEK"),
                ("Hand Soap", "2", "111 SEK", "300 SEK")
            ]
        default:
            return [("Item", "1", "0 SEK", "0 SEK")]
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Invoice Items")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                ForEach(items.indices, id: \.self) { index in
                    InvoiceItemRow(
                        name: items[index].name,
                        quantity: items[index].quantity,
                        price: items[index].price
                    )
                }
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(items.first?.total ?? "0 SEK")
                        .font(.headline)
                        .fontWeight(.bold)
                }
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct InvoiceItemRow: View {
    let name: String
    let quantity: String
    let price: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("Qty: \(quantity)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(price)
                .font(.subheadline)
                .fontWeight(.semibold)
        }
    }
}

struct PaymentOptionsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Payment Options")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                PaymentOptionRow(
                    icon: "checkmark.circle.fill",
                    title: "Pay in Full",
                    description: "Pay the entire amount now",
                    color: .blue
                )
                
                PaymentOptionRow(
                    icon: "calendar.circle.fill",
                    title: "Part Payment",
                    description: "Pay a portion now, rest later",
                    color: .purple
                )
                
                PaymentOptionRow(
                    icon: "arrow.triangle.2.circlepath.circle.fill",
                    title: "Payment Plan",
                    description: "Spread payments over time",
                    color: .green
                )
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct PaymentOptionRow: View {
    let icon: String
    let title: String
    let description: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
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
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.gray.opacity(0.05))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

struct PaymentSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPaymentOption = 0
    @State private var partPaymentAmount = ""
    @State private var isProcessing = false
    
    let invoice: InvoiceData
    let onPaymentCompleted: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                // Payment Amount
                VStack(spacing: 12) {
                    Text("Payment Amount")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(invoice.amount)
                        .font(.system(size: 42, weight: .bold))
                        .foregroundColor(.blue)
                    
                    Text(invoice.merchant)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                // Payment Method
                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment Method")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Image(systemName: "creditcard.fill")
                            .font(.title3)
                            .foregroundColor(.blue)
                            .frame(width: 36, height: 36)
                            .background(Color.blue.opacity(0.2))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Resurs Gold")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("25 000 SEK available")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                // Payment Type Selection
                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment Type")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Picker("Payment Type", selection: $selectedPaymentOption) {
                        Text("Pay in Full").tag(0)
                        Text("Part Payment").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Confirm Button
                Button(action: {
                    isProcessing = true
                    // Simulate payment processing
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        onPaymentCompleted()
                        dismiss()
                    }
                }) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.title3)
                        }
                        Text(isProcessing ? "Processing..." : "Confirm Payment")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(isProcessing ? Color.gray : Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isProcessing)
                .padding(.horizontal)
                .padding(.bottom, 32)
            }
            .background(Color(UIColor.systemBackground))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    .disabled(isProcessing)
                }
            }
        }
    }
}

#Preview {
    InvoiceDetailView(
        invoice: InvoiceData(
            merchant: "Netonnet",
            amount: "1 568 SEK",
            dueDate: "Nov 12, 2025",
            invoiceNumber: "INV-2025-11-001",
            issueDate: "Nov 5, 2025",
            status: "Due in 3 days",
            color: .yellow
        )
    )
    .preferredColorScheme(.dark)
}

