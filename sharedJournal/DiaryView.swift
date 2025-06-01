//
//  DiaryView.swift
//  sharedJournal
//
//  Created by Long Huynh on 5/30/25.
//

import SwiftUI
import PhotosUI

struct DiaryEntry: Identifiable {
    let id = UUID()
    let date: Date
    let content: String
    let images: [Data]
}

class DiaryStore: ObservableObject {
    @Published var entries: [DiaryEntry] = []

    func addEntry(content: String, images: [Data]) {
        let newEntry = DiaryEntry(date: Date(), content: content, images: images)
        entries.insert(newEntry, at: 0)
    }
}

struct DiaryView: View {
    @StateObject var store = DiaryStore()

    // Sheet state
    @State private var showNewPost = false
    @State private var newEntryText = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImageData: [Data] = []

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Button(action: {
                    showNewPost = true
                }) {
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
                    .padding()
                }

                List(store.entries) { entry in
                    VStack(alignment: .leading) {
                        Text(entry.date, style: .date)
                            .font(.caption)
                            .foregroundColor(.gray)

                        

                        // Show photos horizontally (if any)
                        if !entry.images.isEmpty {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(entry.images, id: \.self) { data in
                                        if let uiImage = UIImage(data: data) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 120, height: 120)
                                                .clipped()
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        Text(entry.content)
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle("Our Diary")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        // Profile action
                    }) {
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $showNewPost) {
                NewPostPanel(
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

struct NewPostPanel: View {
    @Binding var newEntryText: String
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var selectedImageData: [Data]
    var onPost: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $newEntryText)
                    .frame(height: 150)
                    .border(Color.gray)
                    .padding()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImageData, id: \.self) { data in
                            if let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                PhotosPicker(
                    selection: $selectedItems,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select Photos", systemImage: "photo.on.rectangle")
                }
                .onChange(of: selectedItems) { newItems in
                    Task {
                        selectedImageData = []
                        for item in newItems {
                            if let data = try? await item.loadTransferable(type: Data.self) {
                                selectedImageData.append(data)
                            }
                        }
                    }
                }
                .padding()

                Button("Post") {
                    onPost()
                }
                .disabled(newEntryText.trimmingCharacters(in: .whitespaces).isEmpty)
                .buttonStyle(.borderedProminent)
                .padding(.bottom)
            }
            .navigationTitle("New Entry")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        newEntryText = ""
                        selectedItems = []
                        selectedImageData = []
                        UIApplication.shared.windows.first?.rootViewController?.dismiss(animated: true)
                    }
                }
            }
        }
    }
}

