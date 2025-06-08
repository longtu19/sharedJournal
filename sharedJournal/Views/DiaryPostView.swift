//
//  DiaryPostView.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/DiaryPostView.swift
import SwiftUI

struct DiaryPostView: View {
    @Binding var entry: DiaryEntry
    var onTapComment: () -> Void
    @State private var showReactionPicker = false
    @State private var reactionAnchor: CGPoint = .zero

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                VStack(alignment: .leading) {
                    DiaryPostHeader(entry: entry)
                    HStack(spacing: 20) {
                        Label(entry.userReaction ?? "❤️", systemImage: "heart")
                            .labelStyle(.iconOnly)
                            .font(.title3)
                            .onLongPressGesture {
                                withAnimation {
                                    showReactionPicker = true
                                    reactionAnchor = CGPoint(x: 40, y: 40)
                                }
                            }

                        Button(action: onTapComment) {
                            HStack(spacing: 4) {
                                Image(systemName: "bubble.right").font(.title3)
                                if !entry.comments.isEmpty {
                                    Text("\(entry.comments.count)").font(.caption)
                                }
                            }
                        }

                        Spacer()

                        if !entry.reactions.isEmpty {
                            Text(entry.reactions.map { "\($0.key) \($0.value)" }.joined(separator: "  "))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 6)
                }
                .onTapGesture(count: 2) {
                    withAnimation {
                        entry.reactions["❤️", default: 0] += 1
                        entry.userReaction = "❤️"
                    }
                }

                if showReactionPicker {
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            withAnimation {
                                showReactionPicker = false
                            }
                        }
                        .overlay(
                            GeometryReader { geometry in
                                HStack(spacing: 10) {
                                    ForEach(["❤️", "😂", "😢", "🔥", "👍"], id: \.self) { emoji in
                                        Button {
                                            withAnimation {
                                                entry.reactions[emoji, default: 0] += 1
                                                entry.userReaction = emoji
                                                showReactionPicker = false
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
                                .position(clampedReactionAnchor(from: reactionAnchor, in: geometry.size))
                            }
                        )
                }
            }
        }
        .padding(.top, 8)
    }
}


