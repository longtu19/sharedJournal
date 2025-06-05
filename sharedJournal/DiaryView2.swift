////
////  DiaryView.swift
////  sharedJournal
////
////  Created by Long Huynh on 5/30/25.
////
//
//import SwiftUI
//import PhotosUI
//
//struct DiaryEntry: Identifiable {
//    let id = UUID()
//    let date: Date
//    let username: String
//    let profileImage: Image
//    let content: String
//    let images: [Data]
//    var comments: [Comment] = []
//    var reactions: [String: Int] = [:] // e.g. ["❤️": 2, "😂": 1]
//    var userReaction: String? = nil
//}
//
//class DiaryStore: ObservableObject {
//    @Published var entries: [DiaryEntry] = []
//
//    func addEntry(content: String, images: [Data]) {
//        let newEntry = DiaryEntry(
//            date: Date(),
//            username: "longhuynh",
//            profileImage: Image(systemName: "person.crop.circle.fill"),
//            content: content,
//            images: images,
//            comments: []
//        )
//        entries.insert(newEntry, at: 0)
//    }
//}
//
//struct DiaryView: View {
//    @StateObject var store = DiaryStore()
//
//    // Sheet state
//    @State private var showNewPost = false
//    @State private var newEntryText = ""
//    @State private var selectedItems: [PhotosPickerItem] = []
//    @State private var selectedImageData: [Data] = []
//    @State private var selectedCommentingEntryID: UUID? = nil
//    @State private var newCommentText: String = ""
//    @FocusState private var isCommentFocused: Bool
//    
//    @State private var selectedEntry: Binding<DiaryEntry>? = nil
//
//
//    var body: some View {
//        NavigationStack {
//            VStack(alignment: .leading) {
//                Button(action: {
//                    showNewPost = true
//                }) {
//                    HStack {
//                        Image(systemName: "square.and.pencil")
//                            .foregroundColor(.gray)
//                        Text("What’s new?")
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding()
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.gray.opacity(0.4))
//                    )
//                    .padding(.horizontal)
//                    .padding(.top)
//                }
//                
//                ScrollView {
//                    LazyVStack(alignment: .center, spacing: 16) {
//                        ForEach($store.entries) { $entry in
//                            VStack(spacing:0){
//                                DiaryPostView(
//                                    entry: $entry,
//                                    isCommenting: selectedCommentingEntryID == entry.id,
//                                    newCommentText: $newCommentText,
//                                    onPostComment: {
//                                    selectedCommentingEntryID = nil
//                                    newCommentText = ""
//                                    },
//                                    onTapComment: {
//                                        selectedEntry = $entry
//                                    }
//                                )
//                                .padding(.horizontal)
//                                .padding(.bottom, 12)
//                                
//                                Divider()
//                                    .padding(.horizontal)
//                            }
//                        }
//                    }
//                    .padding(.bottom)
//                }
//
//            }
//            .navigationTitle("Our Diary")
//            .navigationDestination(isPresented: Binding(
//                get: { selectedEntry != nil },
//                set: { if !$0 { selectedEntry = nil } }
//            )) {
//                if let entryBinding = selectedEntry {
//                    DiaryDetailView(entry: entryBinding, newCommentText: $newCommentText)
//                }
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: {
//                        // Profile action
//                    }) {
//                        Image(systemName: "person.circle")
//                            .font(.title2)
//                    }
//                }
//            }
//            .sheet(isPresented: $showNewPost) {
//                NewPostPanel(
//                    newEntryText: $newEntryText,
//                    selectedItems: $selectedItems,
//                    selectedImageData: $selectedImageData,
//                    onPost: {
//                        store.addEntry(content: newEntryText, images: selectedImageData)
//                        newEntryText = ""
//                        selectedItems = []
//                        selectedImageData = []
//                        showNewPost = false
//                    }
//                )
//            }
//        }
//    }
//}
//
//struct NewPostPanel: View {
//    @Binding var newEntryText: String
//    @Binding var selectedItems: [PhotosPickerItem]
//    @Binding var selectedImageData: [Data]
//    var onPost: () -> Void
//    
//    @Environment(\.dismiss) var dismiss
//
//    var body: some View {
//            VStack {
//                
//                // Top title and Cancel button
//                HStack {
//                    Button("Cancel") {
//                        newEntryText = ""
//                        selectedItems = []
//                        selectedImageData = []
//                        dismiss()
//                    }
//                    .foregroundColor(.blue)
//
//                    Spacer()
//
//                    Text("New Diary")
//                        .font(.system(size: 18, weight: .regular))
//                        .foregroundColor(.primary)
//
//                    Spacer()
//
//                    // Empty to center the title visually
//                    Spacer().frame(width: 60)
//                }
//                .padding(.horizontal)
//                
//                TextEditor(text: $newEntryText)
//                    .frame(height: 150)
//                    .padding(.horizontal)
//
//                if !selectedImageData.isEmpty{
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        HStack {
//                            ForEach(selectedImageData, id: \.self) { data in
//                                if let uiImage = UIImage(data: data) {
//                                    Image(uiImage: uiImage)
//                                        .resizable()
//                                        .scaledToFill()
//                                        .frame(width: 100, height: 100)
//                                        .clipped()
//                                        .cornerRadius(8)
//                                }
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                }
//
//                HStack {
//                    PhotosPicker(
//                        selection: $selectedItems,
//                        matching: .images,
//                        photoLibrary: .shared()
//                    ) {
//                        Label("Select Photos", systemImage: "photo.on.rectangle")
//                    }
//                    .onChange(of: selectedItems) { newItems in
//                        Task {
//                            selectedImageData = []
//                            for item in newItems {
//                                if let data = try? await item.loadTransferable(type: Data.self) {
//                                    selectedImageData.append(data)
//                                }
//                            }
//                        }
//                    }
//                    
//                    Spacer()
//                    
//                    Button("Post") {
//                        onPost()
//                    }
//                    .disabled(newEntryText.trimmingCharacters(in: .whitespaces).isEmpty)
//                    .buttonStyle(.borderedProminent)
//                }
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//            .padding(.top)
//            .toolbar {
//                ToolbarItem(placement: .cancellationAction) {
//                    Button("Cancel") {
//                        newEntryText = ""
//                        selectedItems = []
//                        selectedImageData = []
//                        dismiss()
//                    }
//                }
//            }
//    }
//}
//
//
//extension Date {
//    func timeAgo() -> String {
//        let seconds = Int(Date().timeIntervalSince(self))
//        let minutes = seconds / 60
//        let hours = minutes / 60
//        let days = hours / 24
//
//        if seconds < 60 {
//            return "just now"
//        } else if minutes < 60 {
//            return "\(minutes)m"
//        } else if hours < 24 {
//            return "\(hours)h"
//        } else {
//            return "\(days)d"
//        }
//    }
//}
//
//struct Comment: Identifiable {
//    let id = UUID()
//    let username: String
//    let profileImage: Image
//    let content: String
//    let timestamp: Date
//}
//
//
//struct DiaryPostView: View {
//    @Binding var entry: DiaryEntry
//    var isCommenting: Bool
//    @Binding var newCommentText: String
//    var onPostComment: () -> Void
//    var onTapComment: () -> Void
//
//    @FocusState private var isCommentFocused: Bool
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            // Header
//            HStack(spacing: 8) {
//                entry.profileImage
//                    .resizable()
//                    .frame(width: 30, height: 30)
//                    .clipShape(Circle())
//
//                Text(entry.username)
//                    .font(.subheadline)
//                    .bold()
//
//                Text("\(entry.date.timeAgo())")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//            .padding(.bottom, 4)
//
//            // Images
//            if !entry.images.isEmpty {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(entry.images, id: \.self) { data in
//                            if let uiImage = UIImage(data: data) {
//                                Image(uiImage: uiImage)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 120, height: 120)
//                                    .clipped()
//                                    .cornerRadius(8)
//                            }
//                        }
//                    }
//                    .padding(.vertical, 4)
//                }
//            }
//
//            // Content
//            Text(entry.content)
//
//            // Reactions
//            HStack(spacing: 20) {
//                Menu {
//                    ForEach(["❤️", "😂", "😢", "🔥", "👍"], id: \.self) { emoji in
//                        Button {
//                            entry.userReaction = emoji
//                            entry.reactions[emoji, default: 0] += 1
//                        } label: {
//                            Text(emoji)
//                        }
//                    }
//                } label: {
//                    Label(entry.userReaction ?? "❤️", systemImage: "heart")
//                        .labelStyle(.iconOnly)
//                        .font(.title3)
//                }
//                .buttonStyle(PlainButtonStyle())
//
//                Button {
//                    onTapComment()
//                } label: {
//                    HStack(spacing: 4) {
//                        Image(systemName: "bubble.right")
//                            .font(.title3)
//                        if !entry.comments.isEmpty {
//                            Text("\(entry.comments.count)")
//                                .font(.caption)
//                        }
//                    }
//                }
//
//                Spacer()
//
//                if !entry.reactions.isEmpty {
//                    Text(entry.reactions.map { "\($0.key) \($0.value)" }.joined(separator: "  "))
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//            }
//            .padding(.top, 6)
//        }
//        .padding(.top, 8)
//    }
//}
//
//struct DiaryDetailView: View {
//    @Binding var entry: DiaryEntry
//    @Binding var newCommentText: String
//    @Environment(\.dismiss) var dismiss
//    @FocusState private var isCommentFocused: Bool
//    @State private var textEditorHeight: CGFloat = 50
//    
//    
//    @State private var localComments: [Comment] = []
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 16) {
//                // Reuse existing header/photo/content UI
//                DiaryPostHeader(entry: entry)
//
//                if !localComments.isEmpty {
//                    Divider()
//                    ForEach(localComments) { comment in
//                        HStack(alignment: .top, spacing: 10) {
//                            comment.profileImage
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .clipShape(Circle())
//
//                            VStack(alignment: .leading, spacing: 2) {
//                                HStack {
//                                    Text(comment.username)
//                                        .font(.footnote)
//                                        .bold()
//                                    Text("• \(comment.timestamp.timeAgo())")
//                                        .font(.caption2)
//                                        .foregroundColor(.gray)
//                                }
//                                Text(comment.content)
//                                    .font(.footnote)
//                            }
//                        }
//                    }
//                }
//
//                // Comment input box
//                 VStack(alignment: .leading, spacing: 8) {
//                     ZStack(alignment: .topLeading) {
//                         if newCommentText.isEmpty {
//                             Text("Add a comment")
//                                 .foregroundColor(.gray)
//                                 .padding(.horizontal, 8)
//                                 .padding(.vertical, 10)
//                                 .zIndex(1)
//                         }
//
//                         TextEditor(text: $newCommentText)
//                             .frame(height: 50, maxHeight: textEditorHeight)
//                             .padding(.horizontal, 4)
//                             .padding(.vertical, 4)
//                             .background(Color.clear)
//                             .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.4)))
//                             .opacity(newCommentText.isEmpty ? 0.75 : 1.0)
//                             .focused($isCommentFocused)
//                             .onChange(of: newCommentText) { _ in
//                                 // Calculate the height based on content
//                                 let textView = UITextView()
//                                 textView.text = newCommentText
//                                 textView.font = .systemFont(ofSize: 16) // Match TextEditor font
//                                 let size = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 16, height: .greatestFiniteMagnitude))
//                                 textEditorHeight = max(50, size.height + 8) // Ensure minimum height and add padding
//                             }
//                     }
//                     .padding()
//                     .onAppear {
//                         isCommentFocused = true
//                     }
//
//                     HStack {
//                         Spacer()
//                         Button("Post") {
//                             let trimmed = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
//                             guard !trimmed.isEmpty else { return }
//
//                             
//                             let newComment = Comment(
//                                 username: "you",
//                                 profileImage: Image(systemName: "person.fill"),
//                                 content: trimmed,
//                                 timestamp: Date()
//                             )
//                             
//                             localComments.append(newComment)
//                             entry.comments = localComments
//
//                             newCommentText = ""
//                             isCommentFocused = false
//                         }
//                         .buttonStyle(.borderedProminent)
//                     }
//                 }
//                
//            }
//            .padding()
//        }
//        .navigationTitle("Post & Comments")
//        .navigationBarTitleDisplayMode(.inline)
//        .onAppear {
//            // 👇 Sync initial state
//            localComments = entry.comments
//        }
//    }
//}
//
//struct DiaryPostHeader: View {
//    var entry: DiaryEntry
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            HStack(spacing: 8) {
//                entry.profileImage
//                    .resizable()
//                    .frame(width: 30, height: 30)
//                    .clipShape(Circle())
//
//                Text(entry.username)
//                    .font(.subheadline)
//                    .bold()
//
//                Text("\(entry.date.timeAgo())")
//                    .font(.caption)
//                    .foregroundColor(.gray)
//            }
//
//            if !entry.images.isEmpty {
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 10) {
//                        ForEach(entry.images, id: \.self) { data in
//                            if let uiImage = UIImage(data: data) {
//                                Image(uiImage: uiImage)
//                                    .resizable()
//                                    .scaledToFill()
//                                    .frame(width: 120, height: 120)
//                                    .clipped()
//                                    .cornerRadius(8)
//                            }
//                        }
//                    }
//                }
//            }
//
//            if !entry.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
//                Text(entry.content)
//            }
//        }
//    }
//}
//
//
//
