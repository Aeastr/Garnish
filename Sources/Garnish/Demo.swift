//
//  GarnishTestView.swift
//  Garnish
//
//  Created by Aether on 15/12/2024.
//


import SwiftUI

@available(iOS 16.4, *)
struct GarnishTestView: View {
    @State private var inputColor: Color = Color(red: 0.8, green: 0.3, blue: 0.2)
    @State private var colorScheme: ColorScheme = .light
    
    @State var blendAmount: CGFloat = 0.8
    @State var detent: PresentationDetent = .height(230)
//    @State var detent: PresentationDetent = .fraction(0.6)
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(spacing: 20) {
                    
                    // Tinted Base Color
                    VStack(alignment: .leading, spacing: 15){
                        VStack(alignment: .leading, spacing: 5){
                            HStack(alignment: .bottom){
                                Text("Background Base")
                                Spacer()
                                Text("`Garnish.bgBase`")
                                    .opacity(0.7)
                                    .font(.caption)
                            }
                                .font(.headline)
                            Text("Used when displaying text agaisnt a plain background, like the one this text is against")
                                .font(.caption)
                                .opacity(0.7)
                            
                            ColorRectangle(color: Garnish.bgBase(for: inputColor, in: colorScheme, blendAmount: blendAmount), height: 80)
                                .padding(.top, 4)
                        }
                        VStack(alignment: .leading, spacing: 5){
                            HStack(alignment: .bottom){
                                Text("Color Base")
                                Spacer()
                                Text("`Garnish.colorBase`")
                                    .opacity(0.7)
                                    .font(.caption)
                            }
                            .font(.headline)
                            
                            Text("Used when displaying text agaisnt a color, as seen below, a helper function for `Garnish.contrastingForeground`")
                                .font(.caption)
                                .opacity(0.7)
                            
                            let colorBase = Garnish.colorBase(for: inputColor, in: Garnish.determineColorScheme(inputColor), blendAmount: blendAmount)
                            
                            ColorRectangle(
                                color: colorBase,
                                outLineColor: colorBase.adjustedBrightness(for: Garnish.determineColorScheme(inputColor), by: 0.1),
                                height: 80
                            )
                            
                                .padding(.top, 4)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Contrasting Foreground Color
                    VStack(alignment: .leading, spacing: 3){
                        Text("Contrasting Foreground Color")
                            .font(.headline)
                        Text("Example of `Garnish.contrastingForeground` for the chosen color")
                            .font(.caption)
                            .opacity(0.7)
                        let contrastingForeground = Garnish.contrastingForeground(for: inputColor, blendAmount: blendAmount)
                        ZStack {
                            ColorRectangle(color: inputColor)
                            Text("Foreground Color")
                                .foregroundColor(contrastingForeground)
                                .bold()
                        }
                        .padding(.top, 5)
                    }
                    .padding(.horizontal, 20)
                    
                    VStack(alignment: .leading, spacing: 10){
                        VStack(alignment: .leading, spacing: 5){
                            Text("Utility Tests")
                            .font(.headline)
                            
                            Text("Some tests of other utility functions")
                                .font(.caption)
                                .opacity(0.7)
                        }
                        
                        
                        // Utility Tests
                        VStack(alignment: .leading, spacing: 10) {
                            
                            let luminance = Garnish.relativeLuminance(of: inputColor)
                            let brightness = Garnish.brightness(of: inputColor)
                            
                            Text("Relative Luminance: \(luminance, specifier: "%.2f")")
                            Text("Brightness: \(brightness, specifier: "%.2f")")
                            Text("Is Light Color: \(Garnish.isLightColor(inputColor) ? "Yes" : "No")")
                            Text("Colorscheme: \(Garnish.determineColorScheme(inputColor))")
                            Text("Is Dark Color: \(Garnish.isDarkColor(inputColor) ? "Yes" : "No")")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                }
            }
            .safeAreaInset(edge: .bottom, content: {
                Color.clear.frame(height: detent == .fraction(0.05) ? 50 : 230)
            })
            .navigationTitle("Garnish")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: .constant(true)) {
                GarnishSheet(inputColor: $inputColor, colorScheme: $colorScheme, blendAmount: $blendAmount, detent: $detent)
            }
        }
        
        .colorScheme(colorScheme)
        .preferredColorScheme(colorScheme)
    }
}

