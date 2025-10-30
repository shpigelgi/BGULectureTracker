//
//  BGULectureTrackerApp.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import SwiftUI

@main
struct BGULectureTrackerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
