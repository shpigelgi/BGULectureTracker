//
//  LectureWidget.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), progressList: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), progressList: getProgressData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let refreshDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!

        let entry = SimpleEntry(date: currentDate, progressList: getProgressData())
        let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
        completion(timeline)
    }

    private func getProgressData() -> [SubjectProgress] {
        let dataManager = DataManager.shared
        dataManager.loadAll()

        return ProgressCalculator.shared.calculateAllProgress(
            subjects: dataManager.subjects,
            schedules: dataManager.schedules,
            watchProgress: dataManager.watchProgress,
            breakPeriods: dataManager.breakPeriods
        )
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let progressList: [SubjectProgress]
}

@main
struct LectureWidget: Widget {
    let kind: String = "LectureWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LectureWidgetView(entry: entry)
        }
        .configurationDisplayName("Lecture Tracker")
        .description("Track your BGU lectures and practices")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
