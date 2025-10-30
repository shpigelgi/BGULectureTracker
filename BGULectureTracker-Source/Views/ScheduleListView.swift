//
//  ScheduleListView.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import SwiftUI

struct ScheduleListView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showingAddSheet = false

    var body: some View {
        VStack {
            if dataManager.schedules.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "calendar.badge.clock")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No schedules yet")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    if dataManager.subjects.isEmpty {
                        Text("Add subjects first")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Button("Add Your First Schedule") {
                            showingAddSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            } else {
                List {
                    ForEach(dataManager.schedules) { schedule in
                        ScheduleRow(schedule: schedule)
                    }
                    .onDelete(perform: deleteSchedules)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSheet = true
                } label: {
                    Label("Add Schedule", systemImage: "plus")
                }
                .disabled(dataManager.subjects.isEmpty)
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddScheduleView(isPresented: $showingAddSheet)
        }
    }

    private func deleteSchedules(at offsets: IndexSet) {
        for index in offsets {
            let schedule = dataManager.schedules[index]
            dataManager.deleteSchedule(schedule)
        }
    }
}

struct ScheduleRow: View {
    let schedule: LectureSchedule
    @ObservedObject private var dataManager = DataManager.shared

    var body: some View {
        HStack {
            Image(systemName: schedule.sessionType.icon)
                .foregroundColor(.accentColor)

            VStack(alignment: .leading) {
                if let subject = dataManager.getSubject(by: schedule.subjectId) {
                    Text(subject.name)
                        .font(.headline)
                }
                Text("\(schedule.dayName) at \(schedule.timeString)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(schedule.sessionType.rawValue)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct AddScheduleView: View {
    @Binding var isPresented: Bool
    @ObservedObject private var dataManager = DataManager.shared

    @State private var selectedSubject: Subject?
    @State private var sessionType: SessionType = .lecture
    @State private var dayOfWeek: Int = 2 // Monday
    @State private var time: Date = Date()
    @State private var startDate: Date = Date()

    let weekdays = [
        (1, "Sunday"),
        (2, "Monday"),
        (3, "Tuesday"),
        (4, "Wednesday"),
        (5, "Thursday"),
        (6, "Friday"),
        (7, "Saturday")
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Schedule")
                .font(.title2)

            Form {
                Picker("Subject", selection: $selectedSubject) {
                    Text("Select subject").tag(nil as Subject?)
                    ForEach(dataManager.subjects) { subject in
                        Text(subject.name).tag(subject as Subject?)
                    }
                }

                Picker("Type", selection: $sessionType) {
                    ForEach(SessionType.allCases, id: \.self) { type in
                        Label(type.rawValue, systemImage: type.icon).tag(type)
                    }
                }

                Picker("Day of Week", selection: $dayOfWeek) {
                    ForEach(weekdays, id: \.0) { day in
                        Text(day.1).tag(day.0)
                    }
                }

                DatePicker("Time", selection: $time, displayedComponents: .hourAndMinute)

                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
            }
            .formStyle(.grouped)

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Add") {
                    saveSchedule()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(selectedSubject == nil)
            }
        }
        .padding(30)
        .frame(width: 450)
        .onAppear {
            selectedSubject = dataManager.subjects.first
        }
    }

    private func saveSchedule() {
        guard let subject = selectedSubject else { return }

        let newSchedule = LectureSchedule(
            subjectId: subject.id,
            sessionType: sessionType,
            dayOfWeek: dayOfWeek,
            timeOfDay: time,
            startDate: Calendar.current.startOfDay(for: startDate)
        )

        dataManager.addSchedule(newSchedule)
        isPresented = false
    }
}
