//
//  SettingsView.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            SubjectListView()
                .tabItem {
                    Label("Subjects", systemImage: "book.fill")
                }
                .tag(0)

            ScheduleListView()
                .tabItem {
                    Label("Schedules", systemImage: "calendar")
                }
                .tag(1)

            BreakPeriodsView()
                .tabItem {
                    Label("Breaks", systemImage: "calendar.badge.exclamationmark")
                }
                .tag(2)

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
                .tag(3)
        }
        .frame(minWidth: 600, minHeight: 500)
    }
}

struct AboutView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "graduationcap.fill")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)

            Text("BGU Lecture Tracker")
                .font(.title)

            Text("Track your university lectures and practices")
                .foregroundColor(.secondary)

            Text("Version 1.0.0")
                .font(.caption)
                .foregroundColor(.secondary)

            Spacer()

            Text("Made with ❤️ for BGU students")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(40)
    }
}
