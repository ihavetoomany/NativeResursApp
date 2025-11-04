//
//  PocketsManager.swift
//  NativeResursApp
//
//  Created by Bjarne Werner on 2025-11-03.
//

import SwiftUI
import Combine

struct Pocket: Identifiable {
    let id = UUID()
    let name: String
    let totalAmount: String
    let paidAmount: String
    let progress: Double
    let dueDate: String
    let icon: String
    let color: Color
}

class PocketsManager: ObservableObject {
    @Published var pockets: [Pocket] = [
        Pocket(
            name: "Unbilled - November",
            totalAmount: "67 800 SEK",
            paidAmount: "8 945 SEK",
            progress: 0.132,
            dueDate: "Current billing period",
            icon: "creditcard.fill",
            color: .blue
        ),
        Pocket(
            name: "Home Office Setup",
            totalAmount: "18 200 SEK",
            paidAmount: "6 000 SEK",
            progress: 0.33,
            dueDate: "Paid off in 6 months",
            icon: "doc.text.fill",
            color: .purple
        ),
        Pocket(
            name: "New Kitchen Appliances",
            totalAmount: "28 500 SEK",
            paidAmount: "28 500 SEK",
            progress: 1.0,
            dueDate: "Paid off",
            icon: "doc.text.fill",
            color: .green
        )
    ]
    
    func addPocket(name: String, startingAmount: String) {
        let newPocket = Pocket(
            name: name,
            totalAmount: startingAmount,
            paidAmount: "0 SEK",
            progress: 0.0,
            dueDate: "Just created",
            icon: "tray.fill",
            color: .cyan
        )
        pockets.insert(newPocket, at: pockets.count - 1) // Insert before the last (paid off) pocket
    }
}

