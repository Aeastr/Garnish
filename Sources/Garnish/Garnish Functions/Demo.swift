//
//  GarnishTestView.swift
//  Garnish
//
//  Created by Aether on 15/12/2024.
//


import SwiftUI



@available(iOS 14.0, *)
struct GarnishTestViewLeg: View {
    @State private var inputColor: Color = Color(red: 1.0, green: 0.7, blue: 0.7)
    @State private var colorScheme: ColorScheme = .light
    
    var body: some View {
        NavigationView{
            VStack(spacing: 20) {
                
                // Input color selector
                VStack {
                    Text("Input Color")
                        .font(.headline)
                    ColorPicker("Select a color", selection: $inputColor)
                        .padding()
                }
                
                // Toggle between light and dark color schemes
                VStack {
                    Text("Environment Color Scheme")
                        .font(.headline)
                    Picker("Color Scheme", selection: $colorScheme) {
                        Text("Light").tag(ColorScheme.light)
                        Text("Dark").tag(ColorScheme.dark)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                }
                
                // Tinted Base Color
                HStack{
                    VStack {
                        Text("Background Base")
                            .font(.headline)
                        ColorRectangle(color: Garnish.adjustForBackground(for: inputColor, in: colorScheme))
                    }
                }
                .padding(.horizontal, 20)
                
                // Contrasting Foreground Color
                VStack {
                    Text("Contrasting Foreground Color")
                        .font(.headline)
                    let contrastingForeground = Garnish.contrastingForeground(for: inputColor)
                    ZStack {
                        ColorRectangle(color: inputColor)
                        Text("Foreground Color")
                            .foregroundColor(contrastingForeground)
                            .bold()
                    }
                }
                
                // Utility Tests
                VStack(spacing: 10) {
                    Text("Utility Tests")
                        .font(.headline)
                    
                    let luminance = Garnish.relativeLuminance(of: inputColor)
                    let brightness = Garnish.brightness(of: inputColor)
                    
                    Text("Relative Luminance: \(luminance, specifier: "%.2f")")
                    Text("Brightness: \(brightness, specifier: "%.2f")")
                    Text("Is Light Color: \(Garnish.isLightColor(inputColor) ? "Yes" : "No")")
                }
            }
            .navigationTitle("Garnish")
            .navigationBarTitleDisplayMode(.inline)
        }
        .colorScheme(colorScheme)
        .preferredColorScheme(colorScheme)
    }
}


struct ColorRectangle: View {
    let color: Color
    let outLineColor: Color
    let height: CGFloat
    
    init(color: Color, outLineColor: Color? = nil, height: CGFloat = 110) {
        self.color = color
        self.outLineColor = outLineColor ?? color.adjustedBrightness(by: 0.1)
        self.height = height
    }
    
    var body: some View {
        color
            .clipShape(.rect(cornerRadius: 25))
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .strokeBorder(outLineColor, lineWidth: 3)
            )
    }
}
