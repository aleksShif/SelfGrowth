//
//  JournalView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/7/25.
//


import SwiftUI
import SwiftData

struct JournalView: View {
    @State private var selectedTab = 2 // Journal tab selected
    @State private var selectedDate: Int
    @State private var selectedCategory = 0
    @State private var currentWeekStartDate = Date().startOfWeek()
    
    @Query private var activitiesLog: [ActivityLog]
    
    @Environment(\.modelContext) private var modelContext
    
    // current day will automatically be selected
    init() {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today) // 1 = Sunday, 2 = Monday, etc.
        
        // Need to convert to 0-based index, since Mon is usually 2
        let currentDayIndex = (weekday + 5) % 7
        
        // Ensure we don't go beyond our 5-day view (Mon-Fri)
        let initialSelectedDate = min(currentDayIndex, 6)
        
        // Initialize the state
        _selectedDate = State(initialValue: initialSelectedDate)
    }
    
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
    
    var journalCategories: [JournalCategory] {
        return CategoryData.categories.enumerated()
            .map { (index, category) in
                var taskCount = 0
                if index == 0 {
                    taskCount = filteredActivitiesByDate.count
                } else {
                    taskCount = filteredActivitiesByDate.filter {$0.category == index}.count
                }
                return JournalCategory(category: category, tasks: taskCount)
            }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)), Color(#colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1))]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Main content
            ZStack(alignment: .bottom) {
                SkyBackgroundView(topColor: Color(#colorLiteral(red: 0.4756627083, green: 0.5513323545, blue: 0.8908587098, alpha: 1)), cloudColor: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                
                VStack(spacing: 30) {
                    // Top section with clouds and title
                    ZStack(alignment: .top) {
                        // Header
                        VStack(alignment: .center, spacing: 4) {
                            Text("Your Journal")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text("Want to get a good look at your progress?")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                        }
                        .padding(.top, 40)
                    }
                    
//                    Spacer()
                    
                    // Week Selector
                    HStack {
                        Button(action: {
                            currentWeekStartDate = Calendar.current.date(byAdding: .day, value: -7, to: currentWeekStartDate)!
                            selectedDate = 0
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .background(Color(#colorLiteral(red: 0.7, green: 0.9, blue: 0.7, alpha: 1)))
                                .cornerRadius(12)
                        }
                        
                        Spacer()
                        
                        Text(weekRange)
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            currentWeekStartDate = Calendar.current.date(byAdding: .day, value: 7, to: currentWeekStartDate)!
                            selectedDate = 0
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(currentWeekStartDate.isCurrentWeek() ? .gray : .white)
                                .frame(width: 40, height: 40)
                                .background(currentWeekStartDate.isCurrentWeek() ? Color(#colorLiteral(red: 0.7, green: 0.9, blue: 0.7, alpha: 0.5)) :
                                                Color(#colorLiteral(red: 0.7, green: 0.9, blue: 0.7, alpha: 1)))
                                .cornerRadius(12)
                        }
                        .disabled(currentWeekStartDate.isCurrentWeek())
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 30)
                    
                    // Date selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<weekDates.count, id: \.self) { index in
                                DateButton(
                                    day: weekDates[index].day,
                                    number: weekDates[index].number,
                                    isSelected: selectedDate == index
                                )
                                .onTapGesture {
                                    selectedDate = index
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                    }
                    
                    // Categories section
                    ScrollView {
                        VStack {
                            HStack {
                                Text("Category")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Spacer()
                                
                            }
                            .padding(.top, 10)
                            .padding(.horizontal)
                            
                            // Category cards
                            ScrollView(.horizontal, showsIndicators: false){
                                HStack(spacing: 15) {
                                    ForEach(0..<journalCategories.count, id: \.self) { index in
                                        CategoryCard(
                                            category: journalCategories[index].category,
                                            tasks: journalCategories[index].tasks,
                                            isSelected: selectedCategory == index
                                        )
                                        .onTapGesture {
                                            selectedCategory = index
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            // Task card
                           
                            VStack(spacing: 20) {
                                ForEach(filteredActivities) { activity in
                                    LoggedActivityCardView(activity: activity)
                                }
                            }
                            .padding()
                        
                    }
                }
                    .padding(.bottom, 80)
                    
                    // Custom tab bar
//                    CustomTabBarView(selectedTab: $selectedTab)
                }
            }
        }
    }
    
    var weekRange: String {
        let startDate = weekDates.first?.date ?? Date()
        let endDate = weekDates.last?.date ?? Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let yearFormatter = DateFormatter()
        yearFormatter.dateFormat = "yyyy"
        
        return "\(dateFormatter.string(from: startDate))-\(dateFormatter.string(from: endDate)), \(yearFormatter.string(from: startDate))"
    }
    
    var filteredActivitiesByDate: [ActivityLog] {
        let selectedDay = weekDates[selectedDate].date
        
        return activitiesLog.filter { activity in
            Calendar.current.isDate(activity.dateCompleted, inSameDayAs: selectedDay)
        }
    }
    
    var filteredActivities: [ActivityLog] {
        if selectedCategory == 0 {
            return filteredActivitiesByDate
        } else {
            return filteredActivitiesByDate.filter { $0.category == selectedCategory }
        }
    }
}

// Date button component
struct DateButton: View {
    let day: String
    let number: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(day)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .black)
            
            Text(number)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .white : .black)
        }
        .frame(width: 60, height: 80)
        .background(isSelected ? Color(#colorLiteral(red: 0.7, green: 0.9, blue: 0.7, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5)))
        .cornerRadius(15)
    }
}

extension Date {
    func startOfWeek() -> Date {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // start week display from Monday
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!
    }
    
    func isCurrentWeek() -> Bool {
        return self.startOfWeek() == Date().startOfWeek()
    }
}

// Category card component
struct CategoryCard: View {
    let category: Category
    let tasks: Int
    let isSelected: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                Rectangle()
                    .fill(isSelected ? Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)) : Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5)) )
                    .frame(width: 160, height: 100)
                    .cornerRadius(15)
                VStack() {
                    HStack() {
                        VStack(alignment: .leading) {
                            Text(category.name)
                                .font(.headline)
                                .foregroundColor(isSelected ? .white : .black)
                                .lineLimit(1)
                                .frame(height: 30, alignment: .leading)
                                .padding(.trailing, 14)
                        }
                        
                        Image(systemName: category.icon)
                            .foregroundColor(.white)
                            .background(Color.white.opacity(0.3))
                            .cornerRadius(8)
                        
                    }
                    .padding(.horizontal, 10)
                    
                    Text("\(tasks) Tasks Logged")
                        .font(.subheadline)
                        .foregroundColor(isSelected ? Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)) : Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
                        .padding(.top, 10)
                        .padding(.bottom, 12)
                }
            }
        }
        .padding()
        .cornerRadius(15)
        .frame(width: 170)
    }
}

// Extension to apply rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct JournalView_Previews: PreviewProvider {
    static var previews: some View {
        JournalView()
    }
}
