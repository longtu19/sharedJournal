//
//  DateTimeAlgo.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Extensions/Date+TimeAgo.swift
import Foundation

extension Date {
    func timeAgo() -> String {
        let seconds = Int(Date().timeIntervalSince(self))
        let minutes = seconds / 60
        let hours = minutes / 60
        let days = hours / 24

        if seconds < 60 {
            return "just now"
        } else if minutes < 60 {
            return "\(minutes)m"
        } else if hours < 24 {
            return "\(hours)h"
        } else {
            return "\(days)d"
        }
    }
}
