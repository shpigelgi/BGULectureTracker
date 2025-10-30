# Quick Start Guide

## TL;DR - What You Need to Do

Your project is **95% ready**! All the code is written. You just need to:

1. **Open Xcode** and create a new macOS App project in this folder
2. **Add the source files** to the project
3. **Add a Widget Extension** target
4. **Enable App Groups** for both targets
5. **Build and run!**

Detailed instructions are in `SETUP.md`.

## What's Already Done

✅ All Swift source code (21 files)
✅ Data models and business logic
✅ Menu bar app implementation
✅ Widget extension implementation
✅ Git repository initialized
✅ Pushed to GitHub: https://github.com/shpigelgi/BGULectureTracker
✅ Entitlements files created
✅ .gitignore configured
✅ README documentation

## What You'll Get

### Menu Bar App
- Always-visible status icon showing how many lectures behind
- Dropdown menu with all subjects
- Quick "Mark Watched" buttons
- Settings window for managing subjects, schedules, and breaks

### Widgets (3 Sizes)
- **Small:** Shows most behind subject with progress circle
- **Medium:** Lists 2-3 subjects with progress bars
- **Large:** Complete overview of all subjects

### Features
- Separate tracking for lectures and practices
- Smart calculation accounting for break periods
- Color-coded subjects for easy identification
- Automatic updates every 15 minutes

## File Structure

```
~/Personal/BGULectureTracker/
├── README.md                    ← Project documentation
├── SETUP.md                     ← Detailed Xcode setup guide (START HERE!)
├── QUICKSTART.md               ← This file
├── .gitignore                  ← Git configuration
├── BGULectureTracker.entitlements  ← App permissions
├── LectureWidget.entitlements      ← Widget permissions
├── Info.plist                  ← App configuration
│
├── Shared/                     ← Code shared between app and widget
│   ├── Models/
│   │   ├── Subject.swift
│   │   ├── LectureSchedule.swift
│   │   ├── BreakPeriod.swift
│   │   ├── WatchProgress.swift
│   │   └── SessionType.swift
│   ├── Services/
│   │   ├── DataManager.swift
│   │   └── ProgressCalculator.swift
│   └── Utilities/
│       ├── Constants.swift
│       └── Extensions.swift
│
├── BGULectureTracker/          ← Main app target
│   ├── BGULectureTrackerApp.swift
│   ├── AppDelegate.swift
│   └── Views/
│       ├── MenuBarView.swift
│       ├── SettingsView.swift
│       ├── SubjectListView.swift
│       ├── ScheduleListView.swift
│       └── BreakPeriodsView.swift
│
└── LectureWidget/              ← Widget target
    ├── LectureWidget.swift
    └── LectureWidgetView.swift
```

## Next Step

**Open `SETUP.md`** and follow the step-by-step instructions to set up Xcode.

Estimated time: **5 minutes**

## Example Usage After Setup

1. **Add Subject:**
   - Open Settings → Subjects tab
   - Click + → Enter "Linear Algebra" → Choose color

2. **Add Schedule:**
   - Schedules tab → Click +
   - Subject: Linear Algebra
   - Type: Lecture
   - Day: Monday
   - Time: 10:00 AM
   - Start Date: Start of semester

3. **Add Another Schedule:**
   - Same subject, Type: Practice, Thursday 2:00 PM

4. **Add Break Period:**
   - Breaks tab → Click +
   - Name: "Passover Break"
   - Start: April 1, End: April 7

5. **Use the App:**
   - Click menu bar icon to see progress
   - Click "Watched Lecture" after watching
   - Widget updates automatically

## Support

- Check `SETUP.md` for detailed instructions
- Check `README.md` for feature documentation
- Issues: https://github.com/shpigelgi/BGULectureTracker/issues

Happy studying! 📚
