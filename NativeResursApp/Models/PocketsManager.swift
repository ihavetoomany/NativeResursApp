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
    let monthlyAmount: String?
    let icon: String
    let color: Color
}

class PocketsManager: ObservableObject {
    @Published var pockets: [Pocket] = [
        Pocket(
            name: "Unbilled Purchases",
            totalAmount: "56 005 SEK",
            paidAmount: "8 945 SEK",
            progress: 0.16,
            dueDate: "Current billing period",
            monthlyAmount: nil,
            icon: "creditcard.fill",
            color: .blue
        ),
        Pocket(
            name: "Home Office Setup",
            totalAmount: "18 200 SEK",
            paidAmount: "6 000 SEK",
            progress: 0.33,
            dueDate: "Paid off in 6 months",
            monthlyAmount: "2 000 SEK/month",
            icon: "doc.text.fill",
            color: .purple
        ),
        Pocket(
            name: "New Kitchen Appliances",
            totalAmount: "28 500 SEK",
            paidAmount: "25 650 SEK",
            progress: 0.9,
            dueDate: "1 payment left",
            monthlyAmount: "2 850 SEK/month",
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
            monthlyAmount: nil,
            icon: "tray.fill",
            color: .blue
        )
        pockets.insert(newPocket, at: pockets.count - 1) // Insert before the last (paid off) pocket
    }
}

