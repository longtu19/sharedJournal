//
//  DiaryStore.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Models/DiaryStore.swift
import SwiftUI

class DiaryStore: ObservableObject {
    @Published var entries: [DiaryEntry] = []

    func addEntry(content: String, images: [Data]) {
        let newEntry = DiaryEntry(
            date: Date(),
            username: "longhuynh",
            profileImage: Image(systemName: "person.crop.circle.fill"),
            content: content,
            images: images,
            comments: [],
            reactions: [:],
            userReaction: nil
        )
        entries.insert(newEntry, at: 0)
    }
}
