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
        let calendar = Calendar.current
        let defaultD = DateComponents(calendar: calendar,timeZone: TimeZone.current, hour: 12, minute: 0)
        selectedTime = calendar.date(from: defaultD)!
    }
    
    private func updateUIFromStatistics( statisticsCollection: HKStatisticsCollection) {
        
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
            VStack {
                List(steps, id: \.id) { step in
                    VStack(alignment: .leading) {
                        Text("\(step.count)").foregroundColor(step.count >= stepsGoal ? .green : .red)
                        Text(step.date, style: .date)
                            .opacity(0.5)
                    }
                }
//                .scaleEffect(x: 1, y: -1, anchor: .center)
//                .rotationEffect(.radians(.pi))
                NavigationLink(destination: SettingPage(selectedStart: $selectedTime, stepsGoal: $stepsGoal)) {
                    Text("Settings")
                }
//                Button("Test date button") {
//                    print(selectedTime)
//                }
                // Button("Notification Test Button") {NotificationManager.instance.scheduleNotification()}
            }
            .navigationTitle("Daily Steps Count")
        }
            .onAppear {
                print("On appear")
                if let healthStore = healthStore {
                    healthStore.requestAuthorization { success in
                        if success {
                            healthStore.calculateSteps { statisticsCollection in
                                if let statisticsCollection = statisticsCollection {
                                    // update the UI
                                    updateUIFromStatistics(statisticsCollection: statisticsCollection)
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
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
