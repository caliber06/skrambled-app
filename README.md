# Skrambled - A simple to-do app for iOS

Designed for how my brain works. Maybe you'll get some use out of it too.

## About / Goals

This idea came from being unsatisfied with how existing to-do apps worked or flowed. Many of them also required subscriptions for basic features, which was annoying. Additionally, I had intended to get into iOS development soon anyway, and this was a good and simple way to get started. A coworker recently vibe-coded a better stopwatch app intended for counting sets of a workout, which inspired me to get cracking on this, and here we are.

My goal was to simply make an app that organized tasks like a service request ticket in a ticket queue and categorized them based on how I think about things I need to do.

## Features / Flow

Tasks are sorted first by priority, then by how soon the task is due. Tasks without due dates are placed at the bottom of their respective priority group in alphabetical order.

I also tend to forget what I'm supposed to be doing throughout the day or the week, so I wanted frequent notifications. 

Currently, you're notified 48h, 24h, 1h, 30m, and 15m before the task is due. I'd like to make it to where you're notified every day leading up to when the task is due, and then it starts decrementing into the hourly and minute-ly notifications.

Tasks are archived and moved to the "Past Tasks" section after some user-defined amount of days have passed after the due date. They're deleted after some user-defined amount of days have passed after the due date. By default these values are 15 days and 30 days respectively. You can also set tasks to never be archived and/or to never delete.

Tasks have names, a "notes" field that's displayed in the task queue, a priority with associated colors, and they can have or not have a user-defined due date. 

When in the main task queue view, you can swipe to the left on a task to delete it, and swipe to the right on a task to complete it, after which it's moved to "past tasks."
When in the "past tasks" view, you can swipe to the left on a task to delete it, and swipe right on a task to recycle it, after which it's moved into the main task queue.
When in the task editing view, you can delete the task or mark it as complete at the bottom of the page.

Completed tasks in the "past tasks" view show when they were completed. If they are overdue, that text is red. Otherwise, it's green. Overdue tasks also have the date in red in the main tasks queue.

## Possible future additions / to-dos

* Put it on the App Store
* A calendar view
* Web app with tasks synced (More focused development would be required)
* Users should be notified every day leading up to when the task is due, and then it starts decrementing into the hourly and minute-ly notifications.

## Takeaways

The Apple development ecosystem is strange and it took some getting used to. In addition to learning an entirely new language, I also made myself develop on a MacBook I borrowed from the Winthrop IT office, and I used Xcode. This taught me a bit more about the Mac workflow and, while I had been an avid Mac-hater in the past, I now understand why people like them, even if I myself still prefer my crusty Thinkpad.
