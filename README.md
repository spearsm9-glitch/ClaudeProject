# 🎈 Day Countdown — a macOS desktop widget

A colorful WidgetKit widget that counts down the days to a date you choose.
It updates every midnight, and when the day arrives it shows a 🎉.

- **Small:** emoji, a big chunky number and the event name
- **Medium:** a tilted tear-off calendar page, a cheer ("This week! 🥳") and a "sleeps to go" count
- **Large:** party bunting, a giant number, and bubbles for weeks, sleeps and weekday
- **Themes:** 🌅 Sunset · 🍬 Bubblegum · 🌊 Ocean · 🍋 Lime Fizz · 🪐 Galaxy
- If the date has passed, it counts the days *since*.

Requires **macOS 14 (Sonoma) or later** and **Xcode 15 or later**.

## Build and install

```bash
brew install xcodegen      # one time
xcodegen generate          # creates DayCountdown.xcodeproj
open DayCountdown.xcodeproj
```

1. In Xcode, select the **DayCountdown** project. Then, under **Signing & Capabilities**, pick your
   Team for *both* targets (`DayCountdown` and `CountdownWidget`). A free personal team works.
   You can also change `com.example` to your own bundle ID prefix in `project.yml`.
2. Choose the **DayCountdown** scheme and press **⌘R**. The app opens a preview playground.
   Running it once registers the widget with macOS.
   - To keep the widget after you quit Xcode, choose **Product → Archive → Distribute App → Custom → Copy App**.
     Then move `DayCountdown.app` into `/Applications` and open it once.
3. Right-click the desktop, choose **Edit Widgets…**, search for **Day Countdown**, and drag it onto the desktop.
4. Right-click the widget and choose **Edit "Day Countdown"**. Set the event name, date, emoji and theme.

## Project layout

| Path | What's in it |
| --- | --- |
| `Shared/Countdown.swift` | Day math, themes and messages |
| `Shared/CountdownViews.swift` | The SwiftUI views for the small, medium and large widgets |
| `Widget/CountdownWidget.swift` | Widget configuration (App Intent), timeline and bundle |
| `App/DayCountdownApp.swift` | The host app, with a live preview playground |
| `project.yml` | XcodeGen spec used to generate the Xcode project |
