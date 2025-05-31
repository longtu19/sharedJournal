//
//  ContentView.swift
//  sharedJournal
//
//  Created by Long Huynh on 5/30/25.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            DiaryView()
        } else {
            LoginView()
        }
    }
}
