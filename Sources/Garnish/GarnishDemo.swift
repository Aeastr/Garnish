//
//  GarnishDemo.swift
//  Garnish
//
//  Created by Garnish Contributors, 2025.
//
//  Copyright © 2025 Garnish Contributors. All rights reserved.
//  Licensed under the MIT License.
//

#if DEBUG

import SwiftUI

@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct GarnishDemoApp: View {
    @State private var selectedDemo: DemoSection?

    public init() {}

    public var body: some View {
        NavigationSplitView {
            // Sidebar
            List(DemoSection.allCases, id: \.self, selection: $selectedDemo) { section in
                Label(section.title, systemImage: section.icon)
                    .tag(section)
            }
            .navigationTitle("Garnish Demo")
        } detail: {
            // Detail view
            Group {
                if let selectedDemo = selectedDemo {
                    selectedDemo.view
                        .navigationTitle(selectedDemo.title)
                        #if os(iOS)
                        .background(Color(.systemGroupedBackground))
                        .navigationBarTitleDisplayMode(.inline)
                        #endif
                } else {
                    if #available(iOS 17.0, *) {
                        ContentUnavailableView(
                            "Select a Demo",
                            systemImage: "paintpalette",
                            description: Text("Choose a demo from the sidebar to see Garnish in action")
                        )
                    } else {
                        Text("Select a Demo")
                    }
                }
            }
        }
    }
}

@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
enum DemoSection: CaseIterable {
    case coreAPI
    case mathUtilities
    case colorExtensions
    case fontWeight
    case accessibility

    var title: String {
        switch self {
        case .coreAPI: return "Core API"
        case .mathUtilities: return "Math Utilities"
        case .colorExtensions: return "Color Extensions"
        case .fontWeight: return "Font Weight"
        case .accessibility: return "Accessibility"
        }
    }

    var icon: String {
        switch self {
        case .coreAPI: return "paintpalette.fill"
        case .mathUtilities: return "function"
        case .colorExtensions: return "square.3.layers.3d"
        case .fontWeight: return "textformat"
        case .accessibility: return "eye.fill"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .coreAPI: CoreAPIDemo()
        case .mathUtilities: MathUtilitiesDemo()
        case .colorExtensions: ColorExtensionsDemo()
        case .fontWeight: FontWeightDemo()
        case .accessibility: AccessibilityDemo()
        }
    }
}

