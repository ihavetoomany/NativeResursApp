//
//  TransactionDetailView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-11-03.
//

import SwiftUI
import Combine

struct TransactionDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.hideTabBar) var hideTabBar
    @EnvironmentObject var paymentPlansManager: PaymentPlansManager
    @StateObject private var scrollObserver = ScrollOffsetObserver()
    @State private var showNewPlanSheet = false
    @State private var selectedPaymentPlan: String? = nil
    
    let merchant: String
    let amount: String
    let date: String
    let time: String
    
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
                            .id("scrollTop") // ID for scroll to top
                            
                            // Account for header height
                            Color.clear.frame(height: 80)
                        
                        VStack(spacing: 16) {
                            // Transaction Details Card
                            TransactionDetailsCard(
                                merchant: merchant,
                                amount: amount,
                                date: date,
                                time: time
                            )
                            .padding(.horizontal)
                            .padding(.top, 36)
                            .frame(width: geometry.size.width)
                        
                        // Payment Plans Explanation Section
                        PaymentPlansExplanationCard()
                            .padding(.horizontal)
                            .frame(width: geometry.size.width)
                        
                        // Add to Payment Plan Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(selectedPaymentPlan == nil ? "Add to Payment Plan" : "Added to Payment Plan")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .padding(.top, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if let paymentPlan = selectedPaymentPlan {
                                // Selected Payment Plan State
                                VStack(spacing: 16) {
                                    SelectedPaymentPlanCard(
                                        title: paymentPlan,
                                        amount: amount,
                                        icon: paymentPlansManager.paymentPlans.first(where: { $0.name == paymentPlan })?.icon ?? "tray.fill",
                                        color: paymentPlansManager.paymentPlans.first(where: { $0.name == paymentPlan })?.color ?? .blue,
                                        isNewPaymentPlan: paymentPlansManager.paymentPlans.first(where: { $0.name == paymentPlan })?.dueDate == "Just created"
                                    )
                                    
                                    Button(action: {
                                        withAnimation {
                                            selectedPaymentPlan = nil
                                        }
                                    }) {
                                        Text("Remove from Payment Plan")
                                            .font(.headline)
                                            .foregroundColor(.red)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color.red.opacity(0.1))
                                            .background(.ultraThinMaterial)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                }
                                .padding(.horizontal)
                            } else {
                                // Default State - Select Payment Plan
                                VStack(spacing: 12) {
                                    // Existing Payment Plans (excluding paid off)
                                    ForEach(paymentPlansManager.paymentPlans.filter { 
                                        $0.progress < 1.0
                                    }) { paymentPlan in
                                        Button(action: {
                                            withAnimation {
                                                selectedPaymentPlan = paymentPlan.name
                                            }
                                        }) {
                                            ExistingPaymentPlanRow(
                                                title: paymentPlan.name,
                                                amount: paymentPlan.totalAmount,
                                                icon: paymentPlan.icon,
                                                color: paymentPlan.color
                                            )
                                        }
                                    }
                                    
                                    // Create New Payment Plan Button
                                    Button(action: {
                                        showNewPlanSheet = true
                                    }) {
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title3)
                                                .foregroundColor(.blue)
                                                .frame(width: 36, height: 36)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Create New Payment Plan")
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.primary)
                                                Text("Start a new payment plan")
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
                                .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 16)
                        .frame(width: geometry.size.width)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 120) // Add bottom padding to clear custom tab bar
                    .frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width)
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                            proxy.scrollTo("scrollTop", anchor: .top)
                        }
                    }
                }
                .coordinateSpace(name: "scroll")
            
                // Sticky Header (overlays the content)
                VStack(spacing: 0) {
                ZStack {
                    // Back button (always visible) - on the left
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
                    
                    // Minimized title - centered in view
                    if scrollProgress > 0.5 {
                        Text(merchant)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, scrollProgress > 0.5 ? 8 : 12)
                
                // Title and subtitle - only shown when not minimized
                if scrollProgress <= 0.5 {
                    VStack(alignment: .leading, spacing: 4) {
                        // Subtitle
                        Text("Purchase Details")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .opacity(1.0 - scrollProgress * 2)
                        
                        // Title
                        Text(merchant)
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
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            hideTabBar.wrappedValue = true
        }
        .onDisappear {
            hideTabBar.wrappedValue = false
        }
        .sheet(isPresented: $showNewPlanSheet) {
            NewPaymentPlanSheet(
                transactionAmount: amount,
                merchant: merchant,
                onPaymentPlanCreated: { paymentPlanName in
                    paymentPlansManager.addPaymentPlan(name: paymentPlanName, startingAmount: amount)
                    withAnimation {
                        selectedPaymentPlan = paymentPlanName
                    }
                }
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }
}

struct TransactionDetailsCard: View {
    let merchant: String
    let amount: String
    let date: String
    let time: String
    
    var body: some View {
        VStack(spacing: 16) {
            // Amount
            VStack(spacing: 8) {
                Text(amount)
                    .font(.system(size: 48, weight: .bold))
                
                HStack(spacing: 8) {
                    Image(systemName: "heart.fill")
                        .font(.caption)
                        .foregroundColor(.blue)
                    Text("Paid with Resurs Family")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Divider()
            
            // Details
            VStack(spacing: 12) {
                DetailRow(label: "Merchant", value: merchant)
                DetailRow(label: "Date", value: date)
                DetailRow(label: "Time", value: time)
                DetailRow(label: "Status", value: "Completed")
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.medium)
        }
    }
}

struct PaymentPlansExplanationCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text("About Payment Plans")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            Text("Break out this purchase from your monthly bill and put it in a payment plan billed separately - always with the opportunity to part pay or pay in full when the invoice arrives.")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(20)
        .background(Color.blue.opacity(0.1))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ExistingPaymentPlanRow: View {
    let title: String
    let amount: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
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
                    .foregroundColor(.primary)
                Text("Current total: \(amount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "plus.circle")
                .font(.title3)
                .foregroundColor(.blue)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SelectedPaymentPlanCard: View {
    let title: String
    let amount: String
    let icon: String
    let color: Color
    let isNewPaymentPlan: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(isNewPaymentPlan ? "Payment Plan Created" : "Purchase Added")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(isNewPaymentPlan ? "Your new payment plan is ready" : "This purchase is now in your payment plan")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
            Divider()
            
            HStack {
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
                    Text(isNewPaymentPlan ? "Starting amount: \(amount)" : "New total: \(amount)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(Color.green.opacity(0.1))
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct NewPaymentPlanSheet: View {
    @Environment(\.dismiss) var dismiss
    let transactionAmount: String
    let merchant: String
    let onPaymentPlanCreated: (String) -> Void
    @State private var paymentPlanName: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Create New Payment Plan")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("This purchase will be added to the new payment plan")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Payment Plan Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("e.g., Home Renovation", text: $paymentPlanName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Starting with")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text(merchant)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Spacer()
                        Text(transactionAmount)
                            .font(.subheadline)
                            .fontWeight(.bold)
                    }
                    .padding(16)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    if !paymentPlanName.isEmpty {
                        onPaymentPlanCreated(paymentPlanName)
                        dismiss()
                    }
                }) {
                    Text("Create Payment Plan")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(paymentPlanName.isEmpty ? Color.gray : Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(paymentPlanName.isEmpty)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview {
    TransactionDetailView(
        merchant: "IKEA",
        amount: "23 000 SEK",
        date: "Nov 2, 2025",
        time: "5:15 PM"
    )
    .environmentObject(PaymentPlansManager())
    .preferredColorScheme(.dark)
}

