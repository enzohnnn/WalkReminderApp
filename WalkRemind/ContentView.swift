//
//  ContentView.swift
//  WalkRemind
//
//  Created by Enzo Han on 11/8/22.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    
    private var healthStore: HealthStore?
    private var notificationManager: NotificationManager?
    @State private var steps: [Step] = [Step]()
    @State var selectedTime: Date = Date()
    @State var stepsGoal: Int = 1000
    
    init() {
        healthStore = HealthStore()
        notificationManager = NotificationManager()
        // BUG: Initializer is overwritten and is default current not 12:00
        let calendar = Calendar.current
        let defaultD = DateComponents(calendar: calendar,timeZone: TimeZone.current, hour: 12, minute: 0)
        selectedTime = calendar.date(from: defaultD)!
    }
    
    private func updateUIFromStatistics( statisticsCollection: HKStatisticsCollection) {
        print("Resetting UI")
        steps = [Step]()
        let startDate = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        let endDate = Date()
        
        statisticsCollection.enumerateStatistics(from: startDate, to: endDate) {
            (statistics, stop) in
            let count = statistics.sumQuantity()?.doubleValue(for: .count())
            
            let step = Step(count: Int(count ?? 0), date: statistics.startDate)
            steps.append(step)
        }
        steps = steps.reversed()
    }
    
    var body: some View {
        
        NavigationView {
            ZStack {
                VStack {
                    List(steps, id: \.id) { step in
                        VStack(alignment: .leading) {
                            Text("\(step.count)").foregroundColor(step.count >= stepsGoal ? .green : .red)
                            Text(step.date, style: .date).isCurrentDay(step.date).opacity(0.5)
                        }
                    }
                    NavigationLink(destination: SettingPage(selectedStart: $selectedTime, stepsGoal: $stepsGoal)) {
                        Text("Settings")
                    }
                }
                }.navigationTitle("Daily Steps Count").background(SwiftUI.Color.blue.opacity(0.1).edgesIgnoringSafeArea(.all)).onAppear {
                print("On appear")
                    if let healthStore = healthStore {
                        healthStore.requestAuthorization { success in
                            if success {
                                healthStore.calculateSteps { statisticsCollection in
                                    if let statisticsCollection = statisticsCollection {
                                        // update the UI
                                        updateUIFromStatistics(statisticsCollection: statisticsCollection)
//                                        if steps.isEmpty {
//                                            print("isempty")
//                                            updateUIFromStatistics(statisticsCollection: statisticsCollection)
//                                        }
                                    }
                                }
                            } else {
                                print("Failed step authorization")
                            }
                        }
                }
                if let notificationManager = notificationManager {
                    notificationManager.requestAuthorization()
                }
                UIApplication.shared.applicationIconBadgeNumber = 0
                print(Date().formatted(Date.FormatStyle().day()))
                    
                }
        }
    }
}

// https://swiftwombat.com/how-to-apply-text-modifiers-based-on-the-swiftui-view-state/
extension Text {
    
    // Modifier to bold only the current day
    func isCurrentDay(_ day: Date) -> Text {
        if(Date().formatted(Date.FormatStyle().day()) == day.formatted(Date.FormatStyle().day())) {
            return bold()
        } else {
            return self
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
