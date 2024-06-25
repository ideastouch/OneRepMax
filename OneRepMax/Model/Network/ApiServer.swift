//
//  ApiServer.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//
import Foundation
import NetworkKit

extension String {
    var googleFileIdToURL: String {
        let urlString = "https://drive.google.com/uc?export=download&id=\(self)"
        return urlString
    }
}

actor ApiServer {
    func refresh(_ url:String) async throws -> [ResponseWorkout] {
        let responseWorkouts = try await Service().fetchWorkouts(url: url)
        return responseWorkouts
    }
}
