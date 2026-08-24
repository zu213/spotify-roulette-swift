//
//  Item.swift
//  Spotify Roulette
//
//  Created by Zachary Upstone on 24/08/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
