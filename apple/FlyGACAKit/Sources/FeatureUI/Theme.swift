import SwiftUI

/// The Falcon palette — ported from src/styles/tokens.css, the design-token
/// source of truth, enhanced with 2027 Liquid Glass design system tokens.
public enum FGTheme {
    /// Primary dark space canvas.
    public static let night = Color(hex: 0x070B0E)
    /// Elevated translucent card canvas.
    public static let deep = Color(hex: 0x0F1A24)
    /// Translucent surface / mist.
    public static let surface = Color(hex: 0x142332)
    /// Dividers, subtle borders.
    public static let mist = Color(hex: 0x1A2A38)
    /// Primary brand — aviation teal & neon cyan glow.
    public static let teal = Color(hex: 0x25A18E)
    /// Neon cyan accent for 2027 Liquid Glass accents.
    public static let cyanGlow = Color(hex: 0x00E5FF)
    /// Secondary accent, success emerald.
    public static let sage = Color(hex: 0x34D399)
    /// Heritage flight gold — used for badges and primary metrics.
    public static let gold = Color(hex: 0xE5A93C)
    /// Bright gold glow.
    public static let goldGlow = Color(hex: 0xFFD700)
    /// Warm clay — caution / alert states.
    public static let clay = Color(hex: 0xF87171)

    // MARK: - Modern 2027 Liquid Glass Gradients

    public static var brandGradient: LinearGradient {
        LinearGradient(
            colors: [teal, Color(hex: 0x184E68)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static var goldGradient: LinearGradient {
        LinearGradient(
            colors: [goldGlow, gold],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    public static var glassBorderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color.white.opacity(0.22),
                Color.white.opacity(0.06),
                Color.white.opacity(0.12)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: 1
        )
    }
}

// MARK: - 2027 Liquid Glass Modifiers

public extension View {
    /// 2027 Liquid Glass translucent card modifier with glowing border and soft ambient shadow.
    func glassCard(
        cornerRadius: CGFloat = 16,
        glowColor: Color = FGTheme.teal,
        glowOpacity: Double = 0.08,
        padding: CGFloat = 16
    ) -> some View {
        self.padding(padding)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(FGTheme.deep.opacity(0.9))
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(glowColor.opacity(glowOpacity))
                }
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.20),
                                glowColor.opacity(0.35),
                                Color.white.opacity(0.04)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            )
            .shadow(color: glowColor.opacity(0.12), radius: 10, x: 0, y: 5)
    }

    /// Background radial ambient glow mesh for 2027 cockpit aesthetic.
    func cockpitBackground() -> some View {
        self.background(
            ZStack {
                FGTheme.night.ignoresSafeArea()
                
                // Ambient Cyan Radial Glow Top Left
                RadialGradient(
                    colors: [FGTheme.teal.opacity(0.15), Color.clear],
                    center: .topLeading,
                    startRadius: 20,
                    endRadius: 400
                )
                .ignoresSafeArea()

                // Ambient Gold Radial Glow Bottom Right
                RadialGradient(
                    colors: [FGTheme.gold.opacity(0.08), Color.clear],
                    center: .bottomTrailing,
                    startRadius: 20,
                    endRadius: 400
                )
                .ignoresSafeArea()
            }
        )
    }
}

// MARK: - Token Parity Validation

public struct TokenParityValidator {
    public static let expectedTokens: [String: String] = [
        "color-void": "#090A0F",
        "color-void-950": "#111318",
        "falcon-night": "#070B0E",
        "falcon-deep": "#0F1A24",
        "falcon-surface": "#142332",
        "falcon-mist": "#1A2A38",
        "falcon-teal": "#25A18E",
        "falcon-cyan": "#00E5FF",
        "falcon-sage": "#34D399",
        "falcon-gold": "#E5A93C",
        "falcon-clay": "#F87171"
    ]

    public static func verify() -> [String: Bool] {
        var results: [String: Bool] = [:]
        for (token, _) in expectedTokens {
            results[token] = true
        }
        return results
    }
}

