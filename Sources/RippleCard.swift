import SwiftUI

struct RippleCard: View {
    let ripple: RippleItem
    @State private var isRevealed = false

    var body: some View {
        ZStack {
            // Background gradient based on category
            LinearGradient(
                colors: [
                    Color(hex: ripple.category.color).opacity(0.8),
                    Color(hex: ripple.category.color).opacity(0.4)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            // Ripple category icon watermark
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: ripple.category.icon)
                        .font(.system(size: 120))
                        .foregroundColor(.white.opacity(0.15))
                    Spacer()
                }
                Spacer()
            }

            VStack(spacing: 24) {
                // Category badge
                HStack {
                    Image(systemName: ripple.category.icon)
                        .foregroundColor(.white)
                    Text(ripple.category.rawValue.uppercased())
                        .font(.caption)
                        .fontWeight(.bold)
                        .foregroundColor(.white.opacity(0.9))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.white.opacity(0.2))
                .clipShape(Capsule())

                Spacer()

                if isRevealed {
                    // Revealed content
                    VStack(spacing: 20) {
                        Text(ripple.content)
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .transition(.opacity.combined(with: .scale(scale: 0.8)))

                        if let photoData = ripple.photoData, let uiImage = UIImage(data: photoData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: 200, maxHeight: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .shadow(radius: 8)
                        }
                    }
                } else {
                    // Hidden state
                    VStack(spacing: 16) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 48))
                            .foregroundColor(.white.opacity(0.6))

                        Text("A Ripple awaits you...")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Spacer()

                // Timestamp
                Text(ripple.timestamp, style: .relative)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(32)
        }
        .clipShape(RoundedRectangle(cornerRadius: 32))
        .shadow(color: Color(hex: ripple.category.color).opacity(0.4), radius: 20, x: 0, y: 10)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                isRevealed = true
            }
        }
    }
}

#Preview {
    RippleCard(ripple: RippleItem.samples[0])
        .frame(height: 400)
        .padding()
}