import SwiftUI

// MARK: - Palette & type

enum Wa {
    /// Washi paper
    static let paper = Color(hex: 0xF5EFE3)
    static let paperShade = Color(hex: 0xEADFCB)
    /// Sumi ink
    static let ink = Color(hex: 0x2B2622)
    /// Beni red (hinomaru / hanko)
    static let red = Color(hex: 0xBC002D)
    /// Ai indigo (waves)
    static let indigo = Color(hex: 0x264B73)

    /// Hiragino Mincho ships with every Mac and gives a brush-like, Japanese serif feel.
    static func mincho(_ size: CGFloat, bold: Bool = true) -> Font {
        .custom(bold ? "HiraMinProN-W6" : "HiraMinProN-W3", size: size)
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
    var targetDate: Date
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
        if isToday { return "TODAY" }
        let unit = magnitude == 1 ? "DAY" : "DAYS"
        return isPast ? "\(unit) SINCE" : "\(unit) TO GO"
    }

    var weeksAndDays: String {
        let weeks = magnitude / 7, rest = magnitude % 7
        if weeks == 0 { return "\(rest)d" }
        return rest == 0 ? "\(weeks)w" : "\(weeks)w \(rest)d"
    }

    var dateText: String {
        targetDate.formatted(.dateTime.month(.abbreviated).day().year())
    }

    /// Next New Year's Day, used until a date has been picked.
    static func defaultTarget(from now: Date = .now) -> Date {
        let cal = Calendar.current
        let nextYear = cal.component(.year, from: now) + 1
        return cal.date(from: DateComponents(year: nextYear, month: 1, day: 1)) ?? now
    }

    static let sample = CountdownModel(
        targetDate: Calendar.current.date(byAdding: .day, value: 42, to: .now)!
    )
}
