//
//  DiaryEntry.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//


// Models/DiaryEntry.swift
import SwiftUI

struct DiaryEntry: Identifiable, Codable, Equatable {
    let id: String
    let username: String
    let profileImageName: String
    let content: String
    let images: [Data]
    let date: Date
    var reactions: [String: Int]
    var comments: [Comment]
    var userReaction: String?

    enum CodingKeys: String, CodingKey {
        case id, username, profileImageName, content, images, date, reactions, comments, userReaction
    }

    // Computed property to create Image from profileImageName
    var profileImage: Image {
        Image(systemName: profileImageName) // Use system image, adjust if using custom images
    }

    // Implement Equatable conformance
    static func ==(lhs: DiaryEntry, rhs: DiaryEntry) -> Bool {
        return lhs.id == rhs.id &&
               lhs.username == rhs.username &&
               lhs.profileImageName == rhs.profileImageName &&
               lhs.content == rhs.content &&
               lhs.images == rhs.images &&
               lhs.date == rhs.date &&
               lhs.reactions == rhs.reactions &&
               lhs.comments == rhs.comments &&
               lhs.userReaction == rhs.userReaction
    }
}

struct Comment: Identifiable, Codable, Equatable {
    let id: String
    let username: String
    let profileImageName: String
    let content: String
    let timestamp: Date

    init(id: String = UUID().uuidString, username: String, profileImageName: String, content: String, timestamp: Date) {
        self.id = id
        self.username = username
        self.profileImageName = profileImageName
        self.content = content
        self.timestamp = timestamp
    }

    // Computed property to create Image from profileImageName
    var profileImage: Image {
        Image(systemName: profileImageName) // Use system image, adjust if using custom images
    }

    enum CodingKeys: String, CodingKey {
        case id, username, profileImageName, content, timestamp
    }

    // Implement Equatable conformance
    static func ==(lhs: Comment, rhs: Comment) -> Bool {
        return lhs.id == rhs.id &&
               lhs.username == rhs.username &&
               lhs.profileImageName == rhs.profileImageName &&
               lhs.content == rhs.content &&
               lhs.timestamp == rhs.timestamp
    }
}


class DiaryEntryModel: ObservableObject, Identifiable {
    @Published var entry: DiaryEntry
    var id: String { entry.id }

    init(entry: DiaryEntry) {
        self.entry = entry
    }
}
