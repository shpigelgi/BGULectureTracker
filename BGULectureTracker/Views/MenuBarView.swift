//
//  MenuBarView.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import SwiftUI

struct MenuBarView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var progressList: [SubjectProgress] = []

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "book.fill")
                Text("Lecture Tracker")
                    .font(.headline)
                Spacer()
            }
            .padding()
            .background(Color.accentColor.opacity(0.1))

            // Subjects list
            ScrollView {
                if progressList.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "tray")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No subjects yet")
                            .foregroundColor(.secondary)
                        Text("Add subjects in Settings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(40)
                } else {
                    VStack(alignment: .leading, spacing: 12) {
                        ForEach(progressList, id: \.subject.id) { progress in
                            SubjectProgressRow(progress: progress)
                        }
                    }
                    .padding()
                }
            }

            Divider()

            // Footer
            VStack(spacing: 8) {
                if !progressList.isEmpty {
                    HStack {
                        Text("Total:")
                            .font(.headline)
                        Spacer()
                        let totalBehind = ProgressCalculator.shared.calculateTotalBehind(progressList: progressList)
                        if totalBehind == 0 {
                            Text("All caught up! ")
                                .foregroundColor(.green) +
                            Text("")
                        } else {
                            Text("\(totalBehind) behind")
                                .foregroundColor(.red)
                        }
                    }
                    .padding(.horizontal)
                }

                HStack {
                    Button("Settings") {
                        openSettings()
                    }
                    Spacer()
                    Button("Refresh") {
                        refreshData()
                    }
                    Spacer()
                    Button("Quit") {
                        NSApplication.shared.terminate(nil)
                    }
                }
                .buttonStyle(.link)
                .padding(.horizontal)
            }
            .padding(.vertical, 8)
        }
        .frame(width: 350, height: 400)
        .onAppear {
            refreshData()
        }
    }

    private func refreshData() {
        dataManager.loadAll()
        progressList = ProgressCalculator.shared.calculateAllProgress(
            subjects: dataManager.subjects,
            schedules: dataManager.schedules,
            watchProgress: dataManager.watchProgress,
            breakPeriods: dataManager.breakPeriods
        )
    }

    private func openSettings() {
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.showSettings()
        }
    }
}

struct SubjectProgressRow: View {
    let progress: SubjectProgress
    @ObservedObject private var dataManager = DataManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Circle()
                    .fill(progress.subject.color)
                    .frame(width: 12, height: 12)
                Text(progress.subject.name)
                    .font(.headline)
                Spacer()
                if progress.isUpToDate {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Text("\(progress.totalBehind) behind")
                        .font(.caption)
                        .foregroundColor(.red)
                }
            }

            // Progress details
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Image(systemName: "book.fill")
                            .font(.caption2)
                        Text("Lectures: \(progress.watchedLectures)/\(progress.expectedLectures)")
                            .font(.caption)
                    }
                    HStack {
                        Image(systemName: "pencil.and.list.clipboard")
                            .font(.caption2)
                        Text("Practices: \(progress.watchedPractices)/\(progress.expectedPractices)")
                            .font(.caption)
                    }
                }
                Spacer()
            }
            .foregroundColor(.secondary)

            // Progress bar
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

            // Action buttons
            HStack(spacing: 8) {
                Button {
                    markWatched(type: .lecture)
                } label: {
                    Label("Watched Lecture", systemImage: "book.fill")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button {
                    markWatched(type: .practice)
                } label: {
                    Label("Watched Practice", systemImage: "pencil")
                        .font(.caption)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color(NSColor.controlBackgroundColor))
        .cornerRadius(8)
    }

    private func markWatched(type: SessionType) {
        dataManager.incrementWatched(for: progress.subject.id, type: type)
        if let appDelegate = NSApplication.shared.delegate as? AppDelegate {
            appDelegate.updateStatusBadge()
        }
    }
}
