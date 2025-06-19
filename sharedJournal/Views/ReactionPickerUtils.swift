//
//  ReactionPickerUtils.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/8/25.
//


import SwiftUI

extension View {
    func clampedReactionAnchor(from point: CGPoint, in size: CGSize) -> CGPoint {
        let pickerWidth: CGFloat = 200
        let pickerHeight: CGFloat = 50

        let safeX = max(pickerWidth / 2, min(point.x, size.width - pickerWidth / 2))
        let safeY = max(point.y, pickerHeight / 2)

        return CGPoint(x: safeX, y: safeY)
    }
}
