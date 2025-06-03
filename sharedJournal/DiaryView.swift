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
    let username: String
    let profileImage: Image
    let content: String
    let images: [Data]
}

class DiaryStore: ObservableObject {
    @Published var entries: [DiaryEntry] = []

    func addEntry(content: String, images: [Data]) {
        let newEntry = DiaryEntry(
            date: Date(),
            username: "longhuynh",
            profileImage: Image(systemName: "person.crop.circle.fill"),
            content: content,
            images: images)
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
                        HStack(spacing: 8) {
                            entry.profileImage
                                .resizable()
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                            
                            Text(entry.username)
                                .font(.subheadline)
                                .bold()
                            Text("\(entry.date.timeAgo())")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.bottom, 4)

                        

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
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
            VStack {
                
                // Top title and Cancel button
                HStack {
                    Button("Cancel") {
                        newEntryText = ""
                        selectedItems = []
                        selectedImageData = []
                        dismiss()
                    }
                    .foregroundColor(.blue)

                    Spacer()

                    Text("New Diary")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundColor(.primary)

                    Spacer()

                    // Empty to center the title visually
                    Spacer().frame(width: 60)
                }
                .padding(.horizontal)
                
                TextEditor(text: $newEntryText)
                    .frame(height: 150)
                    .padding(.horizontal)

                if !selectedImageData.isEmpty{
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
                }

                HStack {
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
                    
                    Spacer()
                    
                    Button("Post") {
                        onPost()
                    }
                    .disabled(newEntryText.trimmingCharacters(in: .whitespaces).isEmpty)
                    .buttonStyle(.borderedProminent)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.top)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        newEntryText = ""
                        selectedItems = []
                        selectedImageData = []
                        dismiss()
                    }
                }
            }
    }
}


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

