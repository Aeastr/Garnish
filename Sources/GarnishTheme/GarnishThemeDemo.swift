//
//  GarnishThemeDemo.swift
//  GarnishTheme
//
//  Created by Aether on 06/08/2025.
//  Demo app showcasing the GarnishTheme API
//

#if DEBUG

import SwiftUI
import CoreData

// MARK: - Demo Built-in Themes
// These are example themes that demonstrate how users would define their own built-in themes
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
private extension GarnishThemeDemoApp {
    static func setupDemoThemes() {
        // Example built-in themes for demo purposes
        let defaultTheme = BuiltInTheme(name: "Default")
        defaultTheme.setColor(.primary, Color.blue, for: .light)
        defaultTheme.setColor(.secondary, Color.green, for: .light)
        defaultTheme.setColor(.tertiary, Color.orange, for: .light)
        defaultTheme.setColor(.backgroundColor, Color.white, for: .light)
        defaultTheme.setColor(.primary, Color.blue.opacity(0.8), for: .dark)
        defaultTheme.setColor(.secondary, Color.green.opacity(0.8), for: .dark)
        defaultTheme.setColor(.tertiary, Color.orange.opacity(0.8), for: .dark)
        defaultTheme.setColor(.backgroundColor, Color.black, for: .dark)
        
        let darkTheme = BuiltInTheme(name: "Dark")
        darkTheme.setColor(.primary, Color.white, for: .light)
        darkTheme.setColor(.secondary, Color.gray, for: .light)
        darkTheme.setColor(.tertiary, Color.blue, for: .light)
        darkTheme.setColor(.backgroundColor, Color(red: 0.95, green: 0.95, blue: 0.95), for: .light)
        darkTheme.setColor(.primary, Color.white, for: .dark)
        darkTheme.setColor(.secondary, Color.gray.opacity(0.7), for: .dark)
        darkTheme.setColor(.tertiary, Color.blue.opacity(0.9), for: .dark)
        darkTheme.setColor(.backgroundColor, Color(red: 0.1, green: 0.1, blue: 0.1), for: .dark)
        
        let oceanTheme = BuiltInTheme(name: "Ocean")
        oceanTheme.setColor(.primary, Color(red: 0.0, green: 0.5, blue: 0.8), for: .light)
        oceanTheme.setColor(.secondary, Color(red: 0.0, green: 0.7, blue: 0.6), for: .light)
        oceanTheme.setColor(.tertiary, Color(red: 0.4, green: 0.8, blue: 1.0), for: .light)
        oceanTheme.setColor(.backgroundColor, Color(red: 0.97, green: 0.99, blue: 1.0), for: .light)
        oceanTheme.setColor(.primary, Color(red: 0.2, green: 0.6, blue: 0.9), for: .dark)
        oceanTheme.setColor(.secondary, Color(red: 0.1, green: 0.8, blue: 0.7), for: .dark)
        oceanTheme.setColor(.tertiary, Color(red: 0.5, green: 0.9, blue: 1.0), for: .dark)
        oceanTheme.setColor(.backgroundColor, Color(red: 0.05, green: 0.1, blue: 0.15), for: .dark)
        
        let roseTheme = BuiltInTheme(name: "Rose")
        roseTheme.setColor(.primary, Color(red: 0.9, green: 0.4, blue: 0.6), for: .light)      // Soft rose pink
        roseTheme.setColor(.secondary, Color(red: 0.8, green: 0.5, blue: 0.7), for: .light)   // Muted lavender pink
        roseTheme.setColor(.tertiary, Color(red: 0.7, green: 0.3, blue: 0.5), for: .light)    // Deeper rose
        roseTheme.setColor(.backgroundColor, Color(red: 0.99, green: 0.97, blue: 0.98), for: .light) // Very light rose tint
        roseTheme.setColor(.primary, Color(red: 0.95, green: 0.6, blue: 0.75), for: .dark)    // Brighter rose for dark mode
        roseTheme.setColor(.secondary, Color(red: 0.85, green: 0.65, blue: 0.8), for: .dark)  // Soft pink-purple
        roseTheme.setColor(.tertiary, Color(red: 0.8, green: 0.5, blue: 0.65), for: .dark)    // Medium rose
        roseTheme.setColor(.backgroundColor, Color(red: 0.15, green: 0.1, blue: 0.12), for: .dark) // Dark with rose undertone
        
        // Register the demo themes
        GarnishTheme.registerBuiltInTheme(defaultTheme)
        GarnishTheme.registerBuiltInTheme(darkTheme)
        GarnishTheme.registerBuiltInTheme(oceanTheme)
        GarnishTheme.registerBuiltInTheme(roseTheme)
    }
}

