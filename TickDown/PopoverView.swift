import SwiftUI
import Combine

struct PopoverView: View {
    @State private var selectedMode: String = UserDefaults.standard.string(forKey: "displayMode") ?? "seconds_day"
    @State private var showPercentage: Bool = UserDefaults.standard.bool(forKey: "showPercentage")
    @State private var tick = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    let modes: [(id: String, label: String, icon: String, group: String)] = [
        ("seconds_day",  "Seconds left today",    "s.circle",        "Today"),
        ("minutes_day",  "Minutes left today",    "m.circle",        "Today"),
        ("hours_day",    "Hours left today",      "h.circle",        "Today"),
        ("days_week",    "Days left this week",   "calendar",        "This Week"),
        ("hours_week",   "Hours left this week",  "calendar.badge.clock", "This Week"),
        ("days_month",   "Days left this month",  "calendar.circle", "This Month"),
        ("hours_month",  "Hours left this month", "clock.badge.checkmark", "This Month"),
        ("days_year",    "Days left this year",   "globe",           "This Year"),
        ("hours_year",   "Hours left this year",  "globe.badge.chevron.backward", "This Year"),
    ]

    var progress: Double {
        _ = tick
        return TimeCalculator.progressElapsed(for: selectedMode)
    }

    var percentageRemaining: Double {
        return (1.0 - progress) * 100.0
    }

    var progressColor: Color {
        if progress < 0.5 { return Color(red: 0.2, green: 0.85, blue: 0.55) }
        if progress < 0.75 { return Color(red: 1.0, green: 0.75, blue: 0.2) }
        return Color(red: 1.0, green: 0.38, blue: 0.35)
    }

    var groups: [String] {
        var seen = [String]()
        for m in modes {
            if !seen.contains(m.group) { seen.append(m.group) }
        }
        return seen
    }

    var body: some View {
        VStack(spacing: 0) {

            // Header - fixed height so it does not jump when toggling
            VStack(spacing: 6) {
                Text("TickDown")
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.secondary)

                if showPercentage {
                    Text(String(format: "%.1f%%", percentageRemaining))
                        .font(.system(size: 42, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    Text("remaining")
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(1.5)
                } else {
                    Text(rawValue())
                        .font(.system(size: 42, weight: .bold, design: .monospaced))
                        .foregroundColor(.primary)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)

                    Text(unitLabel())
                        .font(.system(size: 11, weight: .medium, design: .rounded))
                        .foregroundColor(.secondary)
                        .textCase(.uppercase)
                        .tracking(1.5)
                }
            }
            .frame(height: 110)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
            .background(Color(NSColor.controlBackgroundColor))

            // Progress bar
            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(NSColor.separatorColor).opacity(0.3))
                    Rectangle()
                        .fill(progressColor)
                        .frame(width: geo.size.width * progress)
                        .animation(.linear(duration: 0.5), value: progress)
                }
            }
            .frame(height: 3)

            // Mode list
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(groups, id: \.self) { group in
                        VStack(spacing: 0) {
                            HStack {
                                Text(group)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.secondary)
                                    .tracking(1.2)
                                    .textCase(.uppercase)
                                Spacer()
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .padding(.bottom, 4)

                            ForEach(modes.filter { $0.group == group }, id: \.id) { mode in
                                ModeRow(
                                    mode: mode,
                                    isSelected: selectedMode == mode.id,
                                    onTap: {
                                        selectedMode = mode.id
                                        UserDefaults.standard.set(mode.id, forKey: "displayMode")
                                        if let delegate = NSApp.delegate as? AppDelegate {
                                            delegate.updateDisplay()
                                        }
                                    }
                                )
                            }
                        }
                    }
                }
                .padding(.bottom, 8)
            }

            Divider()

            // Footer
            HStack(spacing: 0) {
                HStack(spacing: 6) {
                    Text("Show % remaining")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)

                    Toggle("", isOn: Binding(
                        get: { showPercentage },
                        set: { val in
                            showPercentage = val
                            UserDefaults.standard.set(val, forKey: "showPercentage")
                            if let delegate = NSApp.delegate as? AppDelegate {
                                delegate.updateDisplay()
                            }
                        }
                    ))
                    .toggleStyle(.switch)
                    .scaleEffect(0.75)
                    .frame(width: 38)
                }

                Spacer()

                Button("Quit") {
                    NSApp.terminate(nil)
                }
                .buttonStyle(.plain)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            }
            .frame(height: 36)
            .padding(.horizontal, 12)
        }
        .frame(width: 320, height: 420)
        .onReceive(timer) { _ in
            tick.toggle()
        }
    }

    func rawValue() -> String {
        _ = tick
        switch selectedMode {
        case "seconds_day":   return "\(TimeCalculator.secondsLeftInDay())"
        case "minutes_day":   return "\(TimeCalculator.minutesLeftInDay())"
        case "hours_day":     return String(format: "%.1f", TimeCalculator.hoursLeftInDay())
        case "days_week":     return "\(TimeCalculator.secondsLeftInWeek() / 86400)"
        case "hours_week":    return String(format: "%.0f", TimeCalculator.hoursLeftInWeek())
        case "days_month":    return "\(TimeCalculator.daysLeftInMonth())"
        case "hours_month":   return String(format: "%.0f", TimeCalculator.hoursLeftInMonth())
        case "days_year":     return "\(TimeCalculator.daysLeftInYear())"
        case "hours_year":    return String(format: "%.0f", TimeCalculator.hoursLeftInYear())
        default:              return "\(TimeCalculator.secondsLeftInDay())"
        }
    }

    func unitLabel() -> String {
        switch selectedMode {
        case "seconds_day":   return "seconds left today"
        case "minutes_day":   return "minutes left today"
        case "hours_day":     return "hours left today"
        case "days_week":     return "days left this week"
        case "hours_week":    return "hours left this week"
        case "days_month":    return "days left this month"
        case "hours_month":   return "hours left this month"
        case "days_year":     return "days left this year"
        case "hours_year":    return "hours left this year"
        default:              return ""
        }
    }
}

struct ModeRow: View {
    let mode: (id: String, label: String, icon: String, group: String)
    let isSelected: Bool
    let onTap: () -> Void

    @State private var hovered = false

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: mode.icon)
                .font(.system(size: 13))
                .foregroundColor(isSelected ? .accentColor : .secondary)
                .frame(width: 18)

            Text(mode.label)
                .font(.system(size: 13))
                .foregroundColor(.primary)

            Spacer()

            if isSelected {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.accentColor)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 7)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(isSelected
                      ? Color.accentColor.opacity(0.12)
                      : hovered ? Color(NSColor.controlColor).opacity(0.5) : Color.clear)
                .padding(.horizontal, 6)
        )
        .contentShape(Rectangle())
        .onHover { h in hovered = h }
        .onTapGesture { onTap() }
    }
}
