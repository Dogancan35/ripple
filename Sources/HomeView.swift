import SwiftUI
import SwiftData

struct HomeView: View {
    @Query private var allRipples: [RippleItem]
    @State private var showingOpenRipple = false
    @State private var showingSendRipple = false

    private var receivedCount: Int {
        allRipples.filter { $0.isReceived }.count
    }

    private var sentCount: Int {
        allRipples.filter { !$0.isReceived }.count
    }

    private var karmaScore: Int {
        sentCount - receivedCount
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                LinearGradient(
                    colors: [Color(hex: "1A1A2E"), Color(hex: "16213E")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 32) {
                    // Logo / Title
                    VStack(spacing: 8) {
                        Image(systemName: "water.waves")
                            .font(.system(size: 60))
                            .foregroundColor(Color(hex: "6C5CE7"))

                        Text("Ripple")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundColor(.white)

                        Text("Receive kindness. Pass it forward.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .padding(.top, 40)

                    // Karma Score
                    VStack(spacing: 8) {
                        Text("Ripple Karma")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))

                        HStack(spacing: 4) {
                            Text("\(karmaScore)")
                                .font(.system(size: 48, weight: .bold, design: .rounded))
                                .foregroundColor(karmaScore >= 0 ? Color(hex: "6C5CE7") : Color(hex: "FF6B9D"))

                            Image(systemName: karmaScore >= 0 ? "arrow.up" : "arrow.down")
                                .font(.title2)
                                .foregroundColor(karmaScore >= 0 ? Color(hex: "6C5CE7") : Color(hex: "FF6B9D"))
                        }

                        HStack(spacing: 24) {
                            Label("\(receivedCount) received", systemImage: "tray.fill")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                            Label("\(sentCount) sent", systemImage: "paperplane.fill")
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    .padding(24)
                    .background(Color.white.opacity(0.05))
                    .clipShape(RoundedRectangle(cornerRadius: 20))

                    Spacer()

                    // Action Buttons
                    VStack(spacing: 16) {
                        Button {
                            showingOpenRipple = true
                        } label: {
                            HStack {
                                Image(systemName: "gift.fill")
                                Text("Open a Ripple")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [Color(hex: "6C5CE7"), Color(hex: "A29BFE")],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color(hex: "6C5CE7").opacity(0.4), radius: 12, y: 6)
                        }

                        Button {
                            showingSendRipple = true
                        } label: {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("Send a Ripple")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(Color.white.opacity(0.1))
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
                }
            }
            .navigationDestination(isPresented: $showingOpenRipple) {
                OpenRippleView()
            }
            .navigationDestination(isPresented: $showingSendRipple) {
                SendRippleView()
            }
        }
    }
}

#Preview {
    HomeView()
        .modelContainer(for: RippleItem.self, inMemory: true)
}