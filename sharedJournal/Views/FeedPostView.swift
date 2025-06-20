//
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/FeedPostView.swift
import SwiftUI

struct FeedPostView: View {
    @ObservedObject var model: DiaryEntryModel
    var onTapComment: () -> Void
    @State private var showReactionPicker = false
    @State private var reactionAnchor: CGPoint = .zero
    @State private var didLongPress = false

    private let pickerSpacing: CGFloat = 8

    var body: some View {
        ZStack {
            postContent
                .coordinateSpace(name: "ReactionSpace")

            if showReactionPicker {
                reactionPickerOverlay
            }
        }
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            withAnimation {
                model.entry.reactions["❤️", default: 0] += 1
                model.entry.userReaction = "❤️"
            }
        }
    }

    private var postContent: some View {
        VStack(alignment: .leading) {
            DiaryPostHeader(entry: model.entry)

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

                Button(action: onTapComment) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right").font(.title3)
                        if !model.entry.comments.isEmpty {
                            Text("\(model.entry.comments.count)").font(.caption)
                        }
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
        .padding(.top, 8)
    }

    private var reactionPickerOverlay: some View {
        GeometryReader { geometry in
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation { showReactionPicker = false }
                }
                .overlay(
                    HStack(spacing: 2) {
                        ForEach(["❤️", "😂", "😢", "🔥", "👍"], id: \.self) { emoji in
                            Button {
                                withAnimation {
                                    model.entry.reactions[emoji, default: 0] += 1
                                    model.entry.userReaction = emoji
                                    showReactionPicker = false
                                }
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
                    .position(clampedReactionAnchor(from: reactionAnchor, in: geometry.size))
                )
        }
    }
}
