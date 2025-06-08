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
    @State private var didLongPress = false

    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                VStack(alignment: .leading) {
                    DiaryPostHeader(entry: entry)
                    HStack(spacing: 20) {
                        VStack {
                            GeometryReader { geo in
                                Label("", systemImage: "heart")
                                    .labelStyle(.iconOnly)
                                    .font(.title3)
                                    .foregroundColor(.blue)
                                    .padding(4)
                                    .contentShape(Rectangle()) 
                                    .onTapGesture {
                                        if !didLongPress {
                                            entry.reactions["❤️", default: 0] += 1
                                            entry.userReaction = "❤️"
                                        }
                                        didLongPress = false // reset
                                    }
                                    .simultaneousGesture(
                                        LongPressGesture(minimumDuration: 0.4).onEnded { _ in
                                            let global = geo.frame(in: .global)
                                            reactionAnchor = CGPoint(x: global.midX, y: global.maxY + 4)
                                            withAnimation {
                                                showReactionPicker = true
                                            }
                                            didLongPress = true // suppress tap
                                        }
                                    )
                            }
                        }
                        .frame(width: 25, height: 32) // Match icon height
                        .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }


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
                                HStack(spacing: 2) {
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
                            }
                        )
                }
            }
            .contentShape(Rectangle())
            .onTapGesture(count: 2) {
                withAnimation {
                    entry.reactions["❤️", default: 0] += 1
                    entry.userReaction = "❤️"
                }
            }
        }
        .padding(.top, 8)
    }
}


