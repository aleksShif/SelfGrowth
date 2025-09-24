//
//  JournalViewModel.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/19/25.
//


import Foundation
import SwiftUI
import SwiftData

class JournalViewModel: ObservableObject {
    // Dependencies
    private var modelContext: ModelContext?
    
    @Published var selectedDate: Int
    @Published var selectedCategory: Int = 0
    @Published var currentWeekStartDate: Date = Date().startOfWeek()
    
    // ActivityLog from SwiftData
    @Published var allLogs: [ActivityLog] = []
    
    init() {
        let weekday = Calendar.current.component(.weekday, from: Date())
        selectedDate = min((weekday + 5) % 7, 6) // Convert weekday to 0-based index
    }
    
    func setContextIfNeeded(_ context: ModelContext) {
        guard self.modelContext == nil else { return }
        self.modelContext = context
        fetchLogs()
    }
    
    func fetchLogs() {
        guard let context = modelContext else { return }
        do {
            allLogs = try context.fetch(FetchDescriptor<ActivityLog>())
        } catch {
            print("Error fetching activity logs: \(error)")
        }
    }
    
    // getting all current week dates
    var weekDates: [(day: String, number: String, date: Date)] {
         return (0..<7).map { dayOffset in
             let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: currentWeekStartDate)!
             let dayFormatter = DateFormatter()
             dayFormatter.dateFormat = "EEE"
             let day = dayFormatter.string(from: date).uppercased()

             let numberFormatter = DateFormatter()
             numberFormatter.dateFormat = "dd"
             let number = numberFormatter.string(from: date)

             return (day: day, number: number, date: date)
         }
     }


    var selectedDay: Date {
        weekDates[selectedDate].date
    }
    
    // used for when user clicks on a specific datebutton (see JournalView)
    var filteredActivitiesByDate: [ActivityLog] {
        allLogs.filter {
            Calendar.current.isDate($0.dateCompleted, inSameDayAs: selectedDay)
        }
    }

    // used for when user clicks on a specific categorycard (see JournalView)
    var filteredActivities: [ActivityLog] {
        if selectedCategory == 0 {
            return filteredActivitiesByDate
        } else {
            return filteredActivitiesByDate.filter { $0.category == selectedCategory }
        }
    }

    // see Constant folder under components
    var journalCategories: [JournalCategory] {
        CategoryData.categories.enumerated().map { index, category in
            let taskCount = index == 0
                ? filteredActivitiesByDate.count
                : filteredActivitiesByDate.filter { $0.category == index }.count
            return JournalCategory(category: category, tasks: taskCount)
        }
    }
    
    // formatting for date displayed above date buttons
    var weekRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        guard let start = weekDates.first?.date, let end = weekDates.last?.date else {
            return ""
        }
        return "\(formatter.string(from: start))-\(formatter.string(from: end)), \(yearFormatter.string(from: start))"
    }
    
    func goToPreviousWeek() {
        currentWeekStartDate = Calendar.current.date(byAdding: .day, value: -7, to: currentWeekStartDate)!
        selectedDate = 0
    }

    func goToNextWeek() {
        currentWeekStartDate = Calendar.current.date(byAdding: .day, value: 7, to: currentWeekStartDate)!
        selectedDate = 0
    }

    func isNextWeekButtonDisabled() -> Bool {
        currentWeekStartDate.isCurrentWeek()
    }
}
