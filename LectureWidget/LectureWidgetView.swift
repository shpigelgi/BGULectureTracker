//
//  LectureWidgetView.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import SwiftUI
import WidgetKit

struct LectureWidgetView: View {
    @Environment(\.widgetFamily) var family
    let entry: Provider.Entry

    var body: some View {
        switch family {
        case .systemSmall:
            SmallWidgetView(progressList: entry.progressList)
        case .systemMedium:
            MediumWidgetView(progressList: entry.progressList)
        case .systemLarge:
            LargeWidgetView(progressList: entry.progressList)
        default:
            SmallWidgetView(progressList: entry.progressList)
        }
    }
}

// MARK: - Small Widget

struct SmallWidgetView: View {
    let progressList: [SubjectProgress]

    var body: some View {
        if let mostBehind = progressList.max(by: { $0.totalBehind < $1.totalBehind }) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(mostBehind.subject.color)
                        .frame(width: 10, height: 10)
                    Text(mostBehind.subject.name)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .lineLimit(1)
                }

                Spacer()

                VStack(alignment: .leading, spacing: 4) {
                    Text("\(mostBehind.totalBehind)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(mostBehind.isUpToDate ? .green : .red)

                    Text(mostBehind.isUpToDate ? "Up to date" : "behind")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                ProgressView(value: mostBehind.progressPercentage)
                    .tint(mostBehind.subject.color)
            }
            .padding()
        } else {
            VStack {
                Image(systemName: "tray")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                Text("No subjects")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

// MARK: - Medium Widget

struct MediumWidgetView: View {
    let progressList: [SubjectProgress]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "book.fill")
                    .foregroundColor(.accentColor)
                Text("Lecture Tracker")
                    .font(.headline)
                Spacer()
                let totalBehind = ProgressCalculator.shared.calculateTotalBehind(progressList: progressList)
                if totalBehind > 0 {
                    Text("\(totalBehind) behind")
                        .font(.caption)
                        .padding(4)
                        .background(Color.red.opacity(0.2))
                        .cornerRadius(4)
                }
            }

            if progressList.isEmpty {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "tray")
                            .font(.title)
                            .foregroundColor(.gray)
                        Text("No subjects")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                }
                Spacer()
            } else {
                ForEach(progressList.prefix(3), id: \.subject.id) { progress in
                    CompactProgressRow(progress: progress)
                }
            }
        }
        .padding()
    }
}

// MARK: - Large Widget

struct LargeWidgetView: View {
    let progressList: [SubjectProgress]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: "graduationcap.fill")
                    .foregroundColor(.accentColor)
                Text("BGU Lecture Tracker")
                    .font(.headline)
                Spacer()
            }

            Divider()

            if progressList.isEmpty {
                Spacer()
                VStack {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("No subjects yet")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(progressList, id: \.subject.id) { progress in
                            DetailedProgressRow(progress: progress)
                            if progress.subject.id != progressList.last?.subject.id {
                                Divider()
                            }
                        }
                    }
                }

                Divider()

                HStack {
                    Text("Total:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Spacer()
                    let totalBehind = ProgressCalculator.shared.calculateTotalBehind(progressList: progressList)
                    if totalBehind == 0 {
                        Text("All caught up!")
                            .font(.caption)
                            .foregroundColor(.green)
                    } else {
                        Text("\(totalBehind) sessions behind")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding()
    }
}

// MARK: - Helper Views

struct CompactProgressRow: View {
    let progress: SubjectProgress

    var body: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(progress.subject.color)
                .frame(width: 8, height: 8)

            Text(progress.subject.name)
                .font(.caption)
                .lineLimit(1)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("\(progress.totalWatched)/\(progress.totalExpected)")
                    .font(.caption2)
                    .fontWeight(.medium)

                if !progress.isUpToDate {
                    Text("\(progress.totalBehind) behind")
                        .font(.system(size: 9))
                        .foregroundColor(.red)
                }
            }
        }
    }
}

struct DetailedProgressRow: View {
    let progress: SubjectProgress

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Circle()
                    .fill(progress.subject.color)
                    .frame(width: 10, height: 10)
                Text(progress.subject.name)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                Spacer()
                if progress.isUpToDate {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.caption)
                }
            }

            HStack(spacing: 12) {
                Label("\(progress.watchedLectures)/\(progress.expectedLectures)", systemImage: "book.fill")
                    .font(.caption2)
                Label("\(progress.watchedPractices)/\(progress.expectedPractices)", systemImage: "pencil")
                    .font(.caption2)
            }
            .foregroundColor(.secondary)

            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 4)

                    Rectangle()
                        .fill(progress.subject.color)
                        .frame(width: geometry.size.width * CGFloat(progress.progressPercentage), height: 4)
                }
            }
            .frame(height: 4)

            if !progress.isUpToDate {
                Text("\(progress.totalBehind) behind")
                    .font(.caption2)
                    .foregroundColor(.red)
            }
        }
    }
}
