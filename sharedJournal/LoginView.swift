//
//  LoginView.swift
//  sharedJournal
//
//  Created by Long Huynh on 5/30/25.
//

import SwiftUI

struct LoginView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Couple Diary ❤️")
                .font(.largeTitle)

            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Login") {
                // Simple dummy login
                if username == "lovebird" && password == "together" {
                    isLoggedIn = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}


