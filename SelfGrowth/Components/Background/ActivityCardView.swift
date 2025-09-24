//
//  ActivityCardView.swift
//  SelfGrowth
//
//  Created by Sasha Shifrina on 5/14/25.
//

import SwiftUI
import SwiftData

enum ActiveSheet: Identifiable {
    case log, delete
    
    var id: Int {
        switch self {
        case .log: return 0
        case .delete: return 1
        }
    }
}

struct ActivityCardView: View {
    let activity: Activity
    @State private var activeSheet: ActiveSheet?
    @State private var isArrowPressed = false
    @State private var isTrashPressed = false
    @State private var logDuration: Int
    @State private var logDescription: String = ""
    @ObservedObject var overlayState: OverlayState
    @ObservedObject var viewModel: TrackViewModel
    
    init(activity: Activity, overlayState: OverlayState, viewModel: TrackViewModel) {
        self.activity = activity
        self._overlayState = ObservedObject(wrappedValue: overlayState)
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        _logDuration = State(initialValue: activity.duration)
        _logDescription = State(initialValue: activity.activityDescription)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(#colorLiteral(red: 0.2997636199, green: 0.6950053573, blue: 0.7074371576, alpha: 1)))
                
                ZStack {
                    Ellipse()
                        .fill(activity.colorOption.color)
                        .frame(width: 250, height: 120)
                        .rotationEffect(.degrees(10))
                    
                    Image(systemName: activity.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    if activity.name == "Workout" {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 40, height: 40)
                            .position(x: 50, y: 40)

                        BranchShape()
                            .fill(Color.purple.opacity(0.8))
                            .frame(width: 330, height: 30)
                            .padding(.horizontal, -20)
                            .offset(x: 20, y: 45)
                    }
                }
                
                HStack {
                    CloudView(width: 60, height: 30, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: 10, y: -20)
                    
                    Spacer()
                    
                    CloudView(width: 50, height: 25, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: 120, y: -30)
                    
                    Spacer()
                    CloudView(width:40, height: 20, color: Color(#colorLiteral(red: 0.5906556249, green: 0.8661773801, blue: 0.599182725, alpha: 1)))
                        .offset(x: -10)
                }
            }
            .frame(height: 150)
            
            HStack {
                Text(activity.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Spacer()
            }
            
            HStack {
                Text("\(activity.duration) MIN")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(isArrowPressed ? Color(#colorLiteral(red: 0.5081194639, green: 0.4898516536, blue: 0.7515105605, alpha: 1)) : .gray)
                    .scaleEffect(isArrowPressed ? 0.8 : 1.0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isArrowPressed)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(isArrowPressed ? 0.2 : 0.0))
                            .animation(.easeOut(duration: 0.2), value: isArrowPressed)
                    )
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                isArrowPressed = true
                                
                                withAnimation {
                                    activeSheet = .log
                                }
                                
                                // delay before animation is turned off
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isArrowPressed = false
                                }
                            }
                    )
                
                Image(systemName: isTrashPressed ? "trash.fill" : "trash")
                    .foregroundColor(isTrashPressed ? .red : .white)
                    .scaleEffect(isTrashPressed ? 0.8 : 1.0)
                    .animation(.spring(response: 0.2, dampingFraction: 0.5), value: isTrashPressed)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(Color.gray.opacity(isTrashPressed ? 0.2 : 0.0))
                            .animation(.easeOut(duration: 0.2), value: isTrashPressed)
                    )
                    .gesture(
                        TapGesture()
                            .onEnded { _ in
                                isTrashPressed = true
                                
                                withAnimation {
                                    activeSheet = .delete
                                }
                                
                                // delay before animation is turned off
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isTrashPressed = false
                                }
                            }
                    )

            }
            .offset(y: -10)
        }
        .sheet(item: $activeSheet) { item in
            switch item {
            case .log:
                LogActivityView(activity: activity,
                                isPresented: Binding(
                                    get: {activeSheet == .log},
                                    set: {if !$0 {activeSheet = nil}}
                                ),
                                duration: $logDuration,
                                description: $logDescription, overlayState: overlayState)
            case .delete:
                DeleteActivityView(activity: activity,
                                   isPresented: Binding(
                                    get: {activeSheet == .delete},
                                    set: {if !$0 {activeSheet = nil}}
                                   ),
                                   viewModel: viewModel)
            }
        }
        .cardStyle()
    }
}

//struct ActivityCardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleActivity = Activity(name: "Study Session", duration: 45, icon: "book", color: Color(#colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)), category: 2)
//        let overlayState = OverlayState()
//        let viewModel = TrackViewModel()
//        
//        return Group {
//            ActivityCardView(activity: sampleActivity, overlayState: overlayState, viewModel: viewModel)
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .previewDisplayName("Activity Card")
//            
//            ActivityCardView(activity: sampleActivity, overlayState: overlayState, viewModel: viewModel)
//                .previewLayout(.sizeThatFits)
//                .padding()
//                .onAppear {
//                    overlayState.displayOverlay()
//                }
//                .previewDisplayName("Activity Card with Overlay")
//        }
//    }
//}
