//
//  ProgressCalculator.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import Foundation

struct SubjectProgress {
    let subject: Subject
    let expectedLectures: Int
    let expectedPractices: Int
    let watchedLectures: Int
    let watchedPractices: Int

    var totalExpected: Int { expectedLectures + expectedPractices }
    var totalWatched: Int { watchedLectures + watchedPractices }
    var totalBehind: Int { max(0, totalExpected - totalWatched) }

    var lecturesBehind: Int { max(0, expectedLectures - watchedLectures) }
    var practicesBehind: Int { max(0, expectedPractices - watchedPractices) }

    var progressPercentage: Double {
        guard totalExpected > 0 else { return 1.0 }
        return Double(totalWatched) / Double(totalExpected)
    }

    var isUpToDate: Bool { totalBehind == 0 }
}

class ProgressCalculator {
    static let shared = ProgressCalculator()

    private init() {}

    /// Calculate expected sessions for a subject
    func calculateExpectedSessions(
        for subjectId: UUID,
        sessionType: SessionType,
        schedules: [LectureSchedule],
        breakPeriods: [BreakPeriod]
    ) -> Int {
        let relevantSchedules = schedules.filter {
            $0.subjectId == subjectId && $0.sessionType == sessionType
        }

        var totalExpected = 0

        for schedule in relevantSchedules {
            totalExpected += countOccurrences(
                of: schedule,
                from: schedule.startDate,
                to: Date(),
                excluding: breakPeriods
            )
        }

        return totalExpected
    }

    /// Count how many times a schedule has occurred between two dates
    private func countOccurrences(
        of schedule: LectureSchedule,
        from startDate: Date,
        to endDate: Date,
        excluding breakPeriods: [BreakPeriod]
    ) -> Int {
        let calendar = Calendar.current
        var count = 0
        var currentDate = startDate.startOfDay()
        let end = endDate.startOfDay()

        while currentDate <= end {
            // Check if this date matches the schedule's day of week
            if currentDate.dayOfWeek() == schedule.dayOfWeek {
                // Check if this date is not in a break period
                let isInBreak = breakPeriods.contains { $0.contains(currentDate) }
                if !isInBreak {
                    count += 1
                }
            }

            // Move to next day
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }

        return count
    }

    /// Calculate complete progress for a subject
    func calculateProgress(
        for subject: Subject,
        schedules: [LectureSchedule],
        watchProgress: WatchProgress,
        breakPeriods: [BreakPeriod]
    ) -> SubjectProgress {
        let expectedLectures = calculateExpectedSessions(
            for: subject.id,
            sessionType: .lecture,
            schedules: schedules,
            breakPeriods: breakPeriods
        )

        let expectedPractices = calculateExpectedSessions(
            for: subject.id,
            sessionType: .practice,
            schedules: schedules,
            breakPeriods: breakPeriods
        )

        return SubjectProgress(
            subject: subject,
            expectedLectures: expectedLectures,
            expectedPractices: expectedPractices,
            watchedLectures: watchProgress.lecturesWatched,
            watchedPractices: watchProgress.practicesWatched
        )
    }

    /// Calculate progress for all subjects
    func calculateAllProgress(
        subjects: [Subject],
        schedules: [LectureSchedule],
        watchProgress: [WatchProgress],
        breakPeriods: [BreakPeriod]
    ) -> [SubjectProgress] {
        subjects.map { subject in
            let progress = watchProgress.first { $0.subjectId == subject.id }
                ?? WatchProgress(subjectId: subject.id)
            return calculateProgress(
                for: subject,
                schedules: schedules,
                watchProgress: progress,
                breakPeriods: breakPeriods
            )
        }
    }

    /// Get total lectures behind across all subjects
    func calculateTotalBehind(progressList: [SubjectProgress]) -> Int {
        progressList.reduce(0) { $0 + $1.totalBehind }
    }
}
