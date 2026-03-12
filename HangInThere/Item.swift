//
//  Item.swift
//  HangInThere
//
//  Created by Rafael Plinio on 12/03/26.
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
