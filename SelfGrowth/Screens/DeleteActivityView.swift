//
//  DeleteActivityView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/14/25.
//

import SwiftUI
import SwiftData

struct DeleteActivityView: View {
    let activity: Activity
    @Binding var isPresented: Bool
    @Environment(\.modelContext) private var modelContext
    
    // Animation state
    @State private var isShaking = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Warning icon
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.red)
                            .rotationEffect(.degrees(isShaking ? 5 : -5))
                            .animation(
                                Animation.easeInOut(duration: 0.1)
                                    .repeatCount(5, autoreverses: true),
                                value: isShaking
                            )
                            .onAppear {
                                isShaking = true
                            }
                    }
                    .padding(.top, 105)
                    
                    
                    // Warning text
                    Text("Are you sure you want to delete \"\(activity.name)\"?")
                        .fixedSize(horizontal: false, vertical: true)
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 100)
                }
                
                Text("This will permanently remove this activity and you won't be able to log it anymore. This action cannot be undone. Previously logged entries will remain unchanged.")
                    .fixedSize(horizontal: false, vertical: true)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // Activity preview
                HStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(activity.color)
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: activity.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading) {
                        Text(activity.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text("\(activity.duration) minutes")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 15).fill(Color.gray.opacity(0.1)))
                .padding(.horizontal)
                
                
                
                // Action buttons
                HStack(spacing: 15) {
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
                        deleteActivity()
                        isPresented = false
                    }) {
                        Text("Delete")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(15)
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 100)
            }
            .padding()
            .navigationBarTitle("Delete Activity", displayMode: .inline)
            .toolbarBackground(Color(#colorLiteral(red: 0.4514811635, green: 0.6588239074, blue: 0.4605069757, alpha: 1)), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
            .foregroundColor(Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)))
        }
        .presentationDetents([.medium])
    }
    
    func deleteActivity() {
        // Delete the activity
        modelContext.delete(activity)
        
        try? modelContext.save()
    }
    
}
