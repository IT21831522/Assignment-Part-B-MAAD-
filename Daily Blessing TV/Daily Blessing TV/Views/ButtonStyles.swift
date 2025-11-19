import SwiftUI

struct CardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    Button(action: {}) {
        Text("Test Button")
            .padding()
            .background(Color.blue)
            .cornerRadius(8)
    }
    .buttonStyle(CardButtonStyle())
}
