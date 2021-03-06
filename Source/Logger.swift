/*
 * LipikaEngine is a multi-codepoint, user-configurable, phonetic, Transliteration Engine.
 * Copyright (C) 2017 Ranganath Atreya
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 */

import Foundation

enum LoggerError: Error {
    case alreadyCapturing
}

public enum Level: String {
    case Debug = "Debug"
    case Warning = "Warning"
    case Error = "Error"
    case Fatal = "Fatal"
    
    private var weight: Int {
        switch self {
        case .Debug:
            return 0
        case .Warning:
            return 1
        case .Error:
            return 2
        case .Fatal:
            return 3
        }
    }
    
    static func < (lhs: Level, rhs: Level) -> Bool {
        return lhs.weight < rhs.weight
    }
    static func > (lhs: Level, rhs: Level) -> Bool {
        return lhs.weight > rhs.weight
    }
    static func >= (lhs: Level, rhs: Level) -> Bool {
        return lhs.weight >= rhs.weight
    }
    static func <= (lhs: Level, rhs: Level) -> Bool {
        return lhs.weight <= rhs.weight
    }
}

public final class Logger {
    public static let logLevelKey = "logLevel"
    public static let loggerInstanceKey = "logger"
    
    private var capture: [String]?
    private let minLevel = getThreadLocalData(key: logLevelKey) as? Level ?? .Warning
    private init() { }
    
    public static var log: Logger {
        var instance = getThreadLocalData(key: loggerInstanceKey) as? Logger
        if instance == nil {
            instance = Logger()
            setThreadLocalData(key: loggerInstanceKey, value: instance!)
        }
        return instance!
    }
    
    deinit {
        if let capture = self.capture {
            log(level: .Warning, message: "Log capture started but not ended with \(capture.count) log entries!")
        }
    }
    
    private func log(level: Level, message: @autoclosure() -> String) {
        if level < minLevel { return }
        let log = "[\(level.rawValue)] \(message())"
        NSLog(log)
        if var capture = self.capture {
            capture.append(log)
        }
    }
    
    public func debug(_ message: @autoclosure() -> String) {
        log(level: .Debug, message: message)
    }
    
    public func warning(_ message: @autoclosure() -> String) {
        log(level: .Warning, message: message)
    }

    public func error(_ message: @autoclosure() -> String) {
        log(level: .Error, message: message)
    }
    
    public func fatal(_ message: @autoclosure() -> String) {
        log(level: .Fatal, message: message)
    }
    
    public func startCapture() throws {
        if capture != nil {
            throw LoggerError.alreadyCapturing
        }
        capture = [String]()
    }
    
    public func endCapture() -> [String]? {
        let result = capture
        capture = nil
        return result
    }
}
