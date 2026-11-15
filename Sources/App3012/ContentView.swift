import SwiftUI

struct ContentView: View {
    @State private var tapCount: Int = 0

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "hammer.circle.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(.blue)
                Text("App3012")
                    .font(.title.bold())
                Text("Built with 3012 IDE + xtool SwiftPM")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Button("Tap Count: \(tapCount)") {
                    tapCount += 1
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
            .navigationTitle("App3012")
        }
    }
}
