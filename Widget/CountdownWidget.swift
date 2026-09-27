import AppIntents
import SwiftUI
import WidgetKit

// MARK: - Configuration (right-click the widget → "Edit Japan Countdown")

struct CountdownConfigIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Japan Countdown"
    static var description = IntentDescription("Count down the days until your trip to Japan.")

    @Parameter(title: "Departure Date")
    var targetDate: Date?

    func model(at now: Date) -> CountdownModel {
        CountdownModel(targetDate: targetDate ?? CountdownModel.defaultTarget(from: now), now: now)
    }
}

// MARK: - Timeline

struct CountdownEntry: TimelineEntry {
    let date: Date
    let model: CountdownModel
}

struct CountdownProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> CountdownEntry {
        CountdownEntry(date: .now, model: .sample)
    }

    func snapshot(for configuration: CountdownConfigIntent, in context: Context) async -> CountdownEntry {
        if context.isPreview && configuration.targetDate == nil {
            return CountdownEntry(date: .now, model: .sample)
        }
        return CountdownEntry(date: .now, model: configuration.model(at: .now))
    }

    func timeline(for configuration: CountdownConfigIntent, in context: Context) async -> Timeline<CountdownEntry> {
        // One entry now, then one at each of the next 7 midnights so the number ticks over daily.
        let cal = Calendar.current
        let now = Date.now
        var entries = [CountdownEntry(date: now, model: configuration.model(at: now))]
        var midnight = cal.startOfDay(for: now)
        for _ in 0..<7 {
            guard let next = cal.date(byAdding: .day, value: 1, to: midnight) else { break }
            midnight = next
            entries.append(CountdownEntry(date: midnight, model: configuration.model(at: midnight)))
        }
        return Timeline(entries: entries, policy: .atEnd)
    }
}

// MARK: - Widget

struct CountdownWidgetView: View {
    @Environment(\.widgetFamily) private var family
    let entry: CountdownEntry

    var body: some View {
        Group {
            switch family {
            case .systemMedium: MediumCountdownView(model: entry.model)
            case .systemLarge: LargeCountdownView(model: entry.model)
            default: SmallCountdownView(model: entry.model)
            }
        }
        .containerBackground(for: .widget) {
            WashiBackground()
        }
    }
}

struct DayCountdownWidget: Widget {
    let kind = "DayCountdownWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: CountdownConfigIntent.self, provider: CountdownProvider()) { entry in
            CountdownWidgetView(entry: entry)
        }
        .configurationDisplayName("Japan Countdown")
        .description("Days until Japan.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

@main
struct CountdownWidgetBundle: WidgetBundle {
    var body: some Widget {
        DayCountdownWidget()
    }
}

#Preview(as: .systemSmall) {
    DayCountdownWidget()
} timeline: {
    CountdownEntry(date: .now, model: .sample)
}

#Preview(as: .systemMedium) {
    DayCountdownWidget()
} timeline: {
    CountdownEntry(date: .now, model: .sample)
}

#Preview(as: .systemLarge) {
    DayCountdownWidget()
} timeline: {
    CountdownEntry(date: .now, model: .sample)
}
