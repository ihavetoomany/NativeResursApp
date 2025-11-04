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
    @EnvironmentObject var pocketsManager: PocketsManager
    @StateObject private var scrollObserver = ScrollOffsetObserver()
    @State private var showNewPlanSheet = false
    @State private var selectedPocket: String? = nil
    
    let merchant: String
    let amount: String
    let date: String
    let time: String
    
    var body: some View {
        let scrollProgress = min(scrollObserver.offset / 100, 1.0)
        
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                // Scrollable Content
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
                        
                        // Pockets Explanation Section
                        PocketsExplanationCard()
                            .padding(.horizontal)
                            .frame(width: geometry.size.width)
                        
                        // Add to Pocket Section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(selectedPocket == nil ? "Add to Pocket" : "Added to Pocket")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .padding(.horizontal)
                                .padding(.top, 16)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            if let pocket = selectedPocket {
                                // Selected Pocket State
                                VStack(spacing: 16) {
                                    SelectedPocketCard(
                                        title: pocket,
                                        amount: amount,
                                        icon: pocketsManager.pockets.first(where: { $0.name == pocket })?.icon ?? "tray.fill",
                                        color: pocketsManager.pockets.first(where: { $0.name == pocket })?.color ?? .cyan,
                                        isNewPocket: pocketsManager.pockets.first(where: { $0.name == pocket })?.dueDate == "Just created"
                                    )
                                    
                                    Button(action: {
                                        withAnimation {
                                            selectedPocket = nil
                                        }
                                    }) {
                                        Text("Remove from Pocket")
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
                                // Default State - Select Pocket
                                VStack(spacing: 12) {
                                    // Existing Pockets (excluding paid off and unbilled)
                                    ForEach(pocketsManager.pockets.filter { 
                                        $0.progress < 1.0 && $0.name != "Unbilled - November" 
                                    }) { pocket in
                                        Button(action: {
                                            withAnimation {
                                                selectedPocket = pocket.name
                                            }
                                        }) {
                                            ExistingPocketRow(
                                                title: pocket.name,
                                                amount: pocket.totalAmount,
                                                icon: pocket.icon,
                                                color: pocket.color
                                            )
                                        }
                                    }
                                    
                                    // Create New Pocket Button
                                    Button(action: {
                                        showNewPlanSheet = true
                                    }) {
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title3)
                                                .foregroundColor(.cyan)
                                                .frame(width: 36, height: 36)
                                            
                                            VStack(alignment: .leading, spacing: 4) {
                                                Text("Create New Pocket")
                                                    .font(.subheadline)
                                                    .fontWeight(.medium)
                                                    .foregroundColor(.primary)
                                                Text("Start a new payment pocket")
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
                    .padding(.vertical, 20)
                    .frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width)
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
                                .foregroundColor(.cyan)
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
        .sheet(isPresented: $showNewPlanSheet) {
            NewPocketSheet(
                transactionAmount: amount,
                merchant: merchant,
                onPocketCreated: { pocketName in
                    pocketsManager.addPocket(name: pocketName, startingAmount: amount)
                    withAnimation {
                        selectedPocket = pocketName
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
                        .foregroundColor(.cyan)
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

struct PocketsExplanationCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "info.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text("About Pockets")
                    .font(.headline)
                    .fontWeight(.semibold)
            }
            
            Text("Break out this purchase from your monthly bill and put it in a pocket billed separately - always with the opportunity to part pay or pay in full when the invoice arrives.")
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

struct ExistingPocketRow: View {
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
                .foregroundColor(.cyan)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct SelectedPocketCard: View {
    let title: String
    let amount: String
    let icon: String
    let color: Color
    let isNewPocket: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(isNewPocket ? "Pocket Created" : "Purchase Added")
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(isNewPocket ? "Your new pocket is ready" : "This purchase is now in your pocket")
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
                    Text(isNewPocket ? "Starting amount: \(amount)" : "New total: \(amount)")
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

struct NewPocketSheet: View {
    @Environment(\.dismiss) var dismiss
    let transactionAmount: String
    let merchant: String
    let onPocketCreated: (String) -> Void
    @State private var pocketName: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Text("Create New Pocket")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("This purchase will be added to the new pocket")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pocket Name")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    TextField("e.g., Home Renovation", text: $pocketName)
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
                    if !pocketName.isEmpty {
                        onPocketCreated(pocketName)
                        dismiss()
                    }
                }) {
                    Text("Create Pocket")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(pocketName.isEmpty ? Color.gray : Color.cyan)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(pocketName.isEmpty)
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
    .environmentObject(PocketsManager())
    .preferredColorScheme(.dark)
}

