//
//  AppDelegate.swift
//  BGULectureTracker
//
//  Created on 2025-10-30.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var settingsWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create menu bar status item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "book.circle", accessibilityDescription: "BGU Lecture Tracker")
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Create popover for menu bar dropdown
        popover = NSPopover()
        popover?.contentSize = NSSize(width: 350, height: 400)
        popover?.behavior = .transient
        popover?.contentViewController = NSHostingController(rootView: MenuBarView())

        // Update status badge
        updateStatusBadge()

        // Set up timer to update badge periodically
        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { [weak self] _ in
            self?.updateStatusBadge()
        }

        // Show settings window on first launch
        if UserDefaults.standard.bool(forKey: "hasLaunchedBefore") == false {
            UserDefaults.standard.set(true, forKey: "hasLaunchedBefore")
            showSettings()
        }
    }

    @objc func togglePopover() {
        guard let button = statusItem?.button else { return }

        if let popover = popover {
            if popover.isShown {
                popover.performClose(nil)
            } else {
                // Update content before showing
                updateStatusBadge()
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            }
        }
    }

    func updateStatusBadge() {
        let dataManager = DataManager.shared
        let calculator = ProgressCalculator.shared

        let allProgress = calculator.calculateAllProgress(
            subjects: dataManager.subjects,
            schedules: dataManager.schedules,
            watchProgress: dataManager.watchProgress,
            breakPeriods: dataManager.breakPeriods
        )

        let totalBehind = calculator.calculateTotalBehind(progressList: allProgress)

        // Update button image with badge
        if let button = statusItem?.button {
            if totalBehind == 0 {
                button.image = NSImage(systemSymbolName: "book.circle.fill", accessibilityDescription: "Up to date")
            } else if totalBehind <= 3 {
                button.image = NSImage(systemSymbolName: "exclamationmark.circle", accessibilityDescription: "\(totalBehind) behind")
            } else {
                button.image = NSImage(systemSymbolName: "exclamationmark.triangle.fill", accessibilityDescription: "\(totalBehind) behind")
            }
        }
    }

    func showSettings() {
        if settingsWindow == nil {
            let settingsView = SettingsView()
            let hostingController = NSHostingController(rootView: settingsView)
            settingsWindow = NSWindow(contentViewController: hostingController)
            settingsWindow?.title = "BGU Lecture Tracker Settings"
            settingsWindow?.styleMask = [.titled, .closable, .miniaturizable, .resizable]
            settingsWindow?.setContentSize(NSSize(width: 600, height: 500))
            settingsWindow?.center()
        }

        settingsWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            showSettings()
        }
        return true
    }
}
