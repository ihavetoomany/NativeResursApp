//
//  ChatView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

struct ChatView: View {
    @State private var navigationPath = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            StickyHeaderView(title: "Chat", subtitle: "Get help anytime", trailingButton: "person.circle.fill") {
                VStack(spacing: 16) {
                    // Quick Help Options
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick Help")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            HelpOptionCard(
                                title: "Account Issues",
                                subtitle: "Resolve account problems",
                                icon: "person.circle.fill",
                                color: .blue
                            )
                            
                            HelpOptionCard(
                                title: "Transaction Help",
                                subtitle: "Questions about payments",
                                icon: "creditcard.fill",
                                color: .green
                            )
                            
                            HelpOptionCard(
                                title: "Tech Support",
                                subtitle: "App and website issues",
                                icon: "wrench.and.screwdriver.fill",
                                color: .orange
                            )
                            
                            HelpOptionCard(
                                title: "Financial Advice",
                                subtitle: "Investment guidance",
                                icon: "chart.line.uptrend.xyaxis",
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    // Recent Conversations
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Recent Conversations")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Button("Clear All") {
                                // Clear all conversations
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ConversationRow(
                                title: "Sarah - Customer Support",
                                lastMessage: "Your account has been updated successfully",
                                time: "2 min ago",
                                unread: true
                            )
                            
                            ConversationRow(
                                title: "Mike - Financial Advisor",
                                lastMessage: "I've reviewed your investment portfolio",
                                time: "1 hour ago",
                                unread: false
                            )
                            
                            ConversationRow(
                                title: "Support Bot",
                                lastMessage: "How can I help you today?",
                                time: "Yesterday",
                                unread: false
                            )
                            
                            ConversationRow(
                                title: "Emma - Account Manager",
                                lastMessage: "Thank you for your payment",
                                time: "2 days ago",
                                unread: false
                            )
                            
                            ConversationRow(
                                title: "Tech Support",
                                lastMessage: "Your issue has been resolved",
                                time: "3 days ago",
                                unread: false
                            )
                            
                            ConversationRow(
                                title: "Lisa - Customer Service",
                                lastMessage: "We've processed your refund",
                                time: "1 week ago",
                                unread: false
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                    
                    // Contact Methods
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Other Ways to Connect")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            ContactMethodRow(
                                title: "Phone Support",
                                subtitle: "Available 24/7",
                                icon: "phone.fill",
                                color: .green
                            )
                            
                            ContactMethodRow(
                                title: "Email Support",
                                subtitle: "Response within 24 hours",
                                icon: "envelope.fill",
                                color: .blue
                            )
                            
                            ContactMethodRow(
                                title: "Video Call",
                                subtitle: "Schedule a consultation",
                                icon: "video.fill",
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
            .onReceive(NotificationCenter.default.publisher(for: .scrollToTop)) { _ in
                // If not at root level, pop to root
                if !navigationPath.isEmpty {
                    navigationPath.removeLast(navigationPath.count)
                }
                // If at root, the StickyHeaderView will handle scrolling to top
            }
        }
    }
}

struct HelpOptionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ConversationRow: View {
    let title: String
    let lastMessage: String
    let time: String
    let unread: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                        .fill(unread ? .blue : .secondary.opacity(0.3))
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Text(lastMessage)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(time)
                    .font(.caption)
                    .foregroundColor(.secondary)
                if unread {
                    Circle()
                        .fill(.blue)
                        .frame(width: 8, height: 8)
                }
            }
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

struct ContactMethodRow: View {
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

#Preview {
    ChatView()
        .preferredColorScheme(.dark)
}
