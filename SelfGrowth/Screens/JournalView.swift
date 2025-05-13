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
    @State private var selectedDate = 0 // First date selected
    @State private var selectedCategory = 0
    
    @Query private var activities: [Activity]
    
    @Environment(\.modelContext) private var modelContext
    
    // Sample dates
    let dates = [
        (day: "MON", number: "10"),
        (day: "TUE", number: "11"),
        (day: "WED", number: "12"),
        (day: "THU", number: "13"),
        (day: "FRI", number: "14")
    ]
    
    var journalCategories: [JournalCategory] {
        return CategoryData.categories.enumerated()
            .map { (index, category) in
                var taskCount = 0
                if index == 0 {
                    taskCount = activities.count
                } else {
                    taskCount = activities.filter {$0.category == index}.count
                }
                return JournalCategory(category: category, tasks: taskCount)
            }
    }
////
//    let categories = [
//           (category: Category(name: "School", icon: "book", color: Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5))), tasks: 4),
//           (category: Category(name: "Mindfulness", icon: "moon.zzz", color: Color(#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 0.5))), tasks: 3)
//       ]
    
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
                    
                    Spacer()
                    
                    // Date selector
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(0..<dates.count, id: \.self) { index in
                                DateButton(
                                    day: dates[index].day,
                                    number: dates[index].number,
                                    isSelected: selectedDate == index
                                )
                                .onTapGesture {
                                    selectedDate = index
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 10)
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
                                    ActivityCardView(activity: activity)
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
    var filteredActivities: [Activity] {
        if selectedCategory == 0 {
            return activities
        } else {
            return activities.filter { $0.category == selectedCategory }
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
