import SwiftUI
import SwiftData

struct OpenRippleView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var selectedRipple: RippleItem?
    @State private var showingRipple = false
    @State private var animationProgress: CGFloat = 0

    // Sample pool for when no ripples exist yet
    let samplePool: [(String, RippleCategory)] = [
        ("Your kindness is like a pebble in a pond — it creates endless ripples. Thank you for being you! 💜", .compliment),
        ("Take a moment to breathe. You are doing better than you think. ☕", .coffee),
        ("A stranger wishes you safe travels and smooth roads ahead. 🚗✨", .fare),
        ("Remember: every expert was once a beginner. Keep learning, keep growing! 📚", .knowledge),
        ("Here's a virtual hug 🤗 — may your day be filled with warmth and small miracles.", .gift),
        ("Your presence makes the world a little brighter. Never forget that! 🌟", .compliment),
        ("Coffee is on me today — virtual bean sent your way! ☕💫", .coffee),
        ("May the wind be at your back and the road be gentle. Safe travels! 🌬️", .fare),
        ("A wise person told me: 'The best time to plant a tree was 20 years ago. The second best time is now.' 🌱", .knowledge),
        ("Surprise! You're doing great — here's a little gift of encouragement! 🎁", .gift),
    ]

    var body: some View {
        ZStack {
            // Dark background
            LinearGradient(
                colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            if showingRipple, let ripple = selectedRipple {
                // Ripple card view
                VStack {
                    Spacer()
                    RippleCard(ripple: ripple)
                        .padding(.horizontal, 24)
                    Spacer()

                    // Pass it forward button
                    Button {
                        // Mark as received and go back
                        ripple.isRead = true
                        dismiss()
                    } label: {
                        Text("Pass It Forward →")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color(hex: "6C5CE7"))
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            } else {
                // Pre-reveal animation
                VStack(spacing: 32) {
                    Spacer()

                    ZStack {
                        ForEach(0..<3, id: \.self) { i in
                            Circle()
                                .stroke(Color(hex: "6C5CE7").opacity(0.3 - Double(i) * 0.1), lineWidth: 2)
                                .frame(width: CGFloat(150 + i * 60), height: CGFloat(150 + i * 60))
                                .scaleEffect(animationProgress > CGFloat(i) / 3 ? 1.0 : 0.5)
                                .opacity(animationProgress > CGFloat(i) / 3 ? 1.0 : 0.0)
                        }

                        Image(systemName: "sparkles")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: "6C5CE7"))
                            .rotationEffect(.degrees(animationProgress * 360))
                    }
                    .frame(height: 330)

                    Text("Searching for a Ripple...")
                        .font(.title3)
                        .foregroundColor(.white.opacity(0.7))

                    Spacer()

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(hex: "6C5CE7")))
                        .scaleEffect(1.5)
                        .padding(.bottom, 80)
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
                Text("Open a Ripple")
                    .font(.headline)
                    .foregroundColor(.white)
            }
        }
        .toolbarBackground(Color(hex: "1A1A2E"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            startRevealAnimation()
        }
    }

    private func startRevealAnimation() {
        withAnimation(.easeInOut(duration: 2.0)) {
            animationProgress = 1.0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            // Pick a random sample
            let randomSample = samplePool.randomElement()!
            let ripple = RippleItem(
                content: randomSample.0,
                category: randomSample.1,
                photoData: nil,
                isReceived: true
            )
            modelContext.insert(ripple)
            selectedRipple = ripple

            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showingRipple = true
            }
        }
    }
}

#Preview {
    NavigationStack {
        OpenRippleView()
    }
    .modelContainer(for: RippleItem.self, inMemory: true)
}