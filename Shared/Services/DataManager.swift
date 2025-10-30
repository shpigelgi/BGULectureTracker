//
//  DataManager.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()

    @Published var subjects: [Subject] = []
    @Published var schedules: [LectureSchedule] = []
    @Published var breakPeriods: [BreakPeriod] = []
    @Published var watchProgress: [WatchProgress] = []

    private let userDefaults: UserDefaults

    private init() {
        // Use App Group for sharing data between app and widget
        if let sharedDefaults = UserDefaults(suiteName: Constants.appGroupIdentifier) {
            self.userDefaults = sharedDefaults
        } else {
            self.userDefaults = UserDefaults.standard
            print("Warning: Could not access app group, using standard UserDefaults")
        }

        loadAll()
    }

    // MARK: - Load Data

    func loadAll() {
        loadSubjects()
        loadSchedules()
        loadBreakPeriods()
        loadWatchProgress()
    }

    private func loadSubjects() {
        if let data = userDefaults.data(forKey: Constants.UserDefaultsKeys.subjects),
           let decoded = try? JSONDecoder().decode([Subject].self, from: data) {
            subjects = decoded
        }
    }

    private func loadSchedules() {
        if let data = userDefaults.data(forKey: Constants.UserDefaultsKeys.schedules),
           let decoded = try? JSONDecoder().decode([LectureSchedule].self, from: data) {
            schedules = decoded
        }
    }

    private func loadBreakPeriods() {
        if let data = userDefaults.data(forKey: Constants.UserDefaultsKeys.breakPeriods),
           let decoded = try? JSONDecoder().decode([BreakPeriod].self, from: data) {
            breakPeriods = decoded
        }
    }

    private func loadWatchProgress() {
        if let data = userDefaults.data(forKey: Constants.UserDefaultsKeys.watchProgress),
           let decoded = try? JSONDecoder().decode([WatchProgress].self, from: data) {
            watchProgress = decoded
        }
    }

    // MARK: - Save Data

    func saveSubjects() {
        if let encoded = try? JSONEncoder().encode(subjects) {
            userDefaults.set(encoded, forKey: Constants.UserDefaultsKeys.subjects)
        }
    }

    func saveSchedules() {
        if let encoded = try? JSONEncoder().encode(schedules) {
            userDefaults.set(encoded, forKey: Constants.UserDefaultsKeys.schedules)
        }
    }

    func saveBreakPeriods() {
        if let encoded = try? JSONEncoder().encode(breakPeriods) {
            userDefaults.set(encoded, forKey: Constants.UserDefaultsKeys.breakPeriods)
        }
    }

    func saveWatchProgress() {
        if let encoded = try? JSONEncoder().encode(watchProgress) {
            userDefaults.set(encoded, forKey: Constants.UserDefaultsKeys.watchProgress)
        }
    }

    // MARK: - Subject Operations

    func addSubject(_ subject: Subject) {
        subjects.append(subject)
        saveSubjects()

        // Initialize watch progress for new subject
        let progress = WatchProgress(subjectId: subject.id)
        watchProgress.append(progress)
        saveWatchProgress()
    }

    func updateSubject(_ subject: Subject) {
        if let index = subjects.firstIndex(where: { $0.id == subject.id }) {
            subjects[index] = subject
            saveSubjects()
        }
    }

    func deleteSubject(_ subject: Subject) {
        subjects.removeAll { $0.id == subject.id }
        schedules.removeAll { $0.subjectId == subject.id }
        watchProgress.removeAll { $0.subjectId == subject.id }

        saveSubjects()
        saveSchedules()
        saveWatchProgress()
    }

    // MARK: - Schedule Operations

    func addSchedule(_ schedule: LectureSchedule) {
        schedules.append(schedule)
        saveSchedules()
    }

    func updateSchedule(_ schedule: LectureSchedule) {
        if let index = schedules.firstIndex(where: { $0.id == schedule.id }) {
            schedules[index] = schedule
            saveSchedules()
        }
    }

    func deleteSchedule(_ schedule: LectureSchedule) {
        schedules.removeAll { $0.id == schedule.id }
        saveSchedules()
    }

    // MARK: - Break Period Operations

    func addBreakPeriod(_ period: BreakPeriod) {
        breakPeriods.append(period)
        saveBreakPeriods()
    }

    func updateBreakPeriod(_ period: BreakPeriod) {
        if let index = breakPeriods.firstIndex(where: { $0.id == period.id }) {
            breakPeriods[index] = period
            saveBreakPeriods()
        }
    }

    func deleteBreakPeriod(_ period: BreakPeriod) {
        breakPeriods.removeAll { $0.id == period.id }
        saveBreakPeriods()
    }

    // MARK: - Watch Progress Operations

    func getProgress(for subjectId: UUID) -> WatchProgress {
        if let progress = watchProgress.first(where: { $0.subjectId == subjectId }) {
            return progress
        }

        // Create if doesn't exist
        let newProgress = WatchProgress(subjectId: subjectId)
        watchProgress.append(newProgress)
        saveWatchProgress()
        return newProgress
    }

    func incrementWatched(for subjectId: UUID, type: SessionType) {
        if let index = watchProgress.firstIndex(where: { $0.subjectId == subjectId }) {
            watchProgress[index].incrementWatched(for: type)
            saveWatchProgress()
        }
    }

    // MARK: - Helper Methods

    func getSchedules(for subjectId: UUID) -> [LectureSchedule] {
        schedules.filter { $0.subjectId == subjectId }
    }

    func getSubject(by id: UUID) -> Subject? {
        subjects.first { $0.id == id }
    }
}
