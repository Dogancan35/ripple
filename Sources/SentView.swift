import SwiftUI
import SwiftData

struct SentView: View {
    @Query(filter: #Predicate<RippleItem> { !$0.isReceived }, sort: \RippleItem.timestamp, order: .reverse)
    private var sentRipples: [RippleItem]

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if sentRipples.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "paperplane")
                            .font(.system(size: 60))
                            .foregroundColor(.white.opacity(0.2))
                        Text("No Ripples sent yet")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.5))
                        Text("Send a Ripple to start spreading kindness!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.3))
                    }
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(sentRipples) { ripple in
                                SentRow(ripple: ripple)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    }
                }
            }
            .navigationTitle("Sent")
            .navigationBarTitleDisplayMode(.large)
            .toolbarBackground(Color(hex: "1A1A2E"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct SentRow: View {
    let ripple: RippleItem
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.4)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color(hex: ripple.category.color).opacity(0.2))
                            .frame(width: 44, height: 44)
                        Image(systemName: ripple.category.icon)
                            .foregroundColor(Color(hex: ripple.category.color))
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(ripple.category.rawValue)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(ripple.timestamp, style: .relative)
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.4))
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(16)
                .background(Color.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Text(ripple.content)
                        .font(.body)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 12)

                    if let photoData = ripple.photoData, let uiImage = UIImage(data: photoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(Color(hex: "6C5CE7"))
                        Text("Ripple sent successfully")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    .padding(.top, 4)
                }
                .padding(16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    SentView()
        .modelContainer(for: RippleItem.self, inMemory: true)
}