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
                            InvoiceDetailsCard(invoice: invoice, isPaid: isPaid)
                                .padding(.horizontal)
                                .padding(.top, 36)
                                .frame(width: geometry.size.width)
                        
                            // Payment Information Card
                            PaymentInformationCard()
                                .padding(.horizontal)
                                .frame(width: geometry.size.width)
                            
                            // Invoice Items
                            InvoiceItemsCard()
                                .padding(.horizontal)
                                .frame(width: geometry.size.width)
                            
                            // Payment Options
                            if !isPaid {
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
                if !isPaid {
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
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text("Payment Information")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
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
        .padding(20)
        .background(Color.blue.opacity(0.1))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct InvoiceItemsCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Invoice Items")
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 12) {
                InvoiceItemRow(
                    name: "TV Wall Mount",
                    quantity: "1",
                    price: "399 SEK"
                )
                
                InvoiceItemRow(
                    name: "HDMI Cable 3m",
                    quantity: "2",
                    price: "298 SEK"
                )
                
                InvoiceItemRow(
                    name: "Power Strip",
                    quantity: "1",
                    price: "249 SEK"
                )
                
                InvoiceItemRow(
                    name: "Cable Management",
                    quantity: "1",
                    price: "179 SEK"
                )
                
                InvoiceItemRow(
                    name: "Universal Remote",
                    quantity: "1",
                    price: "443 SEK"
                )
                
                Divider()
                
                HStack {
                    Text("Total")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Text("1 568 SEK")
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

