//
//  BreakPeriodsView.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import SwiftUI

struct BreakPeriodsView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showingAddSheet = false

    var body: some View {
        VStack {
            if dataManager.breakPeriods.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "beach.umbrella")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No break periods")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Text("Add holidays, exam periods, or other breaks")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Button("Add Break Period") {
                        showingAddSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                List {
                    ForEach(dataManager.breakPeriods) { period in
                        BreakPeriodRow(period: period)
                    }
                    .onDelete(perform: deleteBreakPeriods)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSheet = true
                } label: {
                    Label("Add Break", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddBreakPeriodView(isPresented: $showingAddSheet)
        }
    }

    private func deleteBreakPeriods(at offsets: IndexSet) {
        for index in offsets {
            let period = dataManager.breakPeriods[index]
            dataManager.deleteBreakPeriod(period)
        }
    }
}

struct BreakPeriodRow: View {
    let period: BreakPeriod

    var body: some View {
        HStack {
            Image(systemName: "calendar.badge.exclamationmark")
                .foregroundColor(.orange)

            VStack(alignment: .leading) {
                Text(period.name)
                    .font(.headline)
                Text("\(formatted(period.startDate)) - \(formatted(period.endDate))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }

    private func formatted(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct AddBreakPeriodView: View {
    @Binding var isPresented: Bool
    @ObservedObject private var dataManager = DataManager.shared

    @State private var name: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()

    var body: some View {
        VStack(spacing: 20) {
            Text("Add Break Period")
                .font(.title2)

            Form {
                TextField("Name (e.g., Passover Break)", text: $name)
                    .textFieldStyle(.roundedBorder)

                DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                DatePicker("End Date", selection: $endDate, displayedComponents: .date)
            }
            .formStyle(.grouped)

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button("Add") {
                    saveBreakPeriod()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty || endDate < startDate)
            }
        }
        .padding(30)
        .frame(width: 450)
    }

    private func saveBreakPeriod() {
        let newPeriod = BreakPeriod(
            name: name,
            startDate: Calendar.current.startOfDay(for: startDate),
            endDate: Calendar.current.startOfDay(for: endDate)
        )

        dataManager.addBreakPeriod(newPeriod)
        isPresented = false
    }
}