// MARK: - Core API Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct CoreAPIDemo: View {
    @State private var inputColor = Color(red: 0.54, green: 0.22, blue: 0.89)
    @State private var backgroundColor = Color(red: 0.12, green: 0.01, blue: 0.88)
    @State private var targetRatio: Double = GarnishMath.defaultThreshold
    @State private var customRatioText: String = ""
    @State private var minimumBlend: Double = 0.0
    @State private var selectedBlendStyle: Garnish.BlendStyle?

    private var monochromaticContrastResult: (shade: Color?, error: String?) {
        let shade = Garnish.contrastingShade(
            of: inputColor,
            targetRatio: targetRatio,
            minimumBlend: minimumBlend > 0 ? minimumBlend : nil,
            blendStyle: selectedBlendStyle
        )
        if shade == nil {
            return (nil, "Failed to generate contrasting shade")
        }
        return (shade, nil)
    }

    private var bichromaticContrastResult: (color: Color?, error: String?) {
        let color = Garnish.contrastingColor(
            inputColor,
            against: backgroundColor,
            targetRatio: targetRatio,
            minimumBlend: minimumBlend > 0 ? minimumBlend : nil,
            blendStyle: selectedBlendStyle
        )
        if color == nil {
            return (nil, "Failed to generate contrasting color")
        }
        return (color, nil)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                DemoSectionView(
                    title: "Monochromatic Contrast",
                    description: "Get a contrasting shade of the same color"
                ) {
                    VStack(spacing: 20) {
                        CodeBlock(
                            code: """
                            let contrastingShade = try Garnish.contrastingShade(of: inputColor, targetRatio: \(String(format: "%.1f", targetRatio)))
                            """,
                            colorMappings: [
                                "contrastingShade": monochromaticContrastResult.shade ?? .gray,
                                "inputColor": inputColor
                            ]
                        )

                        Divider()

                        ColorPicker("Input Color", selection: $inputColor)

                        if let errorMessage = monochromaticContrastResult.error {
                            Text("Error: \(errorMessage)").foregroundColor(.red)
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                if let shade = monochromaticContrastResult.shade {
                                    Text("Contrasting Shade")
                                        .font(.body.weight(.semibold))
                                        .foregroundColor(shade)
                                        .padding()
                                        .background(inputColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 27))

                                        Text("Contrasting Shade")
                                            .font(.body.weight(.semibold))
                                            .foregroundColor(inputColor)
                                            .padding()
                                            .background(shade)
                                            .clipShape(RoundedRectangle(cornerRadius: 27))
                                }

                                Divider()
                                    .padding(.vertical, 8)

                                Text("White")
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(inputColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 27))
                                Text("Black")
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(inputColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 27))
                            }
                            .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }

                DemoSectionView(
                    title: "Bi-chromatic Contrast",
                    description: "Optimize one color against another"
                ) {
                    VStack(spacing: 20) {
                        CodeBlock(
                            code: """
                            let optimizedColor = try Garnish.contrastingColor(inputColor, against: backgroundColor, targetRatio: \(String(format: "%.1f", targetRatio)))
                            """,
                            colorMappings: [
                                "optimizedColor": bichromaticContrastResult.color ?? .gray,
                                "inputColor": inputColor,
                                "backgroundColor": backgroundColor
                            ]
                        )

                        Divider()

                        ColorPicker("Foreground Color", selection: $inputColor)

                        ColorPicker("Background Color", selection: $backgroundColor)

                        if let errorMessage = bichromaticContrastResult.error {
                            Text("Error: \(errorMessage)").foregroundColor(.red)
                        }

                        ScrollView(.horizontal) {
                            HStack {
                                if let shade = bichromaticContrastResult.color {
                                    Text("Contrasting Shade")
                                        .font(.body.weight(.semibold))
                                        .foregroundColor(shade)
                                        .padding()
                                        .background(backgroundColor)
                                        .clipShape(RoundedRectangle(cornerRadius: 27))

                                        Text("Contrasting Shade")
                                            .font(.body.weight(.semibold))
                                            .foregroundColor(backgroundColor)
                                            .padding()
                                            .background(shade)
                                            .clipShape(RoundedRectangle(cornerRadius: 27))
                                }

                                Divider()
                                    .padding(.vertical, 8)

                                Text("White")
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(.white)
                                    .padding()
                                    .background(backgroundColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 27))
                                Text("Black")
                                    .font(.body.weight(.semibold))
                                    .foregroundColor(.black)
                                    .padding()
                                    .background(backgroundColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 27))
                            }
                            .fixedSize()
                        }
                    }
                }

                DemoSectionView(
                    title: "Direction Control",
                    description: "Control whether colors go light or dark"
                ) {
                    VStack(spacing: 20) {
                        ColorPicker("Input Color", selection: $inputColor)

                        let autoShade = try? Garnish.contrastingShade(of: inputColor, targetRatio: targetRatio, direction: .auto)
                        let forcedDark = try? Garnish.contrastingShade(of: inputColor, targetRatio: targetRatio, direction: .forceDark)
                        let forcedLight = try? Garnish.contrastingShade(of: inputColor, targetRatio: targetRatio, direction: .forceLight)
                        let preferDark = try? Garnish.contrastingShade(of: inputColor, targetRatio: targetRatio, direction: .preferDark)
                        let preferLight = try? Garnish.contrastingShade(of: inputColor, targetRatio: targetRatio, direction: .preferLight)

                        VStack(alignment: .leading, spacing: 12) {
                            Text("Force vs Prefer")
                                .font(.caption)
                                .foregroundColor(.secondary)

                            Text("**Force**: Always goes in that direction (may not meet target contrast)")
                                .font(.caption2)
                                .foregroundColor(.secondary)

                            Text("**Prefer**: Tries that direction first, switches only if target is unreachable")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        .padding(12)
                        .background(Color.secondary.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                        ScrollView(.horizontal) {
                            HStack(spacing: 12) {
                                DirectionSwatch(label: "Auto", color: autoShade, background: inputColor)
                                Divider().frame(height: 80)
                                DirectionSwatch(label: "Prefer Light", color: preferLight, background: inputColor)
                                DirectionSwatch(label: "Prefer Dark", color: preferDark, background: inputColor)
                                Divider().frame(height: 80)
                                DirectionSwatch(label: "Force Light", color: forcedLight, background: inputColor)
                                DirectionSwatch(label: "Force Dark", color: forcedDark, background: inputColor)
                            }
                            .padding(.horizontal, 4)
                        }

                        CodeBlock(
                            code: """
                            // Auto - picks mathematically best
                            let auto = try Garnish.contrastingShade(of: color, direction: .auto)

                            // Prefer - tries your preference, switches if needed
                            let preferLight = try Garnish.contrastingShade(of: color, direction: .preferLight)
                            let preferDark = try Garnish.contrastingShade(of: color, direction: .preferDark)

                            // Force - always goes that way (may not meet target)
                            let forceLight = try Garnish.contrastingShade(of: color, direction: .forceLight)
                            let forceDark = try Garnish.contrastingShade(of: color, direction: .forceDark)
                            """,
                            colorMappings: [
                                "color": inputColor,
                                "auto": autoShade ?? .gray,
                                "preferLight": preferLight ?? .gray,
                                "preferDark": preferDark ?? .gray,
                                "forceLight": forcedLight ?? .gray,
                                "forceDark": forcedDark ?? .gray
                            ]
                        )
                    }
                }
            }
            .padding()
        }
        .inspector(isPresented: .constant(true)) {
            VStack(spacing: 20) {
                Text("Settings")
                    .font(.headline)

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Target Contrast Ratio")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text("\(String(format: "%.1f", targetRatio)):1")
                        .font(.title3)
                        .fontDesign(.monospaced)

                    Slider(value: $targetRatio, in: 1.0...21.0, step: 0.5)

                    HStack(spacing: 6) {
                        Button("3:1") { targetRatio = 3.0 }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        Button("4.5:1") { targetRatio = 4.5 }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                        Button("7:1") { targetRatio = 7.0 }
                            .buttonStyle(.bordered)
                            .controlSize(.small)
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 12) {
                    Text("Minimum Blend")
                        .font(.subheadline)
                        .fontWeight(.medium)

                    Text("\(String(format: "%.0f", minimumBlend * 100))%")
                        .font(.title3)
                        .fontDesign(.monospaced)

                    Slider(value: $minimumBlend, in: 0.0...1.0, step: 0.1)

                    VStack(spacing: 6) {
                        Button("Minimal (0%)") {
                            selectedBlendStyle = .minimal
                            minimumBlend = 0.0
                        }
                        .buttonStyle(.borderedProminent)
                        .opacity(selectedBlendStyle == .minimal ? 1.0 : 0.5)
                        .controlSize(.small)

                        Button("Moderate (50%)") {
                            selectedBlendStyle = .moderate
                            minimumBlend = 0.5
                        }
                        .buttonStyle(.borderedProminent)
                        .opacity(selectedBlendStyle == .moderate ? 1.0 : 0.5)
                        .controlSize(.small)

                        Button("Strong (70%)") {
                            selectedBlendStyle = .strong
                            minimumBlend = 0.7
                        }
                        .buttonStyle(.borderedProminent)
                        .opacity(selectedBlendStyle == .strong ? 1.0 : 0.5)
                        .controlSize(.small)

                        Button("Maximum (100%)") {
                            selectedBlendStyle = .maximum
                            minimumBlend = 1.0
                        }
                        .buttonStyle(.borderedProminent)
                        .opacity(selectedBlendStyle == .maximum ? 1.0 : 0.5)
                        .controlSize(.small)
                    }

                    Text("Controls how strongly colors blend towards white/black.")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding()
            .inspectorColumnWidth(min: 200, ideal: 250, max: 300)
        }
    }
}