@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct GarnishThemeDemoApp: View {
    @State private var selectedDemo: ThemeDemoSection?
    
    public init() {
        // Set up demo themes for demonstration
        Self.setupDemoThemes()
    }
    
    public var body: some View {
        NavigationSplitView {
            // Sidebar
            List(ThemeDemoSection.allCases, id: \.self, selection: $selectedDemo) { section in
                Label(section.title, systemImage: section.icon)
                    .tag(section)
            }
            .navigationTitle("GarnishTheme Demo")
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
                            systemImage: "paintpalette.fill",
                            description: Text("Choose a demo from the sidebar to see GarnishTheme in action")
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
enum ThemeDemoSection: CaseIterable {
    case registeringThemes
    case builtInThemes
    case currentThemeAPI
    case customThemes
    case colorKeysSystem
    case themeComparison
    
    var title: String {
        switch self {
        case .registeringThemes: return "Registering Themes"
        case .builtInThemes: return "Built-in Themes"
        case .currentThemeAPI: return "Current Theme API"
        case .customThemes: return "Custom Themes"
        case .colorKeysSystem: return "Color Keys System"
        case .themeComparison: return "Theme Comparison"
        }
    }
    
    var icon: String {
        switch self {
        case .registeringThemes: return "plus.app.fill"
        case .builtInThemes: return "swatchpalette.fill"
        case .currentThemeAPI: return "gear.circle.fill"
        case .customThemes: return "plus.circle.fill"
        case .colorKeysSystem: return "key.fill"
        case .themeComparison: return "rectangle.2.swap"
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .registeringThemes: RegisteringThemesDemo()
        case .builtInThemes: BuiltInThemesDemo()
        case .currentThemeAPI: CurrentThemeAPIDemo()
        case .customThemes: CustomThemesDemo()
        case .colorKeysSystem: ColorKeysSystemDemo()
        case .themeComparison: ThemeComparisonDemo()
        }
    }
}

// MARK: - Registering Themes Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct RegisteringThemesDemo: View {
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemeDemoSectionView(
                    title: "How Built-in Themes Work",
                    description: "GarnishTheme doesn't provide predefined themes - you define your own built-in themes for your app"
                ) {
                    VStack(spacing: 20) {
                        ThemeCodeBlock(
                            code: """
                            // 1. Create your theme
                            let myTheme = BuiltInTheme(name: "MyAppTheme")
                            
                            // 2. Define colors for light mode
                            myTheme.setColor(.primary, Color.blue, for: .light)
                            myTheme.setColor(.secondary, Color.green, for: .light)
                            myTheme.setColor(.backgroundColor, Color.white, for: .light)
                            
                            // 3. Define colors for dark mode
                            myTheme.setColor(.primary, Color.cyan, for: .dark)
                            myTheme.setColor(.secondary, Color.mint, for: .dark)
                            myTheme.setColor(.backgroundColor, Color.black, for: .dark)
                            
                            // 4. Register it with GarnishTheme
                            GarnishTheme.registerBuiltInTheme(myTheme)
                            """,
                            themeName: "Registration"
                        )
                        
                        Text("Built-in themes are perfect for app-specific themes that don't need user customization.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                ThemeDemoSectionView(
                    title: "Registration Methods",
                    description: "API for managing built-in themes in your app"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            // Register a theme
                            GarnishTheme.registerBuiltInTheme(theme)
                            
                            // Get a registered theme
                            let theme = GarnishTheme.builtin("MyTheme")
                            
                            // List all registered themes
                            let themeNames = GarnishTheme.builtInThemeNames
                            
                            // Remove a theme
                            GarnishTheme.unregisterBuiltInTheme(named: "MyTheme")
                            """,
                            themeName: "API"
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Currently Registered:")
                                Spacer()
                                Text("\(GarnishTheme.builtInThemeNames.count) themes")
                                    .fontDesign(.monospaced)
                                    .foregroundColor(.secondary)
                            }
                            
                            if !GarnishTheme.builtInThemeNames.isEmpty {
                                ForEach(GarnishTheme.builtInThemeNames, id: \.self) { themeName in
                                    HStack {
                                        Text("• \(themeName)")
                                            .font(.caption)
                                        Spacer()
                                        Text("Built-in")
                                            .font(.caption2)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.blue.opacity(0.1))
                                            .clipShape(Capsule())
                                    }
                                }
                            } else {
                                Text("No themes registered")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                    .italic()
                            }
                        }
                        .padding(16)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(.regularMaterial)
                                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
                        )
                    }
                }
                
                ThemeDemoSectionView(
                    title: "Demo Theme Setup",
                    description: "This demo registers example themes to showcase the functionality"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            // This demo app registers these example themes:
                            
                            private func setupDemoThemes() {
                                let defaultTheme = BuiltInTheme(name: "Default")
                                // ... configure colors ...
                                GarnishTheme.registerBuiltInTheme(defaultTheme)
                                
                                let darkTheme = BuiltInTheme(name: "Dark")
                                // ... configure colors ...
                                GarnishTheme.registerBuiltInTheme(darkTheme)
                                
                                let oceanTheme = BuiltInTheme(name: "Ocean")
                                // ... configure colors ...
                                GarnishTheme.registerBuiltInTheme(oceanTheme)
                            }
                            """,
                            themeName: "Demo Setup"
                        )
                        
                        Text("In your actual app, you would register your themes during app launch, typically in your App's init or a setup function.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Built-in Themes Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct BuiltInThemesDemo: View {
    @State private var selectedThemeName: String = "Default"
    
    private var availableThemes: [String] {
        GarnishTheme.availableBuiltInThemes
    }
    
    private var selectedTheme: BuiltInTheme? {
        GarnishTheme.builtin(selectedThemeName)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemeDemoSectionView(
                    title: "Theme Gallery",
                    description: "Explore all built-in themes and their color palettes"
                ) {
                    VStack(spacing: 20) {
                        Picker("Theme", selection: $selectedThemeName) {
                            ForEach(availableThemes, id: \.self) { themeName in
                                Text(themeName).tag(themeName)
                            }
                        }
                        .pickerStyle(.segmented)
                        
                        if let theme = selectedTheme {
                            VStack(spacing: 15) {
                                ThemeCodeBlock(
                                    code: """
                                    let theme = GarnishTheme.builtin("\(theme.name)")!
                                    let primaryLight = try theme.color(for: .primary, in: .light)
                                    """,
                                    themeName: theme.name
                                )
                                
                                Divider()
                                
                                // Color palette display
                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Text("Color Palette")
                                            .font(.headline)
                                            .fontWeight(.medium)
                                        Spacer()
                                    }
                                    
                                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 15) {
                                        ForEach([ColorKey.primary, .secondary, .tertiary, .backgroundColor], id: \.self) { colorKey in
                                            ThemeColorSwatch(
                                                theme: theme,
                                                colorKey: colorKey,
                                                title: colorKey.stringValue.capitalized
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                
                ThemeDemoSectionView(
                    title: "Theme Switching",
                    description: "Dynamically switch between themes at runtime"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            try GarnishTheme.setCurrentTheme(GarnishTheme.builtin("Ocean")!)
                            let current = GarnishTheme.current
                            """,
                            themeName: "Ocean"
                        )
                        
                        Button("Set as Current Theme") {
                            if let theme = selectedTheme {
                                do {
                                    try GarnishTheme.setCurrentTheme(theme)
                                } catch {
                                    print("Failed to set theme: \(error)")
                                }
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(selectedTheme == nil)
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Current Theme API Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct CurrentThemeAPIDemo: View {
    @State private var colorScheme: ColorScheme = .light
    @State private var selectedColorKey: ColorKey = .primary
    
    private var currentColor: Color? {
        do {
            return try GarnishTheme.current.color(selectedColorKey, for: colorScheme)
        } catch {
            return nil
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemeDemoSectionView(
                    title: "Current Theme Access",
                    description: "Fast access to current theme colors with automatic caching"
                ) {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            Text("Current Theme: \(GarnishTheme.current.name)")
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("Built-in: \(GarnishTheme.current.isBuiltIn ? "Yes" : "No")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        ThemeCodeBlock(
                            code: """
                            // Fast access to current theme
                            let currentTheme = GarnishTheme.current
                            let primaryColor = try currentTheme.primary(for: .light)
                            """,
                            themeName: GarnishTheme.current.name
                        )
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Color Scheme:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Picker("Color Scheme", selection: $colorScheme) {
                                    Text("Light").tag(ColorScheme.light)
                                    Text("Dark").tag(ColorScheme.dark)
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 150)
                            }
                            
                            HStack {
                                Text("Color Key:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Picker("Color Key", selection: $selectedColorKey) {
                                    Text("Primary").tag(ColorKey.primary)
                                    Text("Secondary").tag(ColorKey.secondary)
                                    Text("Tertiary").tag(ColorKey.tertiary)
                                    Text("Background").tag(ColorKey.backgroundColor)
                                }
                                .pickerStyle(.menu)
                            }
                            
                            if let color = currentColor {
                                CurrentThemeColorDisplay(
                                    color: color,
                                    colorKey: selectedColorKey,
                                    colorScheme: colorScheme
                                )
                            }
                        }
                    }
                }
                
                ThemeDemoSectionView(
                    title: "Convenience Methods",
                    description: "Quick access methods for common theme operations"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            // Convenience methods for standard colors
                            let primary = try GarnishTheme.current.primary(for: .light)
                            let secondary = try GarnishTheme.current.secondary(for: .dark)
                            let background = try GarnishTheme.current.backgroundColor(for: .light)
                            """,
                            themeName: GarnishTheme.current.name
                        )
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                            ConvenienceMethodDemo(
                                title: "Primary Light",
                                code: "current.primary(for: .light)"
                            ) {
                                try? GarnishTheme.current.primary(for: .light)
                            }
                            
                            ConvenienceMethodDemo(
                                title: "Secondary Dark",
                                code: "current.secondary(for: .dark)"
                            ) {
                                try? GarnishTheme.current.secondary(for: .dark)
                            }
                            
                            ConvenienceMethodDemo(
                                title: "Background Light",
                                code: "current.backgroundColor(for: .light)"
                            ) {
                                try? GarnishTheme.current.backgroundColor(for: .light)
                            }
                            
                            ConvenienceMethodDemo(
                                title: "Tertiary Dark",
                                code: "current.tertiary(for: .dark)"
                            ) {
                                try? GarnishTheme.current.tertiary(for: .dark)
                            }
                        }
                    }
                }
            }
            .padding()
        }
    }
}

// MARK: - Custom Themes Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct CustomThemesDemo: View {
    @State private var themeName: String = ""
    @State private var primaryLightColor = Color.blue
    @State private var primaryDarkColor = Color.cyan
    @State private var secondaryLightColor = Color.gray
    @State private var secondaryDarkColor = Color.white
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemeDemoSectionView(
                    title: "Create Custom Theme",
                    description: "Build your own theme with custom colors and persist to CoreData"
                ) {
                    VStack(spacing: 20) {
                        ThemeCodeBlock(
                            code: """
                            // Create and save a custom theme
                            let customTheme = try GarnishTheme.createUserTheme(
                                named: "MyTheme",
                                colors: [
                                    .primary: [.light: primaryLightColor, .dark: primaryDarkColor]
                                ]
                            )
                            """,
                            themeName: "Custom"
                        )
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 15) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Theme Name")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                TextField("Enter theme name", text: $themeName)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Primary Colors")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Light")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        ColorPicker("", selection: $primaryLightColor, supportsOpacity: false)
                                            .labelsHidden()
                                            .frame(height: 40)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Dark")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        ColorPicker("", selection: $primaryDarkColor, supportsOpacity: false)
                                            .labelsHidden()
                                            .frame(height: 40)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Secondary Colors")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                
                                HStack(spacing: 16) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Light")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        ColorPicker("", selection: $secondaryLightColor, supportsOpacity: false)
                                            .labelsHidden()
                                            .frame(height: 40)
                                    }
                                    .frame(maxWidth: .infinity)
                                    
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Dark")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                        ColorPicker("", selection: $secondaryDarkColor, supportsOpacity: false)
                                            .labelsHidden()
                                            .frame(height: 40)
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            
                            // Theme preview
                            CustomThemePreview(
                                primaryLight: primaryLightColor,
                                primaryDark: primaryDarkColor,
                                secondaryLight: secondaryLightColor,
                                secondaryDark: secondaryDarkColor
                            )
                            
                            Button("Create Theme") {
                                createCustomTheme()
                            }
                            .buttonStyle(.borderedProminent)
                            .disabled(themeName.isEmpty)
                        }
                    }
                }
                
                ThemeDemoSectionView(
                    title: "Manage Custom Themes",
                    description: "List and manage your saved custom themes"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            // Load user themes from CoreData
                            let userThemes = try GarnishTheme.loadUserThemes()
                            for theme in userThemes {
                                print("Theme: \\(theme.name!)")
                            }
                            """,
                            themeName: "Management"
                        )
                        
                        Button("Load Custom Themes") {
                            loadCustomThemes()
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .padding()
        }
        .alert("Theme Creation", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func createCustomTheme() {
        do {
            let colors: [ColorKey: [ColorScheme: Color]] = [
                .primary: [.light: primaryLightColor, .dark: primaryDarkColor],
                .secondary: [.light: secondaryLightColor, .dark: secondaryDarkColor]
            ]
            
            let _ = try GarnishTheme.createUserTheme(named: themeName, colors: colors)
            alertMessage = "Successfully created theme '\(themeName)'"
            showingAlert = true
            themeName = ""
        } catch {
            alertMessage = "Failed to create theme: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func loadCustomThemes() {
        do {
            let themes = try GarnishTheme.loadUserThemes()
            alertMessage = "Found \(themes.count) custom theme(s)"
            showingAlert = true
        } catch {
            alertMessage = "Failed to load themes: \(error.localizedDescription)"
            showingAlert = true
        }
    }
}

// MARK: - Color Keys System Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ColorKeysSystemDemo: View {
    @State private var customKeyName: String = ""
    @State private var selectedStandardKey: ColorKey = .primary
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemeDemoSectionView(
                    title: "Standard Color Keys",
                    description: "Built-in color keys with type safety"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            // Standard color keys
                            let primary = ColorKey.primary
                            let secondary = ColorKey.secondary
                            let tertiary = ColorKey.tertiary
                            let background = ColorKey.backgroundColor
                            """,
                            themeName: "ColorKey"
                        )
                        
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 1), spacing: 12) {
                            ForEach([ColorKey.primary, .secondary, .tertiary, .backgroundColor], id: \.self) { key in
                                ColorKeyInfoCard(colorKey: key)
                            }
                        }
                    }
                }
                
                ThemeDemoSectionView(
                    title: "Custom Color Keys",
                    description: "Extend themes with your own custom color keys"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            // Custom color keys
                            let accentKey = ColorKey.custom("accent")
                            let warningKey = ColorKey.custom("warning")
                            
                            // String conversion
                            print(accentKey.stringValue) // "accent"
                            print(accentKey.isStandard) // false
                            """,
                            themeName: "Custom"
                        )
                        
                        VStack(alignment: .leading, spacing: 12) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text("Custom Key Name")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    Spacer()
                                }
                                TextField("Enter custom key name", text: $customKeyName)
                                    .textFieldStyle(.roundedBorder)
                            }
                            
                            if !customKeyName.isEmpty {
                                let customKey = ColorKey.custom(customKeyName)
                                ColorKeyInfoCard(colorKey: customKey)
                            }
                        }
                    }
                }
                
                ThemeDemoSectionView(
                    title: "ColorKey Extensions",
                    description: "Useful extensions for working with color keys"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            // String conversion
                            let key = ColorKey(from: "primary") // .primary
                            let customKey = ColorKey(from: "accent") // .custom("accent")
                            
                            // Properties
                            print(key.stringValue) // "primary"
                            print(key.isStandard) // true
                            """,
                            themeName: "Extensions"
                        )
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("Selected Key:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Picker("Key", selection: $selectedStandardKey) {
                                    Text("Primary").tag(ColorKey.primary)
                                    Text("Secondary").tag(ColorKey.secondary)
                                    Text("Tertiary").tag(ColorKey.tertiary)
                                    Text("Background").tag(ColorKey.backgroundColor)
                                }
                                .pickerStyle(.menu)
                            }
                            
                            HStack {
                                Text("String Value:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Text("\"\(selectedStandardKey.stringValue)\"")
                                    .fontDesign(.monospaced)
                                    .foregroundColor(.secondary)
                            }
                            
                            HStack {
                                Text("Is Standard:")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                Spacer()
                                Text(selectedStandardKey.isStandard ? "true" : "false")
                                    .fontDesign(.monospaced)
                                    .foregroundColor(selectedStandardKey.isStandard ? .green : .orange)
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

// MARK: - Theme Comparison Demo
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ThemeComparisonDemo: View {
    @State private var firstTheme: String = "Default"
    @State private var secondTheme: String = "Dark"
    @State private var colorScheme: ColorScheme = .light
    
    private var availableThemes: [String] {
        GarnishTheme.availableBuiltInThemes
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                ThemeDemoSectionView(
                    title: "Side-by-Side Comparison",
                    description: "Compare different themes and color schemes"
                ) {
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            HStack {
                                Picker("First Theme", selection: $firstTheme) {
                                    ForEach(availableThemes, id: \.self) { theme in
                                        Text(theme).tag(theme)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity)
                                
                                Text("vs")
                                    .font(.title2)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                
                                Picker("Second Theme", selection: $secondTheme) {
                                    ForEach(availableThemes, id: \.self) { theme in
                                        Text(theme).tag(theme)
                                    }
                                }
                                .pickerStyle(.menu)
                                .frame(maxWidth: .infinity)
                            }
                            
                            Picker("Color Scheme", selection: $colorScheme) {
                                Text("Light").tag(ColorScheme.light)
                                Text("Dark").tag(ColorScheme.dark)
                            }
                            .pickerStyle(.segmented)
                        }
                        
                        HStack(spacing: 15) {
                            if let theme1 = GarnishTheme.builtin(firstTheme) {
                                ThemeComparisonCard(theme: theme1, colorScheme: colorScheme)
                            }
                            
                            if let theme2 = GarnishTheme.builtin(secondTheme) {
                                ThemeComparisonCard(theme: theme2, colorScheme: colorScheme)
                            }
                        }
                    }
                }
                
                ThemeDemoSectionView(
                    title: "Theme Testing",
                    description: "Test theme readability and accessibility"
                ) {
                    VStack(spacing: 15) {
                        ThemeCodeBlock(
                            code: """
                            // Test theme combinations
                            let theme = GarnishTheme.builtin("\\(firstTheme)")!
                            let primary = try theme.primary(for: .\\(colorScheme == .light ? "light" : "dark"))
                            let background = try theme.backgroundColor(for: .\\(colorScheme == .light ? "light" : "dark"))
                            """,
                            themeName: firstTheme
                        )
                        
                        if let theme = GarnishTheme.builtin(firstTheme) {
                            ThemeTestingInterface(theme: theme, colorScheme: colorScheme)
                        }
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
struct ThemeDemoSectionView<Content: View>: View {
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
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ThemeColorSwatch: View {
    let theme: BuiltInTheme
    let colorKey: ColorKey
    let title: String
    
    private var lightColor: Color? {
        try? theme.color(colorKey, for: .light)
    }
    
    private var darkColor: Color? {
        try? theme.color(colorKey, for: .dark)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            // Title
            HStack {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            // Color squares
            HStack(spacing: 12) {
                if let lightColor = lightColor {
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(lightColor)
                            .frame(height: 60)
                            .shadow(color: lightColor.opacity(0.3), radius: 3, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                            )
                        Text("Light")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
                if let darkColor = darkColor {
                    VStack(spacing: 8) {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(darkColor)
                            .frame(height: 60)
                            .shadow(color: darkColor.opacity(0.3), radius: 3, x: 0, y: 2)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                            )
                        Text("Dark")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                
            }
        }
        .padding(.top, 16)
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
    }
}
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ThemeCodeBlock: View {
    let code: String
    let themeName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("Swift - \(themeName)")
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
            
            Text(code)
                .font(.system(.callout, design: .monospaced))
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
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct CurrentThemeColorDisplay: View {
    let color: Color
    let colorKey: ColorKey
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("\(colorKey.stringValue.capitalized) - \(colorScheme == .light ? "Light" : "Dark") Mode")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                Spacer()
            }
            
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color)
                    .frame(width: 60, height: 40)
                    .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 2)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Sample Text")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(color)
                    
                    Text("Preview with current color")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
    }
}
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ConvenienceMethodDemo: View {
    let title: String
    let code: String
    let colorProvider: () -> Color?
    
    var body: some View {
        VStack(spacing: 8) {
            if let color = colorProvider() {
                Circle()
                    .fill(color)
                    .frame(width: 50, height: 50)
                    .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 2)
            } else {
                Circle()
                    .fill(.red.opacity(0.3))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                    )
            }
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
            
            Text(code)
                .font(.caption2)
                .fontDesign(.monospaced)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.02), radius: 1, x: 0, y: 1)
        )
    }
}
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct CustomThemePreview: View {
    let primaryLight: Color
    let primaryDark: Color
    let secondaryLight: Color
    let secondaryDark: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Preview")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
            }
            
            VStack(spacing: 12) {
                // Primary colors
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Primary")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(primaryLight)
                                .frame(width: 60, height: 40)
                                .shadow(color: primaryLight.opacity(0.3), radius: 3, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                                )
                            Text("Light")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(primaryDark)
                                .frame(width: 60, height: 40)
                                .shadow(color: primaryDark.opacity(0.3), radius: 3, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                                )
                            Text("Dark")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
                
                // Secondary colors
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Secondary")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                        Spacer()
                    }
                    
                    HStack(spacing: 12) {
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(secondaryLight)
                                .frame(width: 60, height: 40)
                                .shadow(color: secondaryLight.opacity(0.3), radius: 3, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                                )
                            Text("Light")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(secondaryDark)
                                .frame(width: 60, height: 40)
                                .shadow(color: secondaryDark.opacity(0.3), radius: 3, x: 0, y: 2)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary.opacity(0.1), lineWidth: 0.5)
                                )
                            Text("Dark")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
    }
}
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ColorKeyInfoCard: View {
    let colorKey: ColorKey
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: colorKey.isStandard ? "key.fill" : "key.horizontal.fill")
                .font(.title2)
                .foregroundColor(colorKey.isStandard ? .blue : .orange)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(colorKey.stringValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                
                Text(colorKey.isStandard ? "Standard Key" : "Custom Key")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Text(colorKey.isStandard ? "Standard" : "Custom")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(colorKey.isStandard ? .blue : .orange)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(colorKey.isStandard ? Color.blue.opacity(0.1) : Color.orange.opacity(0.1))
                )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
    }
}
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ThemeComparisonCard: View {
    let theme: BuiltInTheme
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack(spacing: 12) {
            Text(theme.name)
                .font(.headline)
                .fontWeight(.semibold)
            
            VStack(spacing: 8) {
                ForEach([ColorKey.primary, .secondary, .tertiary], id: \.self) { key in
                    if let color = try? theme.color(key, for: colorScheme) {
                        HStack {
                            Text(key.stringValue.capitalized)
                                .font(.caption)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Circle()
                                .fill(color)
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.03), radius: 2, x: 0, y: 1)
        )
        .frame(maxWidth: .infinity)
    }
}
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
struct ThemeTestingInterface: View {
    let theme: BuiltInTheme
    let colorScheme: ColorScheme
    
    var body: some View {
        VStack(spacing: 15) {
            if let primary = try? theme.primary(for: colorScheme),
               let background = try? theme.backgroundColor(for: colorScheme) {
                
                Text("Sample heading text for readability testing")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(primary)
                    .padding()
                    .background(background)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Text("This is body text to test the theme's readability in different contexts. It should be easy to read and provide good contrast.")
                    .font(.body)
                    .foregroundColor(primary)
                    .padding()
                    .background(background)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .multilineTextAlignment(.center)
            }
        }
    }
}

// MARK: - Preview
@available(iOS 17, macOS 14.0, visionOS 1.0, *)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
#Preview {
    GarnishThemeDemoApp()
        .environment(\.managedObjectContext, GarnishThemePersistence.shared.persistentContainer.viewContext)
}

#endif
