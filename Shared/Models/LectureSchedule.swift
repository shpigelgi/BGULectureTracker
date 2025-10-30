//
//  LectureSchedule.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import Foundation

struct LectureSchedule: Codable, Identifiable, Equatable {
    let id: UUID
    var subjectId: UUID
    var sessionType: SessionType
    var dayOfWeek: Int // 1 = Sunday, 2 = Monday, ..., 7 = Saturday
    var timeOfDay: Date // Only time component is used
    var startDate: Date // When this course started

    init(
        id: UUID = UUID(),
        subjectId: UUID,
        sessionType: SessionType,
        dayOfWeek: Int,
        timeOfDay: Date,
        startDate: Date
    ) {
        self.id = id
        self.subjectId = subjectId
        self.sessionType = sessionType
        self.dayOfWeek = dayOfWeek
        self.timeOfDay = timeOfDay
        self.startDate = startDate
    }

    var dayName: String {
        let days = ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return days[dayOfWeek]
    }

    var timeString: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timeOfDay)
    }
}
