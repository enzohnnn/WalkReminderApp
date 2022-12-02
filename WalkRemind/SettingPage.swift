//
//  SettingPage.swift
//  WalkRemind
//
//  Created by Enzo Han on 11/29/22.
//

import SwiftUI

struct SettingPage: View {
    
    @State var hours: Int = 0
    @State var minutes: Int = 0
    @Binding var selectedStart: Date
    @Binding var stepsGoal: Int
    @State private var presentAlert = false
    
    var body: some View {
        VStack {
//            HStack {
//                Picker("", selection: $hours){
//                    ForEach(0..<24, id: \.self) { i in
//                        Text("\(i) hours").tag(i)
//                    }
//                }.pickerStyle(WheelPickerStyle())
//                Picker("", selection: $minutes){
//                    ForEach(0..<60, id: \.self) { i in
//                        Text("\(i) min").tag(i)
//                    }
//                }.pickerStyle(WheelPickerStyle())
//            }.padding(.all)
            HStack {
                Text("Steps Goal:")
                TextField("Enter your steps goal: ", value: $stepsGoal, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .keyboardType(.decimalPad)
            }
            .padding(.horizontal)
            DatePicker("Select Notification Time:", selection: $selectedStart, displayedComponents: .hourAndMinute)
                .datePickerStyle(CompactDatePickerStyle())
                .padding(.horizontal)
            Button("Apply") {
                NotificationManager.instance.scheduleNotification(scheduleTime: selectedStart)
                presentAlert = true
            }.alert(isPresented: $presentAlert) {
                Alert(title: Text("Success!"), message: Text("Alert scheduled."))
            }
        }.padding(.horizontal)
            .onAppear() {
                print("Opening Page with selectedStart @: \(selectedStart)")
            }
    }
}

struct SettingPage_Previews: PreviewProvider {
    static var previews: some View {
        SettingPage(selectedStart: .constant(Date()), stepsGoal: .constant(1000))
    }
}
