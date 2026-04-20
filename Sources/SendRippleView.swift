import SwiftUI
import SwiftData
import PhotosUI

struct SendRippleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedCategory: RippleCategory = .compliment
    @State private var content: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var photoImage: UIImage?
    @State private var showingSuccess = false

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 28) {
                    // Category Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Choose a Category")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 24)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(RippleCategory.allCases, id: \.self) { category in
                                    CategoryButton(
                                        category: category,
                                        isSelected: selectedCategory == category
                                    ) {
                                        withAnimation(.spring(response: 0.3)) {
                                            selectedCategory = category
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.top, 20)

                    // Text Input
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Your Kindness Message")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 24)

                        ZStack(alignment: .topLeading) {
                            if content.isEmpty {
                                Text("Write something kind...")
                                    .foregroundColor(.white.opacity(0.3))
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 16)
                            }

                            TextEditor(text: $content)
                                .foregroundColor(.white)
                                .scrollContentBackground(.hidden)
                                .background(Color.clear)
                                .frame(minHeight: 150)
                                .padding(.horizontal, 16)
                        }
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.05))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .padding(.horizontal, 24)

                        HStack {
                            Spacer()
                            Text("\(content.count)/280")
                                .font(.caption)
                                .foregroundColor(content.count > 280 ? .red : .white.opacity(0.3))
                        }
                        .padding(.horizontal, 24)
                    }

                    // Photo Picker
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Add a Photo (Optional)")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 24)

                        PhotosPicker(selection: $selectedPhoto, matching: .images) {
                            if let image = photoImage {
                                VStack {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 120, height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color(hex: "6C5CE7"), lineWidth: 2)
                                        )

                                    Button("Remove") {
                                        photoImage = nil
                                        selectedPhoto = nil
                                    }
                                    .font(.caption)
                                    .foregroundColor(.red)
                                }
                            } else {
                                HStack {
                                    Image(systemName: "photo.fill")
                                        .foregroundColor(Color(hex: "6C5CE7"))
                                    Text("Add Photo")
                                        .foregroundColor(.white.opacity(0.7))
                                }
                                .frame(width: 120, height: 120)
                                .background(Color.white.opacity(0.05))
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                                )
                            }
                        }
                        .padding(.horizontal, 24)
                        .onChange(of: selectedPhoto) { _, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    photoImage = image
                                }
                            }
                        }
                    }

                    Spacer(minLength: 100)

                    // Send Button
                    Button {
                        sendRipple()
                    } label: {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Send Ripple")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            canSend ? LinearGradient(
                                colors: [Color(hex: "6C5CE7"), Color(hex: "A29BFE")],
                                startPoint: .leading,
                                endPoint: .trailing
                            ) : LinearGradient(colors: [.gray.opacity(0.5), .gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing)
                        )
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: Color(hex: "6C5CE7").opacity(0.4), radius: 12, y: 6)
                    }
                    .disabled(!canSend)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Send a Ripple")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color(hex: "1A1A2E"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .alert("Ripple Sent! 🌊", isPresented: $showingSuccess) {
            Button("Done") { dismiss() }
        } message: {
            Text("Your kindness is now rippling out into the world. Thank you!")
        }
    }

    private var canSend: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && content.count <= 280
    }

    private func sendRipple() {
        let trimmedContent = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let photoData = photoImage?.jpegData(compressionQuality: 0.8)

        let ripple = RippleItem(
            content: trimmedContent,
            category: selectedCategory,
            photoData: photoData,
            isReceived: false
        )

        modelContext.insert(ripple)
        showingSuccess = true
    }
}

struct CategoryButton: View {
    let category: RippleCategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: category.icon)
                    .font(.title2)
                Text(category.rawValue)
                    .font(.caption2)
                    .fontWeight(.medium)
            }
            .foregroundColor(isSelected ? .white : .white.opacity(0.5))
            .frame(width: 70, height: 70)
            .background(
                isSelected ? Color(hex: category.color) : Color.white.opacity(0.05)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.clear : Color.white.opacity(0.1), lineWidth: 1)
            )
        }
    }
}

#Preview {
    NavigationStack {
        SendRippleView()
    }
    .modelContainer(for: RippleItem.self, inMemory: true)
}