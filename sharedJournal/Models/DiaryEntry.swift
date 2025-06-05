//
//  DiaryEntry.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Models/DiaryEntry.swift
import SwiftUI

struct DiaryEntry: Identifiable {
    let id = UUID()
    let date: Date
    let username: String
    let profileImage: Image
    let content: String
    let images: [Data]
    var comments: [Comment]
    var reactions: [String: Int]
    var userReaction: String?
}

struct Comment: Identifiable {
    let id = UUID()
    let username: String
    let profileImage: Image
    let content: String
    let timestamp: Date
}
