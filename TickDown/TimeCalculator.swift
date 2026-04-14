import Foundation

struct TimeCalculator {

    // MARK: - Raw values

    static func secondsLeftInDay() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let endOfDay = calendar.startOfDay(for: calendar.date(byAdding: .day, value: 1, to: now)!)
        return max(0, Int(endOfDay.timeIntervalSince(now)))
    }

    static func minutesLeftInDay() -> Int {
        return secondsLeftInDay() / 60
    }

    static func hoursLeftInDay() -> Double {
        return Double(secondsLeftInDay()) / 3600.0
    }

    static func secondsLeftInWeek() -> Int {
        let now = Date()
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now)
        comps.weekday = 2 // Monday
        let startOfWeek = calendar.date(from: comps)!
        let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek)!
        return max(0, Int(endOfWeek.timeIntervalSince(now)))
    }

    static func hoursLeftInWeek() -> Double {
        return Double(secondsLeftInWeek()) / 3600.0
    }

    static func minutesLeftInWeek() -> Int {
        return secondsLeftInWeek() / 60
    }

    static func secondsLeftInMonth() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let comps = calendar.dateComponents([.year, .month], from: now)
        let startOfMonth = calendar.date(from: comps)!
        let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        return max(0, Int(startOfNextMonth.timeIntervalSince(now)))
    }

    static func hoursLeftInMonth() -> Double {
        return Double(secondsLeftInMonth()) / 3600.0
    }

    static func daysLeftInMonth() -> Int {
        return secondsLeftInMonth() / 86400
    }

    static func secondsLeftInYear() -> Int {
        let now = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: now)
        var comps = DateComponents()
        comps.year = year + 1
        comps.month = 1
        comps.day = 1
        let startOfNextYear = calendar.date(from: comps)!
        return max(0, Int(startOfNextYear.timeIntervalSince(now)))
    }

    static func daysLeftInYear() -> Int {
        return secondsLeftInYear() / 86400
    }

    static func hoursLeftInYear() -> Double {
        return Double(secondsLeftInYear()) / 3600.0
    }

    // MARK: - Menu bar label

    static func menuBarLabel(for mode: String) -> String {
        switch mode {
            case "seconds_day":  return "\(secondsLeftInDay())s"
            case "minutes_day":  return "\(minutesLeftInDay())m"
            case "hours_day":    return String(format: "%.1fh", hoursLeftInDay())
            case "hours_week":   return String(format: "%.0fh/wk", hoursLeftInWeek())
            case "days_week":    return "\(secondsLeftInWeek() / 86400)d/wk"
            case "days_month":   return "\(daysLeftInMonth())d/mo"
            case "hours_month":  return String(format: "%.0fh/mo", hoursLeftInMonth())
            case "days_year":    return "\(daysLeftInYear())d/yr"
            case "hours_year":   return String(format: "%.0fh/yr", hoursLeftInYear())
            default:             return "\(secondsLeftInDay())s"
        }
    }

    // MARK: - Progress (0.0 to 1.0, how much has elapsed)

    static func progressElapsed(for mode: String) -> Double {
        switch mode {
        case "seconds_day", "minutes_day", "hours_day":
            let total = 86400.0
            let remaining = Double(secondsLeftInDay())
            return (total - remaining) / total

        case "hours_week", "days_week":
            let total = 7.0 * 86400.0
            let remaining = Double(secondsLeftInWeek())
            return (total - remaining) / total

        case "days_month", "hours_month":
            let now = Date()
            let calendar = Calendar.current
            let comps = calendar.dateComponents([.year, .month], from: now)
            let startOfMonth = calendar.date(from: comps)!
            var nextComps = comps
            nextComps.month = (comps.month ?? 1) + 1
            let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            let total = startOfNextMonth.timeIntervalSince(startOfMonth)
            let remaining = Double(secondsLeftInMonth())
            return (total - remaining) / total

        case "days_year", "hours_year":
            let now = Date()
            let calendar = Calendar.current
            let year = calendar.component(.year, from: now)
            var startComps = DateComponents(); startComps.year = year; startComps.month = 1; startComps.day = 1
            var endComps = DateComponents(); endComps.year = year + 1; endComps.month = 1; endComps.day = 1
            let startOfYear = calendar.date(from: startComps)!
            let startOfNextYear = calendar.date(from: endComps)!
            let total = startOfNextYear.timeIntervalSince(startOfYear)
            let remaining = Double(secondsLeftInYear())
            return (total - remaining) / total

        default:
            return 0
        }
    }
}
