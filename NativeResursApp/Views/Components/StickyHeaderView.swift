//
//  StickyHeaderView.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-10-04.
//

import SwiftUI
import Combine

// Helper to track scroll offset
class ScrollOffsetObserver: ObservableObject {
    @Published var offset: CGFloat = 0
}

struct StickyHeaderView<Content: View, StickyContent: View>: View {
    let title: String
    let subtitle: String
    let trailingButton: String
    let content: Content
    let stickyContent: StickyContent?
    @StateObject private var scrollObserver = ScrollOffsetObserver()
    
    init(title: String, subtitle: String, trailingButton: String = "person.circle.fill", @ViewBuilder content: () -> Content) where StickyContent == EmptyView {
        self.title = title
        self.subtitle = subtitle
        self.trailingButton = trailingButton
        self.content = content()
        self.stickyContent = nil
    }
    
    init(title: String, subtitle: String, trailingButton: String = "person.circle.fill", @ViewBuilder stickyContent: () -> StickyContent, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.trailingButton = trailingButton
        self.stickyContent = stickyContent()
        self.content = content()
    }
    
    var body: some View {
        let scrollProgress = min(scrollObserver.offset / 100, 1.0) // Normalize scroll progress
        
        ZStack(alignment: .top) {
            // Scrollable Content
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Tracking element
                    GeometryReader { geometry in
                        Color.clear
                            .onChange(of: geometry.frame(in: .named("scroll")).minY) { oldValue, newValue in
                                scrollObserver.offset = max(0, -newValue)
                            }
                    }
                    .frame(height: 0)
                    
                    // Account for header + sticky section if present
                    Color.clear.frame(height: stickyContent != nil ? 160 : 90)
                    
                    VStack(spacing: 20) {
                        content
                    }
                }
                .padding(.vertical)
            }
            .coordinateSpace(name: "scroll")
            
            // Sticky Header (overlays the content)
            VStack(alignment: .leading, spacing: 0) {
                // Header content
                VStack(alignment: scrollProgress > 0.5 ? .center : .leading, spacing: 12) {
                    HStack {
                        // Spacer for centering when scrolled
                        if scrollProgress > 0.5 {
                            Spacer()
                        }
                        
                        VStack(alignment: scrollProgress > 0.5 ? .center : .leading, spacing: 4) {
                            // Subtitle - fades out
                            Text(subtitle)
                                .foregroundColor(.secondary)
                                .opacity(1.0 - scrollProgress)
                                .frame(height: scrollProgress > 0.5 ? 0 : nil)
                                .clipped()
                            
                            // Title - shrinks and centers
                            Text(title)
                                .font(scrollProgress > 0.5 ? .title2 : .largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.primary)
                        }
                        
                        // Icon - fades out
                        if scrollProgress < 0.5 {
                            Spacer()
                            
                            Button(action: {}) {
                                Image(systemName: trailingButton)
                                    .font(.largeTitle)
                                    .foregroundColor(Color(UIColor.systemCyan))
                                    .opacity(1.0 - scrollProgress * 2)
                            }
                        } else {
                            Spacer()
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 20 - (scrollProgress * 10)) // Shrink vertical padding
                
                // Optional sticky content section (pills, etc)
                if let stickyContent = stickyContent {
                    AnyView(stickyContent)
                }
            }
            .background(Color.cyan.opacity(0.2))
            .background(.ultraThinMaterial)
            .animation(.easeInOut(duration: 0.2), value: scrollProgress)
        }
    }
}

#Preview {
    StickyHeaderView(title: "Preview", subtitle: "Testing sticky header") {
        VStack(spacing: 20) {
            ForEach(0..<20) { index in
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)
                    .frame(height: 100)
                    .overlay(
                        Text("Content Item \(index + 1)")
                            .font(.headline)
                    )
            }
        }
        .padding(.horizontal)
    }
    .preferredColorScheme(.dark)
}