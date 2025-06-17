//
//  DiaryStore.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Models/DiaryStore.swift
import SwiftUI

class DiaryStore: ObservableObject {
    @Published var entryModels: [DiaryEntryModel] = []

    func addEntry(content: String, images: [Data]) {
        let newEntry = DiaryEntry(
            id: UUID().uuidString, // Unique string ID
            username: "longhuynh",
            profileImageName: "person.crop.circle.fill",
            content: content,
            images: images,
            date: Date(),
            reactions: [:],
            comments: []
        )
        
        let model = DiaryEntryModel(entry: newEntry)
        entryModels.insert(model, at: 0)
    }
}
