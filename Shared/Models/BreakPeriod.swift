//
//  BreakPeriod.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import Foundation

struct BreakPeriod: Codable, Identifiable, Equatable {
    let id: UUID
    var name: String
    var startDate: Date
    var endDate: Date

    init(
        id: UUID = UUID(),
        name: String,
        startDate: Date,
        endDate: Date
    ) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
    }

    func contains(_ date: Date) -> Bool {
        return date >= startDate && date <= endDate
    }
}
