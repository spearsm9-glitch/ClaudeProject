import SwiftUI

// MARK: - Background

struct ThemeBackground: View {
    let theme: CountdownTheme

    var body: some View {
        ZStack {
            LinearGradient(colors: theme.gradient, startPoint: .topLeading, endPoint: .bottomTrailing)

            // Soft floating blobs
            GeometryReader { geo in
                let w = geo.size.width, h = geo.size.height
                Circle()
                    .fill(.white.opacity(0.18))
                    .frame(width: w * 0.7)
                    .position(x: w * 0.95, y: h * 0.05)
                Circle()
                    .fill(.white.opacity(0.12))
                    .frame(width: w * 0.45)
                    .position(x: w * 0.05, y: h * 0.95)
                Circle()
                    .fill(.black.opacity(0.06))
                    .frame(width: w * 0.3)
                    .position(x: w * 0.8, y: h * 0.85)
            }

            Sparkles()
        }
    }
}

/// A sprinkle of little stars scattered across the widget.
struct Sparkles: View {
    private let spots: [(x: CGFloat, y: CGFloat, size: CGFloat, glyph: String)] = [
        (0.12, 0.18, 9, "✦"), (0.55, 0.10, 7, "✧"), (0.88, 0.40, 10, "✦"),
        (0.30, 0.55, 6, "•"), (0.70, 0.72, 8, "✧"), (0.18, 0.86, 7, "✦"),
        (0.93, 0.92, 6, "•"), (0.46, 0.93, 6, "✧"),
    ]

    var body: some View {
        GeometryReader { geo in
            ForEach(spots.indices, id: \.self) { i in
                let s = spots[i]
                Text(s.glyph)
                    .font(.system(size: s.size))
                    .foregroundStyle(.white.opacity(0.55))
                    .position(x: geo.size.width * s.x, y: geo.size.height * s.y)
            }
        }
    }
}

// MARK: - Building blocks

struct Pill: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .bold, design: .rounded))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(.white.opacity(0.25), in: Capsule())
    }
}

struct BigNumber: View {
    let model: CountdownModel
    var size: CGFloat

    var body: some View {
        Group {
            if model.isToday {
                Text("🎉")
            } else {
                Text("\(model.magnitude)")
                    .contentTransition(.numericText())
            }
        }
        .font(.system(size: size, weight: .black, design: .rounded))
        .minimumScaleFactor(0.4)
        .lineLimit(1)
        .shadow(color: .black.opacity(0.18), radius: 0, x: 2, y: 3)
    }
}

/// A tilted tear-off calendar page with the number of days on it.
struct CalendarPage: View {
    let model: CountdownModel
    var width: CGFloat = 110

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                model.theme.accent
                HStack(spacing: width * 0.28) {
                    ForEach(0..<2) { _ in
                        Circle().fill(.white.opacity(0.9)).frame(width: 7, height: 7)
                    }
                }
            }
            .frame(height: width * 0.2)

            VStack(spacing: 0) {
                Group {
                    if model.isToday {
                        Text("🎉")
                    } else {
                        Text("\(model.magnitude)")
                            .foregroundStyle(model.theme.accent)
                            .contentTransition(.numericText())
                    }
                }
                .font(.system(size: width * 0.46, weight: .black, design: .rounded))
                .minimumScaleFactor(0.4)
                .lineLimit(1)

                Text(model.unitLabel)
                    .font(.system(size: width * 0.085, weight: .heavy, design: .rounded))
                    .tracking(0.5)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
            }
            .padding(.horizontal, 6)
            .frame(maxHeight: .infinity)
            .background(.white)
            .environment(\.colorScheme, .light)
        }
        .frame(width: width, height: width * 0.95)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
        .rotationEffect(.degrees(-5))
    }
}

/// A string of party bunting across the top of the large widget.
struct Bunting: View {
    let count = 9
    private let colors: [Color] = [.white, .yellow, .white.opacity(0.7)]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<count, id: \.self) { i in
                Triangle()
                    .fill(colors[i % colors.count].opacity(0.85))
                    .frame(width: 18, height: 16)
                    .rotationEffect(.degrees(i.isMultiple(of: 2) ? -6 : 6))
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: rect.minX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        p.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        p.closeSubpath()
        return p
    }
}

struct StatBubble: View {
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 17, weight: .heavy, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(label)
                .font(.system(size: 10, weight: .bold, design: .rounded))
                .opacity(0.85)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(.white.opacity(0.22), in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

// MARK: - Widget layouts

struct SmallCountdownView: View {
    let model: CountdownModel

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text(model.emoji)
                    .font(.system(size: 30))
                    .rotationEffect(.degrees(-8))
                Spacer()
                Pill(text: model.targetDate.formatted(.dateTime.month(.abbreviated).day()))
            }
            Spacer(minLength: 0)
            BigNumber(model: model, size: 56)
            Text(model.unitLabel)
                .font(.system(size: 10, weight: .heavy, design: .rounded))
                .tracking(1)
                .opacity(0.9)
            Text(model.eventName)
                .font(.system(size: 15, weight: .bold, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.top, 1)
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

struct MediumCountdownView: View {
    let model: CountdownModel

    var body: some View {
        HStack(spacing: 18) {
            CalendarPage(model: model, width: 112)
                .padding(.leading, 4)

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(model.emoji).font(.system(size: 26))
                    Text(model.eventName)
                        .font(.system(size: 19, weight: .heavy, design: .rounded))
                        .lineLimit(2)
                        .minimumScaleFactor(0.7)
                }
                Text(model.cheer)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .opacity(0.95)
                Spacer(minLength: 0)
                HStack(spacing: 6) {
                    Pill(text: "📅 \(model.dateText)")
                    if !model.isToday {
                        Pill(text: model.isPast ? model.weeksAndDays + " ago" : "🌙 \(model.sleeps)")
                    }
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
}

struct LargeCountdownView: View {
    let model: CountdownModel

    var body: some View {
        VStack(spacing: 10) {
            Bunting()
                .padding(.top, -6)

            Text(model.emoji)
                .font(.system(size: 44))

            Text(model.eventName)
                .font(.system(size: 24, weight: .heavy, design: .rounded))
                .lineLimit(1)
                .minimumScaleFactor(0.6)

            VStack(spacing: -4) {
                BigNumber(model: model, size: 96)
                Text(model.unitLabel)
                    .font(.system(size: 13, weight: .heavy, design: .rounded))
                    .tracking(2)
            }

            Text(model.cheer)
                .font(.system(size: 15, weight: .semibold, design: .rounded))

            Spacer(minLength: 0)

            HStack(spacing: 8) {
                StatBubble(value: model.weeksAndDays, label: "weeks")
                StatBubble(value: "\(model.magnitude)", label: model.magnitude == 1 ? "sleep" : "sleeps")
                StatBubble(value: model.targetDate.formatted(.dateTime.weekday(.abbreviated)), label: model.targetDate.formatted(.dateTime.month(.abbreviated).day()))
            }
        }
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
