//
//  Logging.swift
//  Employees
//
//  Created by Gustavo Halperin on 5/20/24.
//

import OSLog

enum LoggerFactory: String {
    case setup = "Setup"
    case dataModel = "DataModel"
    case networking = "Networking"
    
    static let subsystem = "com.yahoo.employees"
    static let shared: Logger = {
        Logger(subsystem: subsystem,
               category: "App")
    }()
    static func category(_ category: LoggerFactory) -> Logger {
        Logger(subsystem: subsystem,
               category: category.rawValue)
    }
}
