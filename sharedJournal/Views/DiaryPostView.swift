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

    var body: some View {
        VStack(alignment: .leading) {
            DiaryPostHeader(entry: entry)

            HStack(spacing: 20) {
                Menu {
                    ForEach(["❤️", "😂", "😢", "🔥", "👍"], id: \.self) { emoji in
                        Button {
                            entry.userReaction = emoji
                            entry.reactions[emoji, default: 0] += 1
                        } label: {
                            Text(emoji)
                        }
                    }
                } label: {
                    Label(entry.userReaction ?? "❤️", systemImage: "heart")
                        .labelStyle(.iconOnly)
                        .font(.title3)
                }
                .buttonStyle(PlainButtonStyle())

                Button(action: onTapComment) {
                    HStack(spacing: 4) {
                        Image(systemName: "bubble.right")
                            .font(.title3)
                        if !entry.comments.isEmpty {
                            Text("\(entry.comments.count)")
                                .font(.caption)
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
        .padding(.top, 8)
    }
}
