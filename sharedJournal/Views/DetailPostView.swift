//
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/DetailPostView.swift
import SwiftUI

struct DetailPostView: View {
    @ObservedObject var model: DiaryEntryModel
    


    @Environment(\.dismiss) private var dismiss
    @State private var newCommentText: String = ""
    @State private var textEditorHeight: CGFloat = 50
    @FocusState private var isCommentFocused: Bool
    @State private var showReactionPicker = false
    @State private var reactionAnchor: CGPoint = .zero
    
    init(model: DiaryEntryModel) {
        self.model = model
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

    }

    private var contentView: some View {
        ZStack {
            VStack(alignment: .leading) {
                DiaryPostHeader(entry: model.entry)
                reactionsSection
                commentsSection
                commentInputSection
            }

            if showReactionPicker {
                reactionPickerOverlay
            }
        }
        .coordinateSpace(name: "ReactionSpace")
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            withAnimation {
                model.entry.reactions["❤️", default: 0] += 1
                model.entry.userReaction = "❤️"
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
            .onTapGesture {
                withAnimation {
                    showReactionPicker = false
                }
            }
    }

    // Reaction picker content
    private var reactionPickerContent: some View {
        HStack(spacing: 2) {
            ForEach(["❤️", "😂", "😢", "🔥", "👍"], id: \.self) { emoji in
                Button {
                    model.entry.reactions[emoji, default: 0] += 1
                    model.entry.userReaction = emoji
                    withAnimation { showReactionPicker = false }
                } label: {
                    Text(emoji)
                        .font(.title3)
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(8)
                }
            }
        }
        .frame(width: 200, height: 50)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    private var reactionsSection: some View {
        HStack(spacing: 20) {
            HeartButton(
                userReaction: $model.entry.userReaction,
                reactions: $model.entry.reactions,
                onShowPicker: { point in
                    self.reactionAnchor = point
                    withAnimation { showReactionPicker = true }
                },
                onHidePicker: {
                    withAnimation { showReactionPicker = false }
                }
            )

            
            HStack(spacing: 4) {
                Image(systemName: "bubble.left")
                    .font(.title3)
                if model.entry.comments.count > 0 {
                    Text("\(model.entry.comments.count)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            if !model.entry.reactions.isEmpty {
                Text(model.entry.reactions.map { "\($0.key) \($0.value)" }.joined(separator: "  "))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 6)
    }

    private var commentsSection: some View {
        
        Group {
            if !model.entry.comments.isEmpty {
                Divider()
                ForEach(model.entry.comments) { comment in
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

                    model.entry.comments.append(newComment)
                    newCommentText = ""
                    isCommentFocused = false
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
