//
//  URLRequest+Workout.swift
//  OneRepMax
//
//  Created by Gustavo Halperin on 6/20/24.
//


import Foundation
import NetworkKit

extension URLRequest {
    struct WorkoutsHistorical {
        let url: String
    }
}

extension URLRequest.WorkoutsHistorical: URLRequestService {
    var httpMethod: NetworkKit.HTTMethodValue { .get }
    
    func modifierHeader(_ request: URLRequest) -> URLRequest {
        var request = request
        request.setValue("text/html", forHTTPHeaderField: "Content-Type")
        request.setValue("text/html", forHTTPHeaderField: "Accept")
        return request
    }
}

extension URLRequest.WorkoutsHistorical {
    struct Response {
        struct Workout: Codable {
            let date: Date        // DateFormatter: "MMM dd yyyy", eg "Oct 11 2020"
            let exercise: String  // "Back Squat"
            let repetitions: UInt8
            let weight: UInt16
        }
        enum WorkoutError: Error {
            case DataInvalid
            case ComponentsInvalidNumber(number:Int)
            case DateStingInvalid(dateString:String)
            case UIntInvalidFormat(component:String, value:String)
        }
    }
    static func workouts(contentsOf content: String) throws -> [ResponseWorkout] {
        let lines: [String] = content.components( separatedBy: "\n" )
        var errors: [URLRequest.WorkoutsHistorical.Response.WorkoutError] = .init()
        var workouts: [ResponseWorkout] = .init()
        for line in lines {
            do {
                let workout = try ResponseWorkout(csvLine: line)
                workouts.append(workout)
            } catch let error as URLRequest.WorkoutsHistorical.Response.WorkoutError {
                errors.append(error)
            } catch {
                throw error
            }
        }
        return workouts
    }
}

extension URLRequest.WorkoutsHistorical.Response.Workout {
    init(csvLine: String) throws {
        let components = csvLine
            .components( separatedBy: "," )
            .map { $0.trimmingCharacters(in: .whitespaces) }
        guard components.count == 4 else {
            throw URLRequest.WorkoutsHistorical.Response.WorkoutError
                .ComponentsInvalidNumber(number: components.count)
        }
        let dateString = components[0]
        let exercise = components[1]
        let repetitionsString = components[2]
        let weightString = components[3]
        
        guard let date = URLRequest.WorkoutsHistorical.Response.Workout
            .date(from: dateString) else {
            throw URLRequest.WorkoutsHistorical.Response.WorkoutError
                .DateStingInvalid(dateString: dateString)
        }
        guard let repetitions: UInt8 = .init(repetitionsString) else {
            throw URLRequest.WorkoutsHistorical.Response.WorkoutError
                .UIntInvalidFormat(component: "repetitions",
                                   value: repetitionsString)
        }
        guard let weight: UInt16 = .init(weightString) else {
            throw URLRequest.WorkoutsHistorical.Response.WorkoutError
                .UIntInvalidFormat(component: "weight",
                                   value: weightString)
        }
        self.date = date
        self.exercise = exercise
        self.repetitions = repetitions
        self.weight = weight
    }
}

typealias ResponseWorkout = URLRequest.WorkoutsHistorical.Response.Workout

extension URLRequest.WorkoutsHistorical.Response.Workout {
    static private let dateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd yyyy"
        return dateFormatter
    }()
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }
    static func date(from dateString: String) -> Date? {
        dateFormatter.date(from: dateString)
    }
}

extension Service {
    func fetchWorkouts(url:String) async throws -> [ResponseWorkout] {
        let requestService = URLRequest.WorkoutsHistorical(url: url)
        let request = try URLRequest(requestService)
        
        let (data, _) = try await self.callService(request, withCache: true)
        guard let content = String(data: data, encoding: .utf8) else {
            throw URLRequest.WorkoutsHistorical.Response.WorkoutError.DataInvalid
        }
        return try URLRequest.WorkoutsHistorical.workouts(contentsOf: content)
    }
}
