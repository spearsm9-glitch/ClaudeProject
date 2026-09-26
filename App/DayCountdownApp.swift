import SwiftUI
import WidgetKit

/// The host app. Widgets must ship inside an app; this one doubles as a playground
/// for trying out themes before putting the real widget on your desktop.
@main
struct DayCountdownApp: App {
    var body: some Scene {
        WindowGroup {
            PlaygroundView()
                .onAppear { WidgetCenter.shared.reloadAllTimelines() }
        }
        .windowResizability(.contentSize)
    }
}

struct PlaygroundView: View {
    @State private var model = CountdownModel.sample

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 4) {
                Text("🎈 Day Countdown")
                    .font(.system(size: 28, weight: .black, design: .rounded))
                Text("Add the widget: right-click your desktop → **Edit Widgets…** → search “Day Countdown”.\nSet your date: right-click the widget → **Edit “Day Countdown”**.")
                    .foregroundStyle(.secondary)
            }

            Form {
                TextField("Event", text: $model.eventName)
                TextField("Emoji", text: $model.emoji)
                DatePicker("Date", selection: $model.targetDate, displayedComponents: .date)
                Picker("Theme", selection: $model.theme) {
                    ForEach(CountdownTheme.allCases, id: \.self) { theme in
                        Text(String(localized: CountdownTheme.caseDisplayRepresentations[theme]!.title))
                            .tag(theme)
                    }
                }
            }
            .formStyle(.grouped)
            .frame(width: 420)

            Text("Preview")
                .font(.headline)

            HStack(alignment: .top, spacing: 20) {
                VStack(spacing: 20) {
                    WidgetFrame(model: model, width: 170, height: 170) { SmallCountdownView(model: $0) }
                    WidgetFrame(model: model, width: 364, height: 170) { MediumCountdownView(model: $0) }
                }
                WidgetFrame(model: model, width: 364, height: 382) { LargeCountdownView(model: $0) }
            }
        }
        .padding(28)
    }
}

/// Mimics a desktop widget's shape so previews look like the real thing.
struct WidgetFrame<Content: View>: View {
    let model: CountdownModel
    let width: CGFloat
    let height: CGFloat
    @ViewBuilder let content: (CountdownModel) -> Content

    var body: some View {
        content(model)
            .padding(16)
            .frame(width: width, height: height)
            .background(ThemeBackground(theme: model.theme))
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
    }
}
