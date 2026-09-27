import SwiftUI

// MARK: - Background

/// Washi paper with a band of seigaiha (blue ocean wave) pattern along the bottom.
struct WashiBackground: View {
    var waveHeight: CGFloat = 0.28

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(colors: [Wa.paper, Wa.paperShade], startPoint: .top, endPoint: .bottom)
            GeometryReader { geo in
                Seigaiha(radius: 12)
                    .frame(height: geo.size.height * waveHeight)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .mask(
                        LinearGradient(colors: [.clear, .black], startPoint: .top, endPoint: .init(x: 0.5, y: 0.55))
                    )
            }
        }
    }
}

/// Overlapping fans of concentric arcs, drawn row by row so each row tucks under the next.
struct Seigaiha: View {
    var radius: CGFloat
    var lineColor: Color = Wa.indigo.opacity(0.35)
    var fillColor: Color = Wa.paperShade

    var body: some View {
        Canvas { ctx, size in
            let r = radius
            let rowStep = r / 2
            var row = 0
            var y: CGFloat = 0
            while y <= size.height + r {
                let offset: CGFloat = row.isMultiple(of: 2) ? 0 : r
                var x: CGFloat = -r + offset
                while x <= size.width + r {
                    let center = CGPoint(x: x, y: y)
                    let outer = Path(ellipseIn: CGRect(x: x - r, y: y - r, width: r * 2, height: r * 2))
                    ctx.fill(outer, with: .color(fillColor))
                    for k in 0..<4 {
                        let rr = r * (1 - CGFloat(k) * 0.25)
                        let ring = Path(ellipseIn: CGRect(x: center.x - rr, y: center.y - rr, width: rr * 2, height: rr * 2))
                        ctx.stroke(ring, with: .color(lineColor), lineWidth: 1)
                    }
                    x += r * 2
                }
                y += rowStep
                row += 1
            }
        }
    }
}

// MARK: - Building blocks

/// The red rising-sun disc with the day count written on it.
struct SunNumber: View {
    let model: CountdownModel
    var diameter: CGFloat

    var body: some View {
        ZStack {
            Circle()
                .fill(Wa.red)
                .shadow(color: Wa.red.opacity(0.35), radius: 6, y: 3)
            Group {
                if model.isToday {
                    Text("今日")
                } else {
                    Text("\(model.magnitude)")
                        .contentTransition(.numericText())
                }
            }
            .font(Wa.mincho(diameter * (model.isToday ? 0.3 : 0.42)))
            .foregroundStyle(Wa.paper)
            .lineLimit(1)
            .minimumScaleFactor(0.4)
            .padding(diameter * 0.12)
        }
        .frame(width: diameter, height: diameter)
    }
}

/// "JAPAN" set wide in Mincho.
struct JapanTitle: View {
    var size: CGFloat

    var body: some View {
        Text("JAPAN")
            .font(Wa.mincho(size))
            .tracking(size * 0.35)
            .foregroundStyle(Wa.ink)
            .lineLimit(1)
            .minimumScaleFactor(0.6)
    }
}

/// A small square hanko (seal stamp) reading 日本.
struct Hanko: View {
    var size: CGFloat = 26

    var body: some View {
        VStack(spacing: -size * 0.08) {
            Text("日")
            Text("本")
        }
        .font(Wa.mincho(size * 0.38))
        .foregroundStyle(Wa.paper)
        .frame(width: size, height: size * 1.25)
        .background(Wa.red, in: RoundedRectangle(cornerRadius: 3))
        .rotationEffect(.degrees(-3))
    }
}

struct UnitLabel: View {
    let model: CountdownModel
    var size: CGFloat = 10

    var body: some View {
        Text(model.unitLabel)
            .font(Wa.mincho(size, bold: false))
            .tracking(size * 0.3)
            .foregroundStyle(Wa.ink.opacity(0.75))
            .lineLimit(1)
    }
}

// MARK: - Widget layouts

struct SmallCountdownView: View {
    let model: CountdownModel

    var body: some View {
        VStack(spacing: 6) {
            HStack(alignment: .top) {
                JapanTitle(size: 15)
                Spacer(minLength: 0)
                Hanko(size: 18)
            }
            Spacer(minLength: 0)
            SunNumber(model: model, diameter: 78)
            UnitLabel(model: model, size: 9)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MediumCountdownView: View {
    let model: CountdownModel

    var body: some View {
        HStack(spacing: 20) {
            SunNumber(model: model, diameter: 106)
                .padding(.leading, 6)

            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top) {
                    JapanTitle(size: 24)
                    Spacer(minLength: 0)
                    Hanko(size: 22)
                }
                UnitLabel(model: model, size: 11)
                Rectangle()
                    .fill(Wa.ink.opacity(0.4))
                    .frame(width: 36, height: 1)
                Text(model.dateText)
                    .font(Wa.mincho(12, bold: false))
                    .foregroundStyle(Wa.ink.opacity(0.8))
                Spacer(minLength: 0)
            }
            .padding(.top, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct LargeCountdownView: View {
    let model: CountdownModel

    var body: some View {
        VStack(spacing: 14) {
            HStack(alignment: .top) {
                JapanTitle(size: 30)
                Spacer(minLength: 0)
                Hanko(size: 30)
            }
            Spacer(minLength: 0)
            SunNumber(model: model, diameter: 150)
            UnitLabel(model: model, size: 13)
            Spacer(minLength: 0)
            HStack(spacing: 0) {
                detail(value: model.weeksAndDays, label: "WEEKS")
                Rectangle().fill(Wa.ink.opacity(0.3)).frame(width: 1, height: 30)
                detail(value: model.dateText, label: "DEPARTURE")
            }
            .padding(.vertical, 8)
            .background(Wa.paper.opacity(0.85), in: RoundedRectangle(cornerRadius: 6))
            .overlay(RoundedRectangle(cornerRadius: 6).stroke(Wa.ink.opacity(0.25), lineWidth: 1))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func detail(value: String, label: String) -> some View {
        VStack(spacing: 3) {
            Text(value)
                .font(Wa.mincho(15))
                .foregroundStyle(Wa.ink)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Text(label)
                .font(Wa.mincho(9, bold: false))
                .tracking(2)
                .foregroundStyle(Wa.ink.opacity(0.65))
        }
        .frame(maxWidth: .infinity)
    }
}
