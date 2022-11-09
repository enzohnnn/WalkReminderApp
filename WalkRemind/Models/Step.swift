//
//  Step.swift
//  WalkRemind
//
//  Created by Enzo Han on 11/8/22.
//

import Foundation


struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
}
