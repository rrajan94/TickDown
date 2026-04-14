# TickDown

A tiny macOS menu bar app that shows you how much time is left in your day.

That's it. No accounts, no syncing, no notifications. Just a number counting down in your menu bar.

<table>
  <tr>
    <td><img src="https://github.com/user-attachments/assets/fdbca2ff-51b2-4abc-8a9c-8e9e3b17cb0d" width="220"/></td>
    <td><img src="https://github.com/user-attachments/assets/2ba1d2c8-b5fe-475e-89a4-4cd2139de805" width="220"/></td>
    <td><img src="https://github.com/user-attachments/assets/03261bf1-d7d8-44bf-aec7-799acba57f71" width="220"/></td>
  </tr>
</table>

---

## What it does

You click it, you see this:

```
6823s  ← seconds left today (in your menu bar)
```

Click the number to switch between 9 modes:

**Today**
- Seconds left today
- Minutes left today
- Hours left today

**This week**
- Days left this week
- Hours left this week

**This month**
- Days left this month
- Hours left this month

**This year**
- Days left this year
- Hours left this year

Your choice is saved. Resets automatically at midnight.

---

## Why

I wanted a constant reminder that the day is finite. Not in an anxious way, just as a nudge to be intentional. A clock tells you what time it is. TickDown tells you what's left.

---

## Install

Right now you need to build it yourself in Xcode. No App Store, no DMG yet.

**Requirements**
- macOS 13 or later
- Xcode 15 or later

**Steps**

1. Clone the repo
```bash
git clone https://github.com/rrajan94/TickDown.git
cd TickDown
```

2. Open in Xcode
```bash
open TickDown.xcodeproj
```

3. Hit **⌘R** to build and run

4. Look at your menu bar — you'll see the countdown

> The app has no Dock icon by design. It lives only in the menu bar.

---

## Roadmap

Things I want to add:

- [ ] Focus timer with notifications (set X minutes, get pinged)
- [ ] Color shifts as the day runs out (green → amber → red)
- [ ] Percentage mode — show `73.4%` instead of raw seconds
- [ ] Launch at login toggle inside the app
- [ ] DMG release so no Xcode needed

---

## Contributing

PRs welcome. Keep it focused — this is a menu bar utility, not a productivity suite.

If you find a bug or have an idea, open an issue.

---

## License

MIT — do whatever you want with it.
