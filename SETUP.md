# BGU Lecture Tracker - Setup Guide

All the source code is ready! Follow these steps to set up the Xcode project.

## Quick Setup (5 minutes)

### Step 1: Create the Xcode Project

1. Open Xcode:
   ```bash
   open -a Xcode
   ```

2. Create new project:
   - Click **"Create New Project"** or **File → New → Project**
   - Select **macOS** tab → **App** template
   - Click **Next**

3. Configure project:
   - **Product Name:** `BGULectureTracker`
   - **Team:** Select your Apple Developer team
   - **Organization Identifier:** `com.shpigelgi`
   - **Interface:** SwiftUI
   - **Language:** Swift
   - **Uncheck** "Include Tests"
   - Click **Next**

4. **IMPORTANT:** Save location:
   - Navigate to and select: `~/Personal/BGULectureTracker`
   - **Uncheck** "Create Git repository" (we already have one)
   - Click **Create**

### Step 2: Add Shared Files to Main Target

1. In Xcode's Project Navigator (left sidebar):
   - **Right-click** on the `BGULectureTracker` folder (blue icon)
   - Select **"Add Files to BGULectureTracker..."**

2. Navigate to `~/Personal/BGULectureTracker/Shared`
   - Select the **Shared** folder
   - **Check** "Create groups"
   - **Check** "BGULectureTracker" target
   - **Uncheck** "Copy items if needed" (files are already in the right place)
   - Click **Add**

3. Delete the default ContentView.swift file if it exists:
   - Right-click → **Delete**
   - Choose **"Move to Trash"**

4. Replace the default BGULectureTrackerApp.swift:
   - Delete the default one (Move to Trash)
   - **Right-click** on `BGULectureTracker` folder → **"Add Files to BGULectureTracker..."**
   - Navigate to `~/Personal/BGULectureTracker/BGULectureTracker-Source`
   - Select **all .swift files** in this folder and the Views subfolder
   - **Check** "Create groups"
   - **Check** "BGULectureTracker" target only
   - Click **Add**

### Step 3: Add Widget Extension Target

1. Add Widget Extension:
   - **File → New → Target**
   - Select **macOS** tab → **Widget Extension**
   - Click **Next**

2. Configure widget:
   - **Product Name:** `LectureWidget`
   - **Include Configuration Intent:** **NO** (uncheck)
   - Click **Finish**
   - Click **Activate** when asked about the scheme

3. Add shared files to widget:
   - Expand the `LectureWidget` folder in Project Navigator
   - **Delete** all default widget files (LectureWidget.swift, etc.) - Move to Trash
   - **Right-click** on `LectureWidget` folder → **"Add Files to BGULectureTracker..."**
   - Navigate to `~/Personal/BGULectureTracker/LectureWidget-Source`
   - Select **all .swift files**
   - **Check** "LectureWidget" target only
   - Click **Add**

4. Add Shared files to widget target:
   - In Project Navigator, find the **Shared** folder
   - Select all files inside Shared (hold Cmd and click each file)
   - In the **File Inspector** (right panel), under **Target Membership**
   - **Check** the "LectureWidget" checkbox
   - Now Shared files are included in both targets

### Step 4: Configure App Groups

**For Main App Target:**
1. Select the project (top of navigator)
2. Select **BGULectureTracker** target
3. Click **Signing & Capabilities** tab
4. Click **+ Capability** button
5. Search for and add **"App Groups"**
6. Click the **+** under App Groups
7. Enter: `group.com.shpigelgi.bgulecturetracker`
8. Click **OK**

**For Widget Target:**
1. Select **LectureWidget** target
2. Click **Signing & Capabilities** tab
3. Click **+ Capability**
4. Add **"App Groups"**
5. Click the **+** under App Groups
6. Enter: `group.com.shpigelgi.bgulecturetracker` (same as above!)
7. Click **OK**

### Step 5: Build and Run!

1. Select scheme:
   - Click the scheme selector (top left) → Select **"BGULectureTracker"**

2. Build:
   - Press **⌘B** or **Product → Build**
   - Fix any errors if they appear

3. Run:
   - Press **⌘R** or **Product → Run**
   - The app should launch with a menu bar icon!

## Troubleshooting

### "Cannot find type 'Subject' in scope"
- Make sure the Shared folder is added to both targets
- Check Target Membership for all Shared files

### "Sandbox: rsync.samba deny(1) file-write-create"
- This is normal, ignore it

### Widget not showing
- After first run, add the widget:
  - Right-click desktop → Edit Widgets
  - Search for "Lecture Tracker"
  - Drag to Notification Center

### App Groups not working
- Make sure both targets have the EXACT same group identifier
- Check that you're signed in with your Apple ID in Xcode

## First Run

1. The Settings window will open automatically
2. Add your first subject (e.g., "Calculus")
3. Add a schedule for that subject
4. Click the menu bar icon to see your progress!

## Project Structure in Xcode

After setup, your project should look like:

```
BGULectureTracker (project)
├── BGULectureTracker (target)
│   ├── BGULectureTrackerApp.swift
│   ├── AppDelegate.swift
│   └── Views/
│       ├── MenuBarView.swift
│       ├── SettingsView.swift
│       ├── SubjectListView.swift
│       ├── ScheduleListView.swift
│       └── BreakPeriodsView.swift
├── LectureWidget (target)
│   ├── LectureWidget.swift
│   └── LectureWidgetView.swift
└── Shared (used by both targets)
    ├── Models/
    ├── Services/
    └── Utilities/
```

## Need Help?

If you encounter issues:
1. Make sure Xcode is updated to version 15+
2. Make sure you're running macOS 13+
3. Check that all files have correct target membership
4. Clean build folder: **Product → Clean Build Folder** (⇧⌘K)

Enjoy tracking your lectures! 📚
