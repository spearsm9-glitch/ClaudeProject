import SwiftUI
import WidgetKit

/// The host app. Widgets must ship inside an app; this one doubles as a preview
/// so you can see the widget before putting it on your desktop.
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
                Text("Japan Countdown")
                    .font(Wa.mincho(28))
                Text("Add the widget: right-click your desktop → **Edit Widgets…** → search “Japan Countdown”.\nSet your date: right-click the widget → **Edit “Japan Countdown”**.")
                    .foregroundStyle(.secondary)
            }

            DatePicker("Preview date", selection: $model.targetDate, displayedComponents: .date)
                .frame(width: 280)

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
            .background(WashiBackground())
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.2), radius: 10, y: 5)
    }
}
