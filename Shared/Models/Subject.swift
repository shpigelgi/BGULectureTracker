//
//  Subject.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import Foundation
import SwiftUI

struct Subject: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var colorHex: String

    init(id: UUID = UUID(), name: String, colorHex: String = "#007AFF") {
        self.id = id
        self.name = name
        self.colorHex = colorHex
    }

    var color: Color {
        Color(hex: colorHex) ?? .blue
    }
}
