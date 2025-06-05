//
//  NewPost.swift
//  sharedJournal
//
//  Created by Long Huynh on 6/4/25.
//

// Views/NewPostPanel.swift
import SwiftUI
import PhotosUI

struct NewPost: View {
    @Binding var newEntryText: String
    @Binding var selectedItems: [PhotosPickerItem]
    @Binding var selectedImageData: [Data]
    var onPost: () -> Void
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button("Cancel") {
                        newEntryText = ""
                        selectedItems = []
                        selectedImageData = []
                        dismiss()
                    }
                    .foregroundColor(.blue)
                    Spacer()
                    
                }
                Text("New Diary")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundColor(.primary)
                
            }
            .padding(.horizontal)

            TextEditor(text: $newEntryText)
                .frame(height: 150)
                .padding(.horizontal)

            if !selectedImageData.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(selectedImageData, id: \.self) { data in
                            if let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipped()
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }

            HStack {
                PhotosPicker(
                    selection: $selectedItems,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label("Select Photos", systemImage: "photo.on.rectangle")
                }
                .onChange(of: selectedItems) { newItems in
                    Task {
                        selectedImageData = []
                        for item in newItems {
                            if let data = try? await item.loadTransferable(type: Data.self) {
                                selectedImageData.append(data)
                            }
                        }
                    }
                }

                Spacer()

                Button("Post") {
                    onPost()
                }
                .disabled(newEntryText.trimmingCharacters(in: .whitespaces).isEmpty)
                .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    newEntryText = ""
                    selectedItems = []
                    selectedImageData = []
                    dismiss()
                }
            }
        }
    }
}
