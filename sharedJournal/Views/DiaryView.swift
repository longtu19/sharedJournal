//
//  DiaryView.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/DiaryView.swift
import SwiftUI
import PhotosUI

struct DiaryView: View {
    @StateObject private var store = DiaryStore()
    @State private var showNewPost = false
    @State private var newEntryText = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] = []
    @State private var selectedEntry: Binding<DiaryEntry>?

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Button(action: { showNewPost = true }) {
                    HStack {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.gray)
                        Text("What’s new?")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.4))
                    )
                    .padding(.horizontal)
                    .padding(.top)
                }

                ScrollView {
                    LazyVStack(alignment: .center, spacing: 16) {
                        ForEach($store.entries) { $entry in
                            VStack(spacing: 0) {
                                DiaryPostView(
                                    entry: $entry,
                                    onTapComment: { selectedEntry = $entry }
                                )
                                .padding(.horizontal)
                                .padding(.bottom, 12)
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.bottom)
                }
            }
            .navigationTitle("Our Diary")
            .navigationDestination(isPresented: Binding(
                get: { selectedEntry != nil },
                set: { if !$0 { selectedEntry = nil } }
            )) {
                if let entryBinding = selectedEntry {
                    DiaryPostDetailView(entry: entryBinding)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showNewPost) {
                NewPost(
                    newEntryText: $newEntryText,
                    selectedItems: $selectedItems,
                    selectedImageData: $selectedImageData,
                    onPost: {
                        store.addEntry(content: newEntryText, images: selectedImageData)
                        newEntryText = ""
                        selectedItems = []
                        selectedImageData = []
                        showNewPost = false
                    }
                )
            }
        }
    }
}
