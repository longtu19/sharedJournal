//
//  DiaryPostHeader.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/DiaryPostHeader.swift
import SwiftUI

struct DiaryPostHeader: View {
    let entry: DiaryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                entry.profileImage
                    .resizable()
                    .frame(width: 30, height: 30)
                    .clipShape(Circle())

                Text(entry.username)
                    .font(.subheadline)
                    .bold()

                Text("\(entry.date.timeAgo())")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            if !entry.images.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(entry.images, id: \.self) { data in
                            if let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.bottom, 8)
            }
            
            
            if !entry.content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Text(entry.content)
            }
        }
    }
}
