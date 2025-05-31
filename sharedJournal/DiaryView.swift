//
//  DiaryView.swift
//  sharedJournal
//
//  Created by Long Huynh on 5/30/25.
//

import SwiftUI

struct DiaryEntry: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let content: String
}

class DiaryStore: ObservableObject {
    @Published var entries: [DiaryEntry] = []

    func addEntry(content: String) {
        let newEntry = DiaryEntry(date: Date(), content: content)
        entries.insert(newEntry, at: 0)
    }
}

struct DiaryView: View {
    @StateObject var store = DiaryStore()
    @State private var newEntry = ""

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $newEntry)
                    .frame(height: 150)
                    .border(.gray)
                    .padding()

                Button("Add Entry") {
                    store.addEntry(content: newEntry)
                    newEntry = ""
                }
                .disabled(newEntry.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding()

                List(store.entries) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text(entry.content)
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle("Our Diary")
        }
    }
}

