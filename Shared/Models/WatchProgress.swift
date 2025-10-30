//
//  WatchProgress.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import Foundation

struct WatchProgress: Codable, Equatable {
    var subjectId: UUID
    var lecturesWatched: Int
    var practicesWatched: Int

    init(subjectId: UUID, lecturesWatched: Int = 0, practicesWatched: Int = 0) {
        self.subjectId = subjectId
        self.lecturesWatched = lecturesWatched
        self.practicesWatched = practicesWatched
    }

    func watched(for type: SessionType) -> Int {
        switch type {
        case .lecture:
            return lecturesWatched
        case .practice:
            return practicesWatched
        }
    }

    mutating func incrementWatched(for type: SessionType) {
        switch type {
        case .lecture:
            lecturesWatched += 1
        case .practice:
            practicesWatched += 1
        }
    }
}
