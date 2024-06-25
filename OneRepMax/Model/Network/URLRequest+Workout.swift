//
//  URLRequest+Company.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//


import Foundation

extension URLRequest {
    struct Workout: Codable {
        let date: Date        // DateFormatter: "MMM dd yyyy", eg "Oct 11 2020"
        let exercise: String  // "Back Squat"
        let repetitions: UInt8
        let weight: UInt8
    }
}
