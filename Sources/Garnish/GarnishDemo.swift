//
//  GarnishDemo.swift
//  Garnish
//
//  Created by Aether on 19/12/2024.
//  Demo app showcasing the refactored Garnish API
//

import SwiftUI

@available(iOS 16.0, macOS 14.0, tvOS 16.0, watchOS 9.0, *)
public struct GarnishDemoApp: View {
    @State private var selectedDemo: DemoSection? = .coreAPI
    
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
                        .navigationBarTitleDisplayMode(.large)
                        #endif
                } else {
                    ContentUnavailableView(
                        "Select a Demo",
                        systemImage: "paintpalette",
                        description: Text("Choose a demo from the sidebar to see Garnish in action")
                    )
                }
            }
        }
    }
}

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
struct CoreAPIDemo: View {
    @State private var inputColor = Color.blue
    @State private var backgroundColor = Color.white
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                DemoSectionView(
                    title: "Monochromatic Contrast",
                    description: "Get a contrasting shade of the same color"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Input Color", selection: $inputColor)
                        
                        let contrastingShade = Garnish.contrastingShade(of: inputColor)
                        
                        HStack(spacing: 20) {
                            ColorSwatch(color: inputColor, label: "Original")
                            ColorSwatch(color: contrastingShade, label: "Contrasting Shade")
                        }
                        
                        CodeBlock(code: """
                        let contrastingShade = Garnish.contrastingShade(of: inputColor)
                        """)
                        
                        // Demo usage
                        VStack {
                            Text("Sample Text")
                                .foregroundColor(contrastingShade)
                                .padding()
                                .background(inputColor)
                                .cornerRadius(8)
                        }
                    }
                }
                
                DemoSectionView(
                    title: "Bi-chromatic Contrast",
                    description: "Optimize one color against another"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Foreground Color", selection: $inputColor)
                        ColorPicker("Background Color", selection: $backgroundColor)
                        
                        let optimizedColor = Garnish.contrastingColor(of: inputColor, against: backgroundColor)
                        
                        HStack(spacing: 20) {
                            ColorSwatch(color: inputColor, label: "Original")
                            ColorSwatch(color: optimizedColor, label: "Optimized")
                        }
                        
                        CodeBlock(code: """
                        let optimizedColor = Garnish.contrastingColor(of: inputColor, against: backgroundColor)
                        """)
                        
                        // Demo usage
                        VStack {
                            Text("Sample Text")
                                .foregroundColor(optimizedColor)
                                .padding()
                                .background(backgroundColor)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Math Utilities Demo
struct MathUtilitiesDemo: View {
    @State private var color1 = Color.blue
    @State private var color2 = Color.red
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                DemoSectionView(
                    title: "Color Analysis",
                    description: "Mathematical properties of colors"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Color to Analyze", selection: $color1)
                        
                        let luminance = try? GarnishMath.relativeLuminance(of: color1)
                        let brightness = try? GarnishMath.brightness(of: color1)
                        let colorScheme = GarnishMath.colorScheme(for: color1)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Relative Luminance:")
                                Spacer()
                                Text(String(format: "%.3f", luminance ?? 0))
                                    .fontDesign(.monospaced)
                            }
                            
                            HStack {
                                Text("Brightness:")
                                Spacer()
                                Text(String(format: "%.3f", brightness ?? 0))
                                    .fontDesign(.monospaced)
                            }
                            
                            HStack {
                                Text("Color Scheme:")
                                Spacer()
                                Text(colorScheme == .light ? "Light" : "Dark")
                            }
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
                
                DemoSectionView(
                    title: "Contrast Ratio",
                    description: "WCAG contrast ratio between two colors"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Color 1", selection: $color1)
                        ColorPicker("Color 2", selection: $color2)
                        
                        let contrastRatio = (try? GarnishMath.contrastRatio(between: color1, and: color2)) ?? 1.0
                        let meetsAA = GarnishMath.meetsWCAGAA(contrastRatio)
                        let meetsAAA = GarnishMath.meetsWCAGAAA(contrastRatio)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Contrast Ratio:")
                                Spacer()
                                Text(String(format: "%.2f:1", contrastRatio))
                                    .fontDesign(.monospaced)
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
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                        
                        // Visual demonstration
                        Text("Sample Text")
                            .foregroundColor(color1)
                            .padding()
                            .background(color2)
                            .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Color Extensions Demo
struct ColorExtensionsDemo: View {
    @State private var baseColor = Color.blue
    @State private var brightnessAdjustment: Double = 0.2
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
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
                        
                        let adjustedColor = baseColor.adjustedBrightness(by: CGFloat(brightnessAdjustment))
                        
                        HStack(spacing: 20) {
                            ColorSwatch(color: baseColor, label: "Original")
                            ColorSwatch(color: adjustedColor, label: "Adjusted")
                        }
                        
                        CodeBlock(code: """
                        let adjustedColor = baseColor.adjustedBrightness(by: \(String(format: "%.1f", brightnessAdjustment)))
                        """)
                    }
                }
                
                DemoSectionView(
                    title: "Convenience Methods",
                    description: "Easy-to-use instance methods"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Input Color", selection: $baseColor)
                        
                        let contrastingShade = baseColor.contrastingShade()
                        let hexString = (try? baseColor.toHex()) ?? "#000000"
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Hex Value:")
                                Spacer()
                                Text(hexString)
                                    .fontDesign(.monospaced)
                            }
                            
                            HStack {
                                Text("Contrasting Shade:")
                                Spacer()
                                Circle()
                                    .fill(contrastingShade)
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Font Weight Demo
struct FontWeightDemo: View {
    @State private var textColor = Color.primary
    @State private var backgroundColor = Color.white
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                DemoSectionView(
                    title: "Recommended Font Weight",
                    description: "Optimal font weight based on contrast"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Text Color", selection: $textColor)
                        ColorPicker("Background Color", selection: $backgroundColor)
                        
                        let fontWeight = (try? textColor.recommendedFontWeight(against: backgroundColor)) ?? .regular
                        
                        VStack(spacing: 10) {
                            Text("Sample Text")
                                .font(.title2)
                                .fontWeight(fontWeight)
                                .foregroundColor(textColor)
                                .padding()
                                .background(backgroundColor)
                                .cornerRadius(8)
                            
                            Text("Recommended: \(fontWeight.description)")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        CodeBlock(code: """
                        let fontWeight = try textColor.recommendedFontWeight(against: backgroundColor)
                        """)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Accessibility Demo
struct AccessibilityDemo: View {
    @State private var foregroundColor = Color.black
    @State private var backgroundColor = Color.white
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                DemoSectionView(
                    title: "WCAG Compliance",
                    description: "Check accessibility standards"
                ) {
                    VStack(spacing: 15) {
                        ColorPicker("Foreground Color", selection: $foregroundColor)
                        ColorPicker("Background Color", selection: $backgroundColor)
                        
                        let contrastRatio = (try? GarnishMath.contrastRatio(between: foregroundColor, and: backgroundColor)) ?? 1.0
                        let meetsAA = GarnishMath.meetsWCAGAA(contrastRatio)
                        let meetsAAA = GarnishMath.meetsWCAGAAA(contrastRatio)
                        
                        // Visual test
                        VStack(spacing: 10) {
                            Text("Large Text Sample")
                                .font(.title)
                                .foregroundColor(foregroundColor)
                                .padding()
                                .background(backgroundColor)
                                .cornerRadius(8)
                            
                            Text("Normal text sample for readability testing")
                                .font(.body)
                                .foregroundColor(foregroundColor)
                                .padding()
                                .background(backgroundColor)
                                .cornerRadius(8)
                        }
                        
                        // Compliance results
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Contrast Ratio:")
                                Spacer()
                                Text(String(format: "%.2f:1", contrastRatio))
                                    .fontDesign(.monospaced)
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
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Helper Views
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
        VStack(alignment: .leading, spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            content
        }
        .padding()
        .background(Color.secondary.opacity(0.05))
        .cornerRadius(12)
    }
}

struct ColorSwatch: View {
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 80, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                )
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct CodeBlock: View {
    let code: String
    
    var body: some View {
        Text(code)
            .font(.system(.caption, design: .monospaced))
            .padding(8)
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(6)
            .frame(maxWidth: .infinity, alignment: .leading)
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
@available(iOS 16.0, macOS 14.0, tvOS 16.0, watchOS 9.0, *)
#Preview {
    GarnishDemoApp()
}
