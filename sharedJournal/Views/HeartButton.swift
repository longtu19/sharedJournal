//
//  HeartButton.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/16/25.
//

import SwiftUI

struct HeartButton: View {
    @Binding var userReaction: String?
    @Binding var reactions: [String: Int]
    var onShowPicker: (CGPoint) -> Void
    var onHidePicker: () -> Void

    @State private var didLongPress = false

    var body: some View {
        GeometryReader { geo in
            Label("", systemImage: "heart")
                .labelStyle(.iconOnly)
                .font(.title3)
                .foregroundColor(.blue)
                .padding(4)
                .contentShape(Rectangle())
                .onTapGesture {
                    if !didLongPress {
                        reactions["❤️", default: 0] += 1
                        userReaction = "❤️"
                    }
                    didLongPress = false
                }
                .simultaneousGesture(
                    LongPressGesture(minimumDuration: 0.4).onEnded { _ in
                        let local = geo.frame(in: .named("ReactionSpace"))
                        let spacing: CGFloat = 16
                        onShowPicker(CGPoint(x: local.midX, y: local.maxY + spacing))
                        didLongPress = true
                    }
                )
        }
        .frame(width: 25, height: 32)
        .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }
    }
}
