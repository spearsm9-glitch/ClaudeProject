import AppIntents
import SwiftUI

// MARK: - Themes

enum CountdownTheme: String, AppEnum, CaseIterable {
    case sunset, bubblegum, ocean, lime, galaxy

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Theme"
    static var caseDisplayRepresentations: [CountdownTheme: DisplayRepresentation] = [
        .sunset: "🌅 Sunset",
        .bubblegum: "🍬 Bubblegum",
        .ocean: "🌊 Ocean",
        .lime: "🍋 Lime Fizz",
        .galaxy: "🪐 Galaxy",
    ]

    var gradient: [Color] {
        switch self {
        case .sunset: [Color(hex: 0xFF5F6D), Color(hex: 0xFF9A3C), Color(hex: 0xFFC371)]
        case .bubblegum: [Color(hex: 0xFF6FD8), Color(hex: 0xB86BFF), Color(hex: 0x7F7FFF)]
        case .ocean: [Color(hex: 0x00C6FB), Color(hex: 0x005BEA), Color(hex: 0x2E3192)]
        case .lime: [Color(hex: 0x9BE15D), Color(hex: 0x00C9A7), Color(hex: 0x00A3C4)]
        case .galaxy: [Color(hex: 0x1A1054), Color(hex: 0x5B2A86), Color(hex: 0xE0467C)]
        }
    }

    /// Strong color used for the big number on white "calendar page" cards.
    var accent: Color {
        switch self {
        case .sunset: Color(hex: 0xF0433A)
        case .bubblegum: Color(hex: 0xB33BE0)
        case .ocean: Color(hex: 0x0063D1)
        case .lime: Color(hex: 0x00A37A)
        case .galaxy: Color(hex: 0x6A2C9C)
        }
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255
        )
    }
}

// MARK: - Model

struct CountdownModel {
    var eventName: String
    var emoji: String
    var targetDate: Date
    var theme: CountdownTheme
    var now: Date = .now

    /// Whole calendar days from today to the target. Positive = future, 0 = today, negative = past.
    var days: Int {
        let cal = Calendar.current
        let from = cal.startOfDay(for: now)
        let to = cal.startOfDay(for: targetDate)
        return cal.dateComponents([.day], from: from, to: to).day ?? 0
    }

    var isToday: Bool { days == 0 }
    var isPast: Bool { days < 0 }
    var magnitude: Int { abs(days) }

    var unitLabel: String {
        if isToday { return "IT'S TODAY" }
        let unit = magnitude == 1 ? "DAY" : "DAYS"
        return isPast ? "\(unit) SINCE" : "\(unit) TO GO"
    }

    var weeksAndDays: String {
        let weeks = magnitude / 7, rest = magnitude % 7
        if weeks == 0 { return "\(rest)d" }
        return rest == 0 ? "\(weeks)w" : "\(weeks)w \(rest)d"
    }

    var sleeps: String {
        magnitude == 1 ? "1 sleep" : "\(magnitude) sleeps"
    }

    var cheer: String {
        switch days {
        case ..<0: "Remember when? 💭"
        case 0: "It's here! Party time! 🎉"
        case 1: "TOMORROW!! 🤩"
        case 2...7: "This week! 🥳"
        case 8...30: "Getting close ✨"
        case 31...100: "On the horizon 🔭"
        default: "Good things take time 🌱"
        }
    }

    var dateText: String {
        targetDate.formatted(.dateTime.month(.abbreviated).day().year())
    }

    /// Next New Year's Day, used when no date has been picked yet.
    static func defaultTarget(from now: Date = .now) -> Date {
        let cal = Calendar.current
        let nextYear = cal.component(.year, from: now) + 1
        return cal.date(from: DateComponents(year: nextYear, month: 1, day: 1)) ?? now
    }

    static let sample = CountdownModel(
        eventName: "Beach Trip",
        emoji: "🏝️",
        targetDate: Calendar.current.date(byAdding: .day, value: 23, to: .now)!,
        theme: .sunset
    )
}
