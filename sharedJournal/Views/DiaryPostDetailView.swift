//
//  DiaryPostDetailView.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/DiaryPostDetailView.swift
import SwiftUI

struct DiaryPostDetailView: View {
    @Binding var entry: DiaryEntry
    @Environment(\.dismiss) private var dismiss
    @State private var newCommentText: String = ""
    @State private var textEditorHeight: CGFloat = 50
    @FocusState private var isCommentFocused: Bool
    @State private var localComments: [Comment]
    @State private var localReactions: [String: Int]
    @State private var showReactionPicker = false
    @State private var reactionAnchor: CGPoint = .zero

    init(entry: Binding<DiaryEntry>) {
        self._entry = entry
        self._localComments = State(initialValue: entry.wrappedValue.comments)
        self._localReactions = State(initialValue: entry.wrappedValue.reactions)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                contentView
            }
            .padding()
        }
        .navigationTitle("Post & Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: entry) { newEntry in
            localComments = newEntry.comments
            localReactions = newEntry.reactions
        }
    }

    private var contentView: some View {
        ZStack {
            VStack(alignment: .leading) {
                DiaryPostHeader(entry: entry)
                reactionsSection
                commentsSection
                commentInputSection
            }
            .onTapGesture(count: 2) {
                withAnimation {
                    localReactions["❤️", default: 0] += 1
                    var updatedEntry = entry
                    updatedEntry.reactions = localReactions
                    updatedEntry.userReaction = "❤️"
                    entry = updatedEntry
                    print("Double-tap: Updated reactions: \(entry.reactions)")
                }
            }

            if showReactionPicker {
                reactionPickerOverlay
            }
        }
    }

    // reaction picker overlay
    private var reactionPickerOverlay: some View {
        GeometryReader { geometry in
            backgroundOverlay
                .overlay(
                    reactionPickerContent
                        .position(clampedReactionAnchor(from: reactionAnchor, in: geometry.size))
                )
        }
    }

    // Background overlay
    private var backgroundOverlay: some View {
        Color.black.opacity(0.3)
            .edgesIgnoringSafeArea(.all)
            .onTapGesture {
                withAnimation {
                    showReactionPicker = false
                }
            }
    }

    // Reaction picker content
    private var reactionPickerContent: some View {
        HStack(spacing: 10) {
            ForEach(["❤️", "😂", "😢", "🔥", "👍"], id: \.self) { emoji in
                Button {
                    withAnimation {
                        localReactions[emoji, default: 0] += 1
                        var updatedEntry = entry
                        updatedEntry.reactions = localReactions
                        updatedEntry.userReaction = emoji
                        entry = updatedEntry
                        showReactionPicker = false
                        print("Picker: Updated reactions: \(entry.reactions)")
                    }
                } label: {
                    Text(emoji)
                        .font(.title3)
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
        }
        .frame(width: 300, height: 60)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private var reactionsSection: some View {
        HStack(spacing: 20) {
            Label(entry.userReaction ?? "❤️", systemImage: "heart")
                .labelStyle(.iconOnly)
                .font(.title3)
                .onLongPressGesture {
                    withAnimation {
                        showReactionPicker = true
                        reactionAnchor = CGPoint(x: UIScreen.main.bounds.midX, y: 80)
                    }
                }
            
            HStack(spacing: 4) {
                Image(systemName: "bubble.left")
                    .font(.title3)
                if localComments.count > 0 {
                    Text("\(localComments.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            if !localReactions.isEmpty {
                Text(localReactions.map { "\($0.key) \($0.value)" }.joined(separator: "  "))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 6)
    }

    private var commentsSection: some View {
        
        Group {
            if !localComments.isEmpty {
                Divider()
                ForEach(localComments) { comment in
                    CommentRow(comment: comment)
                }
            }
        }
    }

    private var commentInputSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                if newCommentText.isEmpty {
                    Text("Add a comment")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 10)
                        .zIndex(1)
                }

                TextEditor(text: $newCommentText)
                    .frame(minHeight: 50, maxHeight: textEditorHeight)
                    .padding(.horizontal, 4)
                    .padding(.vertical, 4)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.4))
                    )
                    .opacity(newCommentText.isEmpty ? 0.75 : 1.0)
                    .focused($isCommentFocused)
                    .onChange(of: newCommentText) { _ in
                        let textView = UITextView()
                        textView.text = newCommentText
                        textView.font = .systemFont(ofSize: 16)
                        let size = textView.sizeThatFits(
                            CGSize(width: UIScreen.main.bounds.width - 16, height: .greatestFiniteMagnitude)
                        )
                        textEditorHeight = max(50, size.height + 8)
                    }
            }
            .padding(.top)
            .onAppear {
                isCommentFocused = true
            }

            HStack {
                Spacer()
                Button("Post") {
                    let trimmed = newCommentText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }

                    let newComment = Comment(
                        username: "you",
                        profileImageName: "person.crop.circle.fill",
                        content: trimmed,
                        timestamp: Date()
                    )

                    localComments.append(newComment)
                    var updatedEntry = entry
                    updatedEntry.comments = localComments
                    entry = updatedEntry
                    newCommentText = ""
                    isCommentFocused = false
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
