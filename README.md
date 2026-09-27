# Japan Countdown: a macOS desktop widget

A WidgetKit widget that counts down the days until your trip to Japan.
It updates every midnight.

- **Look:** washi-paper background, a red rising-sun disc with the day count on it, an indigo
  *seigaiha* wave pattern, a small 日本 *hanko* seal stamp, and **JAPAN** set in Hiragino Mincho
  (a Japanese serif font that comes with every Mac).
- **Sizes:**
  - **Small:** the sun with the number
  - **Medium:** the sun, plus the title, "DAYS TO GO" and the date
  - **Large:** everything above, plus weeks-and-days and the departure date
- **On the day** the sun reads 今日 ("today"). After the date passes, it counts days *since*.

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
2. Choose the **DayCountdown** scheme and press **⌘R**. The app opens a preview window.
   Running it once registers the widget with macOS.
   - To keep the widget after you quit Xcode, choose **Product → Archive → Distribute App → Custom → Copy App**.
     Then move `DayCountdown.app` into `/Applications` and open it once.
3. Right-click the desktop, choose **Edit Widgets…**, search for **Japan Countdown**, and drag it onto the desktop.
4. Right-click the widget, choose **Edit "Japan Countdown"**, and set your **Departure Date**.
   Until you set it, the widget counts down to New Year's Day.

## Project layout

| Path | What's in it |
| --- | --- |
| `Shared/Countdown.swift` | Day math, colors and fonts |
| `Shared/CountdownViews.swift` | The SwiftUI views for the small, medium and large widgets |
| `Widget/CountdownWidget.swift` | Widget settings (the date), timeline and bundle |
| `App/DayCountdownApp.swift` | The host app, with a live preview |
| `project.yml` | XcodeGen spec used to generate the Xcode project |
