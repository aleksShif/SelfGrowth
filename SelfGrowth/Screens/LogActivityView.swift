//
//  LogActivityView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/14/25.
//

import SwiftUI
import SwiftData

struct LogActivityView: View {
    let activity: Activity
    @Binding var isPresented: Bool
    @Binding var duration: Int
    @Binding var description: String
    
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
           NavigationView {
               VStack(alignment: .leading, spacing: 10) {
                   // Activity Header
                   HStack {
                       ZStack {
                           Circle()
                               .fill(activity.colorOption.color)
                               .frame(width: 50, height: 50)
                           
                           Image(systemName: activity.icon)
                               .font(.system(size: 24))
                               .foregroundColor(.white)
                       }
                       
                       VStack(alignment: .leading) {
                           Text(activity.name)
                               .font(.title2)
                               .fontWeight(.bold)
                           
                           Text("Ready to log your activity?")
                               .font(.subheadline)
                               .foregroundColor(.gray)
                       }
                       .padding(.leading, 10)
                   }
                   .padding(.top, 110)
                   .padding(.bottom, 10)
                   
                   // Duration Adjustment
                   VStack(alignment: .leading, spacing: 10) {
                       Text("Duration (minutes)")
                           .font(.headline)
                       
                       HStack {
                           Button(action: {
                               if duration > 5 {
                                   duration -= 5
                               }
                           }) {
                               Image(systemName: "minus.circle.fill")
                                   .font(.system(size: 30))
                                   .foregroundColor(Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                           }
                           
                           Text("\(duration)")
                               .font(.title)
                               .frame(width: 80)
                               .multilineTextAlignment(.center)
                           
                           Button(action: {
                               duration += 5
                           }) {
                               Image(systemName: "plus.circle.fill")
                                   .font(.system(size: 30))
                                   .foregroundColor(Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                           }
                       }
                       .padding()
                       .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
                   }
                   
                   // Description
                   VStack(alignment: .leading, spacing: 0) {
                       Text("Description (optional)")
                           .font(.headline)
                       
                       TextField("How was your activity?", text: $description)
                           .padding()
                           .background(RoundedRectangle(cornerRadius: 15).fill(Color.white.opacity(0.1)))
                           .frame(height: 100)
                   }
                   
                   
                   // Bottom buttons
                   HStack {
                       Button(action: {
                           isPresented = false
                       }) {
                           Text("Cancel")
                               .fontWeight(.medium)
                               .padding()
                               .frame(maxWidth: .infinity)
                               .background(Color.gray.opacity(0.2))
                               .cornerRadius(15)
                       }
                       
                       Button(action: {
                           logActivity()
                           isPresented = false
                       }) {
                           Text("Log Activity")
                               .fontWeight(.bold)
                               .foregroundColor(.white)
                               .padding()
                               .frame(maxWidth: .infinity)
                               .background(Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)))
                               .cornerRadius(15)
                       }
                   }
                   .padding(.bottom, 100)
               }
               .padding()
               .navigationBarTitle("Log Activity", displayMode: .inline)
               .toolbarBackground(Color(#colorLiteral(red: 0.4514811635, green: 0.6588239074, blue: 0.4605069757, alpha: 1)), for: .navigationBar)
               .toolbarBackground(.visible, for: .navigationBar)
               .background(Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
               .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
           }
           .presentationDetents([.medium])
       }
       
       func logActivity() {
           // Create a new ActivityLog entry
           let activityLog = ActivityLog(
               activityId: activity.id,
               name: activity.name,
               duration: duration,
               description: description,
               category: activity.category,
               icon: activity.icon,
               colorOption: activity.colorOption
           )
           
           // Save to SwiftData
           modelContext.insert(activityLog)
           
           try? modelContext.save()
           
           // Reset values
           description = ""
           duration = activity.duration
       }
   }