// MARK: - Math Utilities Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct MathUtilitiesDemo: View {
    @State private var color1 = Color.blue
    @State private var color2 = Color.red

    private var luminanceResult: (value: Double?, error: String?) {
        if let value = GarnishMath.relativeLuminance(of: color1) {
            return (Double(value), nil)
        }
        return (nil, "Failed to calculate luminance")
    }

    private var brightnessResult: (value: Double?, error: String?) {
        if let value = GarnishMath.brightness(of: color1) {
            return (Double(value), nil)
        }
        return (nil, "Failed to calculate brightness")
    }

    private var contrastRatioResult: (value: Double?, error: String?) {
        if let value = GarnishMath.contrastRatio(between: color1, and: color2) {
            return (Double(value), nil)
        }
        return (nil, "Failed to calculate contrast ratio")
    }

    private var colorSchemeResult: (scheme: ColorScheme?, error: String?) {
        do {
            let scheme = try GarnishMath.colorScheme(for: color1)
            return (scheme, nil)
        } catch {
            return (nil, error.localizedDescription)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                DemoSectionView(
                    title: "Color Analysis",
                    description: "Mathematical properties of colors"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Color to Analyze", selection: $color1)

                        let colorScheme = colorSchemeResult.scheme
                        let colorSchemeError = colorSchemeResult.error

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Relative Luminance:")
                                Spacer()
                                if let errorMessage = luminanceResult.error {
                                    Text("Error: \(errorMessage)").foregroundColor(.red)
                                } else if let value = luminanceResult.value {
                                    Text(String(format: "%.3f", value))
                                        .fontDesign(.monospaced)
                                }
                            }

                            HStack {
                                Text("Brightness:")
                                Spacer()
                                if let errorMessage = brightnessResult.error {
                                    Text("Error: \(errorMessage)").foregroundColor(.red)
                                } else if let value = brightnessResult.value {
                                    Text(String(format: "%.3f", value))
                                        .fontDesign(.monospaced)
                                }
                            }

                            HStack {
                                Text("Color Scheme:")
                                Spacer()
                                if let colorSchemeError = colorSchemeError {
                                    Text("Error: \(colorSchemeError)").foregroundColor(.red)
                                } else if let colorScheme = colorScheme {
                                    Text(colorScheme == .light ? "Light" : "Dark")
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 27)
                                .fill(.regularMaterial)
                                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        )

                        CodeBlock(
                            code: """
                            let luminance = try GarnishMath.relativeLuminance(of: color)
                            let brightness = try GarnishMath.brightness(of: color)
                            let colorScheme = try GarnishMath.colorScheme(for: color)
                            """,
                            colorMappings: [
                                "color": color1
                            ]
                        )
                    }
                }

                DemoSectionView(
                    title: "Contrast Ratio",
                    description: "WCAG contrast ratio between two colors"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Color 1", selection: $color1)
                        ColorPicker("Color 2", selection: $color2)

                        let contrastRatio = contrastRatioResult.value ?? 1.0
                        let meetsAA = GarnishMath.meetsWCAGAA(contrastRatio)
                        let meetsAAA = GarnishMath.meetsWCAGAAA(contrastRatio)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Contrast Ratio:")
                                Spacer()
                                if let errorMessage = contrastRatioResult.error {
                                    Text("Error: \(errorMessage)").foregroundColor(.red)
                                } else {
                                    Text(String(format: "%.2f:1", contrastRatio))
                                        .fontDesign(.monospaced)
                                }
                            }

                            HStack {
                                Text("WCAG AA:")
                                Spacer()
                                Text(meetsAA ? "✓ Pass" : "✗ Fail")
                                    .foregroundColor(meetsAA ? .green : .red)
                            }

                            HStack {
                                Text("WCAG AAA:")
                                Spacer()
                                Text(meetsAAA ? "✓ Pass" : "✗ Fail")
                                    .foregroundColor(meetsAAA ? .green : .red)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 27)
                                .fill(.regularMaterial)
                                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        )

                        CodeBlock(
                            code: """
                            let ratio = try GarnishMath.contrastRatio(between: color1, and: color2)
                            let meetsAA = GarnishMath.meetsWCAGAA(ratio)
                            let meetsAAA = GarnishMath.meetsWCAGAAA(ratio)
                            """,
                            colorMappings: [
                                "color1": color1,
                                "color2": color2
                            ]
                        )

                        if contrastRatioResult.error == nil {
                            // Visual demonstration
                            Text("Sample Text")
                                .foregroundColor(color1)
                                .padding()
                                .background(color2)
                                .clipShape(RoundedRectangle(cornerRadius: 27))
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Color Extensions Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ColorExtensionsDemo: View {
    @State private var baseColor = Color.blue
    @State private var brightnessAdjustment: Double = 0.2

    private var contrastingShadeResult: (color: Color?, error: String?) {
        do {
            let color = try baseColor.contrastingShade()
            return (color, nil)
        } catch {
            return (nil, error.localizedDescription)
        }
    }

    private var hexResult: (hex: String?, error: String?) {
        do {
            let hex = try baseColor.toHex()
            return (hex, nil)
        } catch {
            return (nil, error.localizedDescription)
        }
    }

    private var adjustBrightnessResult: (color: Color?, error: String?) {
        do {
            let color = try baseColor.adjustBrightness(by: CGFloat(brightnessAdjustment))
            return (color, nil)
        } catch {
            return (nil, error.localizedDescription)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                DemoSectionView(
                    title: "Color Adjustments",
                    description: "Modify colors using extensions"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Base Color", selection: $baseColor)

                        VStack {
                            Text("Brightness Adjustment: \(brightnessAdjustment, specifier: "%.2f")")
                            Slider(value: $brightnessAdjustment, in: -1...1, step: 0.1)
                        }

                        HStack(spacing: 20) {
                            ColorSwatch(color: baseColor, label: "Original")
                            if let adjustedColor = adjustBrightnessResult.color {
                                ColorSwatch(color: adjustedColor, label: "Adjusted")
                            } else {
                                VStack {
                                    Text("Error")
                                        .foregroundColor(.red)
                                        .font(.caption)
                                    if let error = adjustBrightnessResult.error {
                                        Text(error)
                                            .foregroundColor(.red)
                                            .font(.caption2)
                                            .multilineTextAlignment(.center)
                                    }
                                }
                                .frame(width: 80, height: 60)
                                .background(Color.red.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 27))
                            }
                        }

                        CodeBlock(
                            code: """
                            let adjustedColor = baseColor.adjustBrightness(by: \(String(format: "%.1f", brightnessAdjustment)))
                            """,
                            colorMappings: [
                                "adjustedColor": adjustBrightnessResult.color ?? .gray,
                                "baseColor": baseColor
                            ]
                        )
                    }
                }

                DemoSectionView(
                    title: "Convenience Methods",
                    description: "Easy-to-use instance methods"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Input Color", selection: $baseColor)

                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Hex Value:")
                                Spacer()
                                if let errorMessage = hexResult.error {
                                    Text("Error: \(errorMessage)").foregroundColor(.red)
                                } else if let hex = hexResult.hex {
                                    Text(hex)
                                        .fontDesign(.monospaced)
                                }
                            }

                            HStack {
                                Text("Contrasting Shade:")
                                Spacer()
                                if let errorMessage = contrastingShadeResult.error {
                                    Text("Error: \(errorMessage)").foregroundColor(.red)
                                } else if let color = contrastingShadeResult.color {
                                    Circle()
                                        .fill(color)
                                        .frame(width: 30, height: 30)
                                }
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 27)
                                .fill(.regularMaterial)
                                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        )
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Font Weight Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct FontWeightDemo: View {
    @State private var textColor = Color.primary
    @State private var backgroundColor = Color.white

    private var recommendedFontWeightResult: (weight: Font.Weight?, error: String?) {
        do {
            let weight = try textColor.recommendedFontWeight(against: backgroundColor)
            return (weight, nil)
        } catch {
            return (nil, error.localizedDescription)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                DemoSectionView(
                    title: "Recommended Font Weight",
                    description: "Optimal font weight based on contrast"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Text Color", selection: $textColor)
                        ColorPicker("Background Color", selection: $backgroundColor)

                        VStack(spacing: 10) {
                            if let fontWeight = recommendedFontWeightResult.weight {
                                Text("Sample Text")
                                    .font(.title2)
                                    .fontWeight(fontWeight)
                                    .foregroundColor(textColor)
                                    .padding()
                                    .background(backgroundColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 27))

                                Text("Recommended: \(fontWeight.description)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            } else if let errorMessage = recommendedFontWeightResult.error {
                                Text("Error: \(errorMessage)")
                                    .foregroundColor(.red)
                            }
                        }

                        CodeBlock(
                            code: """
                            let fontWeight = try textColor.recommendedFontWeight(against: backgroundColor)
                            """,
                            colorMappings: [
                                "textColor": textColor,
                                "backgroundColor": backgroundColor
                            ]
                        )
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Accessibility Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct AccessibilityDemo: View {
    @State private var foregroundColor = Color.black
    @State private var backgroundColor = Color.white

    private var contrastRatioResult: (value: Double?, error: String?) {
        if let value = GarnishMath.contrastRatio(between: foregroundColor, and: backgroundColor) {
            return (Double(value), nil)
        }
        return (nil, "Failed to calculate contrast ratio")
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 40) {
                DemoSectionView(
                    title: "WCAG Compliance",
                    description: "Check accessibility standards"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Foreground Color", selection: $foregroundColor)
                        ColorPicker("Background Color", selection: $backgroundColor)

                        let contrastRatio = contrastRatioResult.value ?? 1.0
                        let meetsAA = GarnishMath.meetsWCAGAA(contrastRatio)
                        let meetsAAA = GarnishMath.meetsWCAGAAA(contrastRatio)

                        // Visual test
                        if contrastRatioResult.error == nil {
                            VStack(spacing: 10) {
                                Text("Large Text Sample")
                                    .font(.title)
                                    .foregroundColor(foregroundColor)
                                    .padding()
                                    .background(backgroundColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 27))

                                Text("Normal text sample for readability testing")
                                    .font(.body)
                                    .foregroundColor(foregroundColor)
                                    .padding()
                                    .background(backgroundColor)
                                    .clipShape(RoundedRectangle(cornerRadius: 27))
                            }
                        }

                        // Compliance results
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Contrast Ratio:")
                                Spacer()
                                if let errorMessage = contrastRatioResult.error {
                                    Text("Error: \(errorMessage)").foregroundColor(.red)
                                } else {
                                    Text(String(format: "%.2f:1", contrastRatio))
                                        .fontDesign(.monospaced)
                                }
                            }

                            HStack {
                                Text("WCAG AA (4.5:1):")
                                Spacer()
                                Label(meetsAA ? "Pass" : "Fail", systemImage: meetsAA ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(meetsAA ? .green : .red)
                            }

                            HStack {
                                Text("WCAG AAA (7:1):")
                                Spacer()
                                Label(meetsAAA ? "Pass" : "Fail", systemImage: meetsAAA ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundColor(meetsAAA ? .green : .red)
                            }
                        }
                        .padding(20)
                        .background(
                            RoundedRectangle(cornerRadius: 27)
                                .fill(.regularMaterial)
                                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
                        )
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Helper Views
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct DemoSectionView<Content: View>: View {
    let title: String
    let description: String
    let content: Content

    init(title: String, description: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.description = description
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.primary)
                Text(description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(nil)
            }

            content
        }
        .safeAreaPadding(24)
        .background(
            RoundedRectangle(cornerRadius: 27)
                .fill(.background)
                .shadow(color: Color.black.opacity(0.02), radius: 1, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 27)
                .stroke(Color.primary.opacity(0.04), lineWidth: 0.5)
        )
    }
}

struct ColorSwatch: View {
    let color: Color
    let label: String

    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 15)
                .fill(color)
                .frame(width: 90, height: 70)
                .shadow(color: color.opacity(0.2), radius: 4, x: 0, y: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(
                            LinearGradient(
                                colors: [Color.white.opacity(0.3), Color.clear],
                                startPoint: .top,
                                endPoint: .bottom
                            ),
                            lineWidth: 1
                        )
                )

            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
    }
}

struct DirectionSwatch: View {
    let label: String
    let color: Color?
    let background: Color

    var body: some View {
        VStack(spacing: 8) {
            if let color = color {
                Text("Text")
                    .font(.caption.weight(.semibold))
                    .foregroundColor(color)
                    .padding(8)
                    .frame(width: 70)
                    .background(background)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                    )
            } else {
                Rectangle()
                    .fill(Color.secondary.opacity(0.2))
                    .frame(width: 70, height: 32)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            Text(label)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(width: 70)
        }
    }
}

@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct CodeBlock: View {
    let code: String
    let colorMappings: [String: Color]

    init(code: String, colorMappings: [String: Color] = [:]) {
        self.code = code
        self.colorMappings = colorMappings
    }

    private var attributedCode: AttributedString {
        var attrString = AttributedString(code)

        // Apply syntax highlighting for keywords
        let keywords = ["let", "var", "try", "func", "struct", "class", "enum", "import", "return"]
        for keyword in keywords {
            if let range = attrString.range(of: keyword) {
                attrString[range].foregroundColor = .purple
                attrString[range].font = .system(.callout, design: .monospaced, weight: .semibold)
            }
        }

        // Style specific type names manually for better reliability
        let typeNames = ["Garnish", "GarnishMath", "Color", "CGFloat", "Double"]
        for typeName in typeNames {
            if let range = attrString.range(of: typeName) {
                attrString[range].foregroundColor = .teal
                attrString[range].font = .system(.callout, design: .monospaced, weight: .medium)
            }
        }


        // Apply color mappings for variables (sort by length descending to avoid partial matches)
        let sortedMappings = colorMappings.sorted { $0.key.count > $1.key.count }
        for (variable, color) in sortedMappings {
            if let range = attrString.range(of: variable) {
                attrString[range].foregroundColor = color
                attrString[range].font = .system(.callout, design: .monospaced, weight: .medium)

                // Use Garnish to calculate contrasting background
                if let contrastingShade = try? Garnish.contrastingShade(of: color) {
                    attrString[range].backgroundColor = contrastingShade.opacity(0.7)
                } else {
                    attrString[range].backgroundColor = color.opacity(0.15)
                }
            }
        }

        return attrString
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Swift")
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundStyle(.secondary)
                Spacer()
                Image(systemName: "swift")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider()
                .padding(.horizontal, 16)

            Text(attributedCode)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(
            RoundedRectangle(cornerRadius: 17)
                .fill(.thickMaterial)
                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 17)
                .stroke(Color.primary.opacity(0.06), lineWidth: 0.5)
        )
    }
}

// MARK: - Font Weight Extension
extension Font.Weight {
    var description: String {
        switch self {
        case .ultraLight: return "Ultra Light"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        default: return "Unknown"
        }
    }
}

// MARK: - Preview
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
#Preview {
    GarnishDemoApp()
}

#endif
