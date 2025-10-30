//
//  SubjectListView.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import SwiftUI

struct SubjectListView: View {
    @ObservedObject private var dataManager = DataManager.shared
    @State private var showingAddSheet = false
    @State private var editingSubject: Subject?

    var body: some View {
        VStack {
            if dataManager.subjects.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "tray")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No subjects yet")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Button("Add Your First Subject") {
                        showingAddSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            } else {
                List {
                    ForEach(dataManager.subjects) { subject in
                        HStack {
                            Circle()
                                .fill(subject.color)
                                .frame(width: 16, height: 16)
                            Text(subject.name)
                            Spacer()
                            Button {
                                editingSubject = subject
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .onDelete(perform: deleteSubjects)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showingAddSheet = true
                } label: {
                    Label("Add Subject", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddSubjectView(isPresented: $showingAddSheet)
        }
        .sheet(item: $editingSubject) { subject in
            AddSubjectView(isPresented: .constant(true), editingSubject: subject)
        }
    }

    private func deleteSubjects(at offsets: IndexSet) {
        for index in offsets {
            let subject = dataManager.subjects[index]
            dataManager.deleteSubject(subject)
        }
    }
}

struct AddSubjectView: View {
    @Binding var isPresented: Bool
    @ObservedObject private var dataManager = DataManager.shared

    var editingSubject: Subject?

    @State private var name: String = ""
    @State private var selectedColor: Color = .blue

    let availableColors: [Color] = [
        .blue, .red, .green, .orange, .purple, .pink, .yellow, .cyan, .mint, .indigo
    ]

    var body: some View {
        VStack(spacing: 20) {
            Text(editingSubject == nil ? "Add Subject" : "Edit Subject")
                .font(.title2)

            TextField("Subject Name", text: $name)
                .textFieldStyle(.roundedBorder)

            VStack(alignment: .leading) {
                Text("Color")
                    .font(.headline)

                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                    ForEach(availableColors, id: \.description) { color in
                        Circle()
                            .fill(color)
                            .frame(width: 40, height: 40)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                            )
                            .onTapGesture {
                                selectedColor = color
                            }
                    }
                }
            }

            HStack {
                Button("Cancel") {
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)

                Spacer()

                Button(editingSubject == nil ? "Add" : "Update") {
                    saveSubject()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(name.isEmpty)
            }
        }
        .padding(30)
        .frame(width: 400)
        .onAppear {
            if let subject = editingSubject {
                name = subject.name
                selectedColor = subject.color
            }
        }
    }

    private func saveSubject() {
        let colorHex = selectedColor.toHex() ?? "#007AFF"

        if let editing = editingSubject {
            var updated = editing
            updated.name = name
            updated.colorHex = colorHex
            dataManager.updateSubject(updated)
        } else {
            let newSubject = Subject(name: name, colorHex: colorHex)
            dataManager.addSubject(newSubject)
        }

        isPresented = false
    }
}
