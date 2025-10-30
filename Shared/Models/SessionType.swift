//
//  SessionType.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import Foundation

enum SessionType: String, Codable, CaseIterable {
    case lecture = "Lecture"
    case practice = "Practice"

    var icon: String {
        switch self {
        case .lecture:
            return "book.fill"
        case .practice:
            return "pencil.and.list.clipboard"
        }
    }
}
