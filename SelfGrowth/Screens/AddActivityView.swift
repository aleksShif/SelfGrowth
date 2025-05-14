//
//  AddActivityView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/8/25.
//


import SwiftUI
import SwiftData

struct AddActivityView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
//    @Binding var activities: [Activity]
    let categories: [Category]
    
    @State private var name = ""
    @State private var description = ""
    @State private var duration = 30
    @State private var selectedCategory = 1
    @State private var selectedColor = Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1))
    @State private var selectedColorIndex = 0
    @State private var selectedIcon = "book"
    
    // Available icons to choose from
    let icons = ["book", "dumbbell", "moon.zzz", "music.note", "gamecontroller", "paintbrush", "camera", "heart", "leaf", "cup.and.saucer"]
    
    // Available colors to choose from
    let colors: [Color] = [
        Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)),
        Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.7647058964, alpha: 1)),
        Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
        Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)),
        Color(#colorLiteral(red: 0.4500938654, green: 0.8412100673, blue: 0.6149917841, alpha: 1))
    ]
    
    let colorsEnum: [ActivityColorOption] = [
        .yellow,
        .teal,
        .purple,
        .pink,
        .green
    ]
    
    var body: some View {
        ZStack {
            // Background gradient
            
            NavigationStack {
                Form {
                    Section(header: Text("Activity Details")
                        .foregroundColor(Color(#colorLiteral(red: 0.4816817045, green: 0.5471228361, blue: 0.8951389194, alpha: 1)))
                        .font(.headline)
                    ) {
                        TextField("Activity Name", text: $name)
                            .foregroundColor(.white)
                            .onChange(of: name) { newValue in
                                if newValue.count > 30 {
                                    name = String(newValue.prefix(30))
                                }
                            }
                        
                        TextField("Description (Optional)", text: $description)
                            .foregroundColor(.white)
                            .onChange(of: description) { newValue in
                                if newValue.count > 50 {
                                    description = String(newValue.prefix(50))
                                }
                            }
                        
                        HStack {
                            Text("Duration: \(duration) minutes")
                                .foregroundColor(.white)
                            Spacer()
                            Stepper("", value: $duration, in: 5...180, step: 5)
                                .labelsHidden()
                        }
                    }
                    .listRowBackground(Color(#colorLiteral(red: 0.6519589424, green: 0.8648104072, blue: 0.7060471177, alpha: 1)))
                    
                    Section(header: Text("Category")
                        .foregroundColor(Color(#colorLiteral(red: 0.4816817045, green: 0.5471228361, blue: 0.8951389194, alpha: 1)))
                        .font(.headline)
                    ) {
                        Picker("Category", selection: $selectedCategory) {
                            ForEach(1..<categories.count, id: \.self) { index in
                                Text(categories[index].name).tag(index)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .foregroundColor(.white)
                    }
                    .listRowBackground(Color(#colorLiteral(red: 0.6519589424, green: 0.8648104072, blue: 0.7060471177, alpha: 1)))

                    Section(header: Text("Icon")
                        .foregroundColor(Color(#colorLiteral(red: 0.4816817045, green: 0.5471228361, blue: 0.8951389194, alpha: 1)))
                        .font(.headline)
                    ) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(icons, id: \.self) { icon in
                                    ZStack {
                                        Circle()
                                            .fill(selectedIcon == icon ? selectedColor : Color.gray.opacity(0.3))
                                            .frame(width: 50, height: 50)
                                        
                                        Image(systemName: icon)
                                            .font(.system(size: 20))
                                            .foregroundColor(.white)
                                    }
                                    .onTapGesture {
                                        selectedIcon = icon
                                    }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listRowBackground(Color(#colorLiteral(red: 0.6519589424, green: 0.8648104072, blue: 0.7060471177, alpha: 1)))
                    
                    Section(header: Text("Color")
                        .foregroundColor(Color(#colorLiteral(red: 0.4816817045, green: 0.5471228361, blue: 0.8951389194, alpha: 1)))
                        .font(.headline)
                    ) {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(colors.indices, id: \.self) { index in
                                    Circle()
                                        .fill(colors[index])
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Circle()
                                                .stroke(selectedColor == colors[index] ? Color.white : Color.clear, lineWidth: 2)
                                        )
                                        .onTapGesture {
                                            selectedColor = colors[index]
                                            selectedColorIndex = index
                                        }
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .listRowBackground(Color(#colorLiteral(red: 0.6519589424, green: 0.8648104072, blue: 0.7060471177, alpha: 1)))
                    
                    Section {
                        Button("Add Activity") {
                            addActivity()
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                        .padding()
                        .background(isFormValid ? Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)) : Color.gray)
                        .cornerRadius(10)
                        .disabled(!isFormValid)
                    }
                    .listRowBackground(Color(#colorLiteral(red: 0.9107120633, green: 0.9107120633, blue: 0.9107120633, alpha: 1)))

                }
                .scrollContentBackground(.hidden)
                .background(Color(#colorLiteral(red: 0.9107120633, green: 0.9107120633, blue: 0.9107120633, alpha: 1)))
                .navigationTitle("Add New Activity")
                .navigationBarTitleDisplayMode(.inline)
                .toolbarColorScheme(.dark, for: .navigationBar)
                .toolbarBackground(
                    Color(#colorLiteral(red: 0.6519589424, green: 0.8648104072, blue: 0.7060471177, alpha: 1)),
                    for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationBarItems(trailing: Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.white))
            }
            .accentColor(.white)
        }
    }
    
    // Validation check
    var isFormValid: Bool {
        !name.isEmpty && duration >= 5
    }
    
    // Add the activity to the list
    func addActivity() {
        let newActivity = Activity(
            name: name,
            duration: duration,
            icon: selectedIcon,
            colorOption: colorsEnum[selectedColorIndex],
            category: selectedCategory
        )
        
        modelContext.insert(newActivity)
        
        try? modelContext.save()
        
        dismiss()
    }
}

struct AddActivityView_Previews: PreviewProvider {
    static var previews: some View {
        @State var activities = [
            Activity(name: "Study Session", duration: 45, icon: "book", color: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), category: 1),
            Activity(name: "Workout", duration: 45, icon: "dumbbell", color: Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.7647058964, alpha: 1)), category: 2),
            Activity(name: "Meditation", duration: 15, icon: "moon.zzz", color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)), category: 3)
        ]
        
        // Category data
        let categories = [
            Category(name: "All", icon: "plus", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
            Category(name: "School", icon: "heart", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
            Category(name: "Fitness", icon: "figure.walk", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
            Category(name: "Mindfulness", icon: "moon.zzz", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1))),
            Category(name: "Hobbies", icon: "gamecontroller", color: Color(#colorLiteral(red: 0.3820864856, green: 0.6893107295, blue: 0.9856509566, alpha: 1)))
        ]
        AddActivityView(categories: categories)
    }
}
