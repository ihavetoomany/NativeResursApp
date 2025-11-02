//
//  ExploreView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            StickyHeaderView(title: "Explore", subtitle: "Discover more", trailingButton: "person.circle.fill") {
                VStack(spacing: 16) {
                    // Featured Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Featured")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                FeaturedCard(
                                    title: "Investment Opportunities",
                                    subtitle: "Grow your wealth with smart investments",
                                    icon: "chart.line.uptrend.xyaxis",
                                    color: .blue
                                )
                                
                                FeaturedCard(
                                    title: "Credit Cards",
                                    subtitle: "Earn rewards on every purchase",
                                    icon: "creditcard.fill",
                                    color: .purple
                                )
                                
                                FeaturedCard(
                                    title: "Loans & Mortgages",
                                    subtitle: "Get the best rates available",
                                    icon: "house.fill",
                                    color: .green
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 16)
                    
                    // Services Grid
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Services")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 16) {
                            ServiceCard(
                                title: "Mobile Banking",
                                subtitle: "Bank on the go",
                                icon: "iphone",
                                color: .blue
                            )
                            
                            ServiceCard(
                                title: "Bill Pay",
                                subtitle: "Pay bills easily",
                                icon: "doc.text.fill",
                                color: .orange
                            )
                            
                            ServiceCard(
                                title: "Transfer Money",
                                subtitle: "Send money instantly",
                                icon: "arrow.left.arrow.right",
                                color: .green
                            )
                            
                            ServiceCard(
                                title: "Financial Planning",
                                subtitle: "Plan your future",
                                icon: "chart.bar.fill",
                                color: .purple
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 16)
                    
                    // News Section
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Financial News")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Spacer()
                            Button("See All") {
                                // Navigate to news
                            }
                            .font(.subheadline)
                                .foregroundColor(.cyan)
                        }
                        .padding(.horizontal)
                        
                        VStack(spacing: 12) {
                            NewsRow(
                                title: "Market Update: Tech Stocks Rise",
                                subtitle: "2 hours ago",
                                category: "Markets"
                            )
                            
                            NewsRow(
                                title: "New Banking Regulations Take Effect",
                                subtitle: "5 hours ago",
                                category: "Regulation"
                            )
                            
                            NewsRow(
                                title: "Investment Tips for Beginners",
                                subtitle: "1 day ago",
                                category: "Education"
                            )
                            
                            NewsRow(
                                title: "Interest Rates Expected to Change",
                                subtitle: "2 days ago",
                                category: "Economy"
                            )
                            
                            NewsRow(
                                title: "Cryptocurrency Trends in 2025",
                                subtitle: "3 days ago",
                                category: "Crypto"
                            )
                            
                            NewsRow(
                                title: "How to Build Your Emergency Fund",
                                subtitle: "4 days ago",
                                category: "Savings"
                            )
                            
                            NewsRow(
                                title: "Real Estate Market Analysis",
                                subtitle: "1 week ago",
                                category: "Property"
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

struct FeaturedCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: icon)
                    .font(.title)
                    .foregroundColor(color)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(20)
        .frame(width: 200, height: 140)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ServiceCard: View {
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

struct NewsRow: View {
    let title: String
    let subtitle: String
    let category: String
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(category.uppercased())
                    .font(.caption)
                    .fontWeight(.semibold)
                                .foregroundColor(.cyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.cyan.opacity(0.2))
                    .clipShape(Capsule())
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.leading)
                
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
    ExploreView()
        .preferredColorScheme(.dark)
}