@available(iOS 16.4, *)
struct GarnishSheet: View {
    @Binding var inputColor: Color
    @Binding var colorScheme: ColorScheme
    @Binding var blendAmount: CGFloat
    
    @Binding var detent: PresentationDetent
    var body: some View {
        
        VStack(spacing: 20){
            VStack(spacing: 15){
                ColorPicker("Color", selection: $inputColor)
                
                let exampleColor: [Color] = [Color(red: 189/255, green: 117/255, blue: 199/255),
                                             Color(red: 0.8, green: 0.3, blue: 0.2),
                                             Color(red: 0.8, green: 0.3, blue: 0.4),
                                             Color(red: 150/255, green: 240/255, blue: 180/255),
                                             Color(red: 200/255, green: 210/255, blue: 240/255),
                                             Color.white,
                                             Color.black,
                                             Color.teal,
                ]
                
                if detent == .fraction(0.6){
                    LazyVGrid(columns: [
                        GridItem(),
                        GridItem(),
                        GridItem(),
                        GridItem()
                    ]) {
                        ForEach(exampleColor, id: \.self){ color in
                            Button {
                                inputColor = color
                            } label: {
                                color
                                    .frame(height: 35)
                                    .clipShape(Capsule())
                                    .overlay(
                                        Capsule()
                                            .strokeBorder(color.adjustedBrightness(for: colorScheme, by: 0.1), lineWidth: 3)
                                    )
                            }
                            
                        }
                    }
                }else{
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(exampleColor, id: \.self){ color in
                                Button {
                                    inputColor = color
                                } label: {
                                    color
                                        .frame(width: 80, height: 35)
                                        .clipShape(Capsule())
                                        .overlay(
                                            Capsule()
                                                .strokeBorder(color.adjustedBrightness(for: colorScheme, by: 0.1), lineWidth: 3)
                                        )
                                }
                                
                            }
                        }
                        .padding(.horizontal, 25)
                    }
                    .padding(.horizontal, -25)
                }
            }
            
            Divider()
            HStack{
                Text("Environment")
                Picker("Color Scheme", selection: $colorScheme) {
                    Text("Light").tag(ColorScheme.light)
                    Text("Dark").tag(ColorScheme.dark)
                }
                .pickerStyle(.menu)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            HStack(spacing: 30){
                Button {
                    withAnimation {
                        blendAmount = 0.9
                    }
                } label: {
                    Text("Blend")
                        .foregroundStyle(blendAmount == 0.9 ? Color.primary : (Garnish.bgBase(for: inputColor, in: colorScheme)))
                }

                Slider(value: $blendAmount, in: 0...1, step: 0.01) {
                }
            }
            
            
            
            Spacer()
        }
        .tint(Garnish.bgBase(for: inputColor, in: colorScheme))
        .scaleEffect(detent != .fraction(0.05) ? 1 : 0.9)
        .blur(radius: (detent != .fraction(0.05) ? 0 : 2))
        .opacity(detent != .fraction(0.05) ? 1 : 0)
        .animation(.smooth, value: detent)
        .padding(.top, 25)
        .padding(.horizontal, 25)
        .overlay(content: {
            Text("Open for Options")
                .opacity(detent == .fraction(0.05) ? 1 : 0)
                .font(.caption)
                .padding(.top, 10)
                .opacity(0.5)
                .animation(.smooth, value: detent)
        })
        .presentationDetents([.fraction(0.05), .height(230), .fraction(0.6)], selection: $detent)
        .presentationCornerRadius(30)
        .presentationBackgroundInteraction(.enabled)
        .interactiveDismissDisabled()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
        }
        .colorScheme(colorScheme)
        .preferredColorScheme(colorScheme)
    }
}


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
                        ColorRectangle(color: Garnish.bgBase(for: inputColor, in: colorScheme))
                    }
                    VStack {
                        Text("Color Base")
                            .font(.headline)
                        ColorRectangle(color: Garnish.colorBase(for: inputColor, in: Garnish.determineColorScheme(inputColor)))
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
            .frame(minHeight: height)
    }
}

#Preview{
    if #available(iOS 16.4, *) {
        GarnishTestView()
    } else {
        GarnishTestViewLeg()
    }
}
