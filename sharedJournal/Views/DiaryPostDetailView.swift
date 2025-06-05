//
//  DiaryPostDetailView.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/DiaryDetailView.swift
import SwiftUI

struct DiaryPostDetailView: View {
    @Binding var entry: DiaryEntry
    @Environment(\.dismiss) private var dismiss
    @State private var newCommentText: String = ""
    @State private var textEditorHeight: CGFloat = 50
    @FocusState private var isCommentFocused: Bool
    @State private var localComments: [Comment]

    init(entry: Binding<DiaryEntry>) {
        self._entry = entry
        self._localComments = State(initialValue: entry.wrappedValue.comments)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                DiaryPostHeader(entry: entry)
                commentsSection
                commentInputSection
            }
            .padding()
        }
        .navigationTitle("Post & Comments")
        .navigationBarTitleDisplayMode(.inline)
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
                        profileImage: Image(systemName: "person.fill"),
                        content: trimmed,
                        timestamp: Date()
                    )

                    localComments.append(newComment)
                    entry.comments = localComments
                    newCommentText = ""
                    isCommentFocused = false
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
