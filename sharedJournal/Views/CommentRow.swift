//
//  CommentRow.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/CommentRow.swift
import SwiftUI

struct CommentRow: View {
    let comment: Comment

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            comment.profileImage
                .resizable()
                .frame(width: 24, height: 24)
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(comment.username)
                        .font(.footnote)
                        .bold()
                    Text("• \(comment.timestamp.timeAgo())")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                Text(comment.content)
                    .font(.footnote)
            }
        }
    }
}
