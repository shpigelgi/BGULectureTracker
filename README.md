# BGU Lecture Tracker

A macOS menu bar app and widget for tracking university lectures and practices at Ben-Gurion University.

## Features

- **Menu Bar Integration**: Always visible in your menu bar with at-a-glance status
- **Widget Support**: Home screen widgets in small, medium, and large sizes
- **Separate Tracking**: Track lectures and practices independently
- **Smart Calculations**: Automatically calculates how many sessions you're behind based on schedules
- **Break Periods**: Account for holidays, exam periods, and other breaks
- **Color-Coded Subjects**: Visually distinguish between different courses
- **Quick Actions**: Mark sessions as watched directly from the menu bar

## Requirements

- macOS 13.0 or later
- Xcode 15.0 or later

## Setup Instructions

### 1. Open in Xcode

1. Open Xcode
2. Click "Open a project or file"
3. Navigate to the `BGULectureTracker` folder
4. You'll need to create a new Xcode project first (see below)

### 2. Create Xcode Project

Since the source files are ready, you need to create an Xcode project:

1. Open Xcode
2. Create a new project: **File > New > Project**
3. Choose **macOS > App**
4. Configure:
   - Product Name: `BGULectureTracker`
   - Team: Select your development team
   - Organization Identifier: `com.shpigelgi`
   - Interface: **SwiftUI**
   - Language: **Swift**
5. Save in the existing `BGULectureTracker` folder

### 3. Add Files to Project

1. Delete the default `BGULectureTrackerApp.swift` file that Xcode created
2. **File > Add Files to "BGULectureTracker"**
3. Add all the folders:
   - `Shared` folder (check "Create groups", add to both targets)
   - `BGULectureTracker` folder (add to main target only)

### 4. Add Widget Extension

1. **File > New > Target**
2. Choose **macOS > Widget Extension**
3. Configure:
   - Product Name: `LectureWidget`
   - Include Configuration Intent: **No**
4. Delete the default widget files Xcode creates
5. **File > Add Files to "BGULectureTracker"**
6. Add the `LectureWidget` folder (add to widget target only)

### 5. Configure App Groups

Both targets need to share data via App Groups:

1. Select the project in the navigator
2. Select the **BGULectureTracker** target
3. Go to **Signing & Capabilities**
4. Click **+ Capability** and add **App Groups**
5. Add group: `group.com.shpigelgi.bgulecturetracker`
6. Repeat for the **LectureWidget** target

### 6. Build and Run

1. Select the **BGULectureTracker** scheme
2. Click **Run** or press `Cmd+R`
3. The app will launch and show the settings window
4. Add your subjects and schedules!

## Usage

### Adding Subjects

1. Open Settings from the menu bar dropdown
2. Go to the **Subjects** tab
3. Click **+ Add Subject**
4. Enter subject name and choose a color

### Adding Schedules

1. Go to the **Schedules** tab
2. Click **+ Add Schedule**
3. Select subject, type (lecture/practice), day, time, and start date
4. You can add multiple schedules per subject

### Adding Break Periods

1. Go to the **Breaks** tab
2. Click **+ Add Break**
3. Name the break period and set start/end dates

### Marking Sessions as Watched

- Click the **Watched Lecture** or **Watched Practice** button in the menu bar dropdown
- The widget will update automatically

## Project Structure

```
BGULectureTracker/
├── Shared/
│   ├── Models/              # Data models
│   ├── Services/            # Business logic
│   └── Utilities/           # Extensions and constants
├── BGULectureTracker/       # Main app
│   └── Views/              # SwiftUI views
└── LectureWidget/           # Widget extension
```

## Data Storage

All data is stored in UserDefaults with App Group sharing, allowing both the app and widget to access the same data.

## Contributing

Feel free to open issues or submit pull requests!

## License

MIT License - feel free to use this for your own studies!
