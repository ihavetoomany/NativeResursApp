//
//  ResursFamilyAccountView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-11-02.
//

import SwiftUI

struct ResursFamilyAccountView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            StickyHeaderView(title: "Resurs Family", subtitle: "Joint Credit Account", trailingButton: "gearshape.fill") {
                VStack(spacing: 16) {
                    // Account Overview Card
                    AccountOverviewCard()
                        .padding(.horizontal)
                        .padding(.top, 24)
                        .padding(.bottom, 16)
                    
                    // Credit Cards Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Cards")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            CreditCardMini(
                                holder: "Your Card",
                                lastFour: "1234",
                                limit: "42 160 SEK"
                            )
                            
                            CreditCardMini(
                                holder: "Partner's Card",
                                lastFour: "5678",
                                limit: "42 160 SEK"
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                    
                    // Plans Section
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Active Plans")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Button(action: {}) {
                                HStack(spacing: 4) {
                                    Image(systemName: "plus.circle.fill")
                                    Text("New Plan")
                                }
                                .font(.subheadline)
                                .foregroundColor(.cyan)
                            }
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            PlanCard(
                                title: "Summer Vacation 2025",
                                totalAmount: "45 000 SEK",
                                paidAmount: "12 000 SEK",
                                progress: 0.27,
                                dueDate: "Paid off in 3 months",
                                icon: "airplane.departure",
                                color: .blue
                            )
                            
                            PlanCard(
                                title: "New Kitchen Appliances",
                                totalAmount: "28 500 SEK",
                                paidAmount: "28 500 SEK",
                                progress: 1.0,
                                dueDate: "Paid off",
                                icon: "house.fill",
                                color: .green
                            )
                            
                            PlanCard(
                                title: "Home Office Setup",
                                totalAmount: "18 200 SEK",
                                paidAmount: "6 000 SEK",
                                progress: 0.33,
                                dueDate: "Paid off in 6 months",
                                icon: "desktopcomputer",
                                color: .purple
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

struct AccountOverviewCard: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Shared Credit Limit")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("84 321 SEK")
                        .font(.system(size: 32, weight: .bold))
                }
                
                Spacer()
                
                Image(systemName: "heart.fill")
                    .font(.title)
                    .foregroundColor(.blue)
                    .frame(width: 56, height: 56)
                    .background(Color.blue.opacity(0.2))
                    .clipShape(Circle())
            }
            
            Divider()
            
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Available")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("42 160 SEK")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Divider()
                    .frame(height: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("In Plans")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("42 161 SEK")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct CreditCardMini: View {
    let holder: String
    let lastFour: String
    let limit: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "creditcard.fill")
                .font(.title3)
                .foregroundColor(.cyan)
                .frame(width: 36, height: 36)
                .background(Color.cyan.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(holder)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("•••• \(lastFour)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(limit)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text("Limit")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct PlanCard: View {
    let title: String
    let totalAmount: String
    let paidAmount: String
    let progress: Double
    let dueDate: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 40, height: 40)
                    .background(color.opacity(0.2))
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Text(dueDate)
                        .font(.caption)
                        .foregroundColor(progress == 1.0 ? .green : .secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            // Progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(paidAmount)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(totalAmount)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.secondary.opacity(0.2))
                            .frame(height: 8)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(progress == 1.0 ? Color.green : color)
                            .frame(width: geometry.size.width * progress, height: 8)
                    }
                }
                .frame(height: 8)
            }
        }
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    ResursFamilyAccountView()
        .preferredColorScheme(.dark)
}

