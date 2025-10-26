////
////  Examples.swift
////  Garnish
////
////  Created by Aether on 19/12/2024.
////
// import SwiftUI
//
//
// @available(iOS 16.4, *)
// @available(macOS, unavailable)
// #Preview("Garnish Modifiers"){
//    GarnishModifierExampels()
// }
//
// @available(iOS 16.4, *)
// @available(macOS, unavailable)
// #Preview("Garnish Usgae Examples"){
//    GarnishTestView()
// }
//
// @available(iOS 16.4, *)
// @available(macOS, unavailable)
// #Preview("Font Weight") {
//    FontDemo()
// }
//
//
//
// @available(iOS 16.4, *)
// @available(macOS, unavailable)
// struct GarnishModifierExampels: View {
//    @State var foregroundColor = Color(red: 209/255, green: 122/255, blue: 102/255)
//    @State var backgroundColor = Color(red: 255/255, green: 150/255, blue: 158/255)
//
//    @State var color = Color(red: 255/255, green: 155/255, blue: 48/255)
//
//    @State var colorScheme: ColorScheme = .light
//    @State var blendAmount: CGFloat = 0.8
//    //    @State var detent: PresentationDetent = .height(230)
//    @State var detent: PresentationDetent = .fraction(0.05)
//    var body: some View {
//        NavigationSplitView {
//            ScrollView(){
//                VStack(spacing: 15){
//                    ColorPicker("`foregroundColor`", selection: $foregroundColor)
//                    ColorPicker("`backgroundColor`", selection: $backgroundColor)
//                    Divider()
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 16)
//                    ColorPicker("`color`", selection: $color)
//                }
//                .padding(.horizontal, 20)
//
//            }
//        } detail: {
//            ScrollView{
//                VStack(spacing: 15){
//                    VStack{
//                        TitleSection(title: "With foregroundColor, backgroundColor", description: "Ensures foreground color is visible agaisnt background color, on parameter allows you to specify which areas of the view should be affected")
//
//                        CodeBlockLeg(code: Text("`.garnish(foregroundColor, backgroundColor, on: .all)`"))
//
//                        Text("Default")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .garnish(foregroundColor, backgroundColor, on: .all)
//                            .clipShape(.rect(cornerRadius: 20))
//
//                        Divider()
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 16)
//
//                        CodeBlockLeg(code: Text("`.garnish(foregroundColor, backgroundColor, on: .foreground)`"))
//
//                        Text("Foreground")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .garnish(foregroundColor, backgroundColor, on: .foreground)
//                            .clipShape(.rect(cornerRadius: 20))
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                            }
//
//
//                        Divider()
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 16)
//
//                        CodeBlockLeg(code: Text("`.garnish(foregroundColor, backgroundColor, on: .background)`"))
//
//                        Text("Background")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .garnish(foregroundColor, backgroundColor, on: .background)
//                            .clipShape(.rect(cornerRadius: 20))
//                    }
//                    .padding(.horizontal, 20)
//
//
//
//                    Divider()
//                        .padding(.vertical, 8)
//                        .padding(.horizontal, 16)
//
//
//                    VStack{
//                        TitleSection(title: "With single Color", description: "Ensures foreground color is visible agaisnt itself, on parameter allows you to specify which areas of the view should be affected")
//
//                        CodeBlockLeg(code: Text("`.garnish(color, on: .all)`"))
//
//                        Text("Default")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .garnish(color, on: .all)
//                            .clipShape(.rect(cornerRadius: 20))
//
//                        Divider()
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 16)
//
//                        CodeBlockLeg(code: Text("`.garnish(color, on: .foreground)`"))
//
//                        Text("Foreground")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .garnish(color, on: .foreground)
//                            .clipShape(.rect(cornerRadius: 20))
//                            .overlay {
//                                RoundedRectangle(cornerRadius: 20)
//                                    .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                            }
//
//
//                        Divider()
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 16)
//
//                        CodeBlockLeg(code: Text("`.garnish(color, on: .background)`"))
//
//                        Text("Background")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .garnish(color, on: .background)
//                            .clipShape(.rect(cornerRadius: 20))
//                    }
//                    .padding(.horizontal, 20)
//                }
//                .frame(maxWidth: 600)
//            }
//        }
//
//    }
// }
//
//
// @available(iOS 16.4, *)
// @available(macOS, unavailable)
// struct FontDemo: View {
//    @State private var inputColor: Color = Color(red: 238/255, green: 201/255, blue: 93/255)
//    @State private var backgroundColor: Color = Color(red: 65/255, green: 202/255, blue: 110/255)
//    @State private var colorScheme: ColorScheme = .light
//
//    @State var blendAmount: CGFloat = 0.8
//    @State var detent: PresentationDetent = .height(230)
//    //    @State var detent: PresentationDetent = .fraction(0.05)
//
//    @Environment(\.horizontalSizeClass) var horizontalSizeClass
//    var body: some View {
//        Group{
//            if horizontalSizeClass == .compact{
//                main
//                    .sheet(isPresented: .constant(true)) {
//                        GarnishSheet(inputColor: $inputColor, backgroundColor: $backgroundColor, colorScheme: $colorScheme, blendAmount: $blendAmount, detent: $detent)
//                    }
//            }
//            else{
//                HStack{
//                    GarnishSheet(inputColor: $inputColor, backgroundColor: $backgroundColor, colorScheme: $colorScheme, blendAmount: $blendAmount, detent: $detent)
//                        .padding(.top, 10)
//                        .background{
//                            Color(.secondarySystemBackground)
//                                .ignoresSafeArea()
//                        }
//                        .clipShape(.rect(cornerRadius: 20))
//                        .padding(20)
//                        .frame(idealWidth: 250, maxWidth: 300)
//
//                    main
//                        .frame(maxWidth: 550)
//                        .frame(maxWidth: .infinity, alignment: .center)
//                        .padding(.top, 50)
//                }
//                .ignoresSafeArea()
//            }
//        }
//    }
//
//    var main: some View{
//        ScrollView{
//            VStack(alignment: .leading, spacing: 15){
//
//                TitleSection(title: "Recomended Font Weight", code: Text("`color.recommendedFontWeight()`"), description: "Calculate the recommended font weight for a given color based on contrast")
//
//                VStack(alignment: .center){
//                    Text("Default SwiftUI Background")
//                        .font(.caption)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                    HStack{
//                        VStack{
//                            Text("Regular BG")
//                                .fontWeight(Color.primary.recommendedFontWeight(in: colorScheme))
//                                .frame(maxWidth: .infinity)
//
//                            Spacer()
//                            Text("Adjusted")
//                                .font(.caption2)
//                                .kerning(1.1)
//                                .opacity(0.5)
//                                .textCase(.uppercase)
//                        }
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                        }
//
//                        VStack{
//                            Text("Regular BG")
//                                .fontWeight(Color.primary.recommendedFontWeight(in: colorScheme))
//                                .frame(maxWidth: .infinity)
//
//                            Spacer()
//                            Text("Default")
//                                .font(.caption2)
//                                .kerning(1.1)
//                                .opacity(0.5)
//                                .textCase(.uppercase)
//                        }
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                        }
//                    }
//
//                    let AdjustedColor = Garnish.adjustForBackground(for: inputColor, with: backgroundColor)
//
//
//                    Text("Custom Foreground Contrast Adjusted for Background, and Custom Background")
//                        .font(.caption)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.top, 7)
//                    HStack{
//                        VStack{
//                            Text("Adjusted Foreground + BG")
//                                .frame(maxWidth: .infinity)
//                                .multilineTextAlignment(.center)
//
//                            Spacer()
//                            Text("Adjusted")
//                                .font(.caption2)
//                                .kerning(1.1)
//                                .opacity(0.5)
//                                .textCase(.uppercase)
//                        }
//                        .foregroundStyle(AdjustedColor)
//                        .fontWeight(AdjustedColor.recommendedFontWeight(in: colorScheme, with: backgroundColor))
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                        .background(backgroundColor, in: .rect(cornerRadius: 25))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                        }
//
//                        VStack{
//                            Text("Adjusted Foreground + BG")
//                                .fontWeight(Color.primary.recommendedFontWeight(in: colorScheme))
//                                .frame(maxWidth: .infinity)
//                                .multilineTextAlignment(.center)
//
//                            Spacer()
//                            Text("Default")
//                                .font(.caption2)
//                                .kerning(1.1)
//                                .opacity(0.5)
//                                .textCase(.uppercase)
//                        }
//                        .foregroundStyle(AdjustedColor)
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                        .background(backgroundColor, in: .rect(cornerRadius: 25))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                        }
//                    }
//
//                    let foregroundContrast = inputColor.constratingForegroud()
//
//
//                    Text("Same Color for Foreground and Background, with contrast for foreground")
//                        .font(.caption)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding(.top, 7)
//
//                    HStack{
//                        VStack{
//                            Text("Contrast Foreground")
//                                .frame(maxWidth: .infinity)
//                                .multilineTextAlignment(.center)
//
//                            Spacer()
//                            Text("Adjusted")
//                                .font(.caption2)
//                                .kerning(1.1)
//                                .opacity(0.5)
//                                .textCase(.uppercase)
//                        }
//                        .foregroundStyle(foregroundContrast)
//                        .fontWeight((foregroundContrast.recommendedFontWeight(in: colorScheme, with: inputColor, debugStatements: true)))
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                        .background(inputColor, in: .rect(cornerRadius: 25))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                        }
//
//                        VStack{
//                            Text("Adjusted Foreground + BG")
//                                .fontWeight(Color.primary.recommendedFontWeight(in: colorScheme))
//                                .frame(maxWidth: .infinity)
//                                .multilineTextAlignment(.center)
//
//                            Spacer()
//                            Text("Default")
//                                .font(.caption2)
//                                .kerning(1.1)
//                                .opacity(0.5)
//                                .textCase(.uppercase)
//                        }
//                        .foregroundStyle(foregroundContrast)
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                        .background(inputColor, in: .rect(cornerRadius: 25))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                        }
//                    }
//
//                    Group{
//                        Text("Worst Case. ")
//                            .foregroundColor(Color.red)
//                        +
//                        Text("Custom Foreground and Custom Background (No contrast adjustmnents)")
//                    }
//                    .font(.caption)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.top, 7)
//                    HStack{
//                        VStack{
//                            Text("Custom Foreground + BG")
//                                .frame(maxWidth: .infinity)
//                                .multilineTextAlignment(.center)
//
//                            Spacer()
//                            Text("Adjusted")
//                                .font(.caption2)
//                                .kerning(1.1)
//                                .opacity(0.5)
//                                .textCase(.uppercase)
//                        }
//                        .foregroundStyle(inputColor)
//                        .fontWeight(inputColor.recommendedFontWeight(in: colorScheme, with: backgroundColor))
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                        .background(backgroundColor, in: .rect(cornerRadius: 25))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                        }
//
//                        VStack{
//                            Text("Custom Foreground + BG")
//                                .fontWeight(Color.primary.recommendedFontWeight(in: colorScheme))
//                                .frame(maxWidth: .infinity)
//                                .multilineTextAlignment(.center)
//
//                            Spacer()
//                            Text("Default")
//                                .font(.caption2)
//                                .kerning(1.1)
//                                .opacity(0.5)
//                                .textCase(.uppercase)
//                        }
//                        .foregroundStyle(inputColor)
//                        .padding(.horizontal, 10)
//                        .padding(.vertical, 15)
//                        .background(backgroundColor, in: .rect(cornerRadius: 25))
//                        .overlay {
//                            RoundedRectangle(cornerRadius: 25)
//                                .stroke(Color.primary.opacity(0.15), style: StrokeStyle(lineWidth: 1.5))
//                        }
//                    }
//                }
//                .frame(maxWidth: .infinity)
//            }
//            .padding(.horizontal, 20)
//        }
//    }
// }
//
// @available(iOS 16.4, *)
// @available(macOS, unavailable)
// struct GarnishTestView: View {
//    @State private var inputColor: Color = Color(red: 0.8, green: 0.3, blue: 0.4)
//    @State private var backgroundColor: Color = Color(red: 245/255, green: 201/255, blue: 68/255)
//    @State private var colorScheme: ColorScheme = .light
//
//    @State var blendAmount: CGFloat = 0.8
//    @State var detent: PresentationDetent = .height(230)
//    //    @State var detent: PresentationDetent = .fraction(0.05)
//
//    var body: some View {
//        NavigationSplitView{
//            GarnishSheet(inputColor: $inputColor, backgroundColor: $backgroundColor, colorScheme: $colorScheme, blendAmount: $blendAmount, detent: $detent)
//        } detail:{
//            ScrollView{
//                VStack(spacing: 20) {
//
//                    // Tinted Base Color
//                    VStack(alignment: .leading, spacing: 15){
//                        VStack(alignment: .leading, spacing: 15){
//                            Color(.systemBackground)
//                            TitleSection(title: "Adjust for System Background", description: "Use .garnish(foregroundColor, backgroundColor) to adjust the color of a view based on its background color. Here your inputColor is adjusted to match the system background color.")
//
//                            HStack{
//                                Text("Adjusted")
//                                    .garnish(inputColor, Color(.systemBackground))
//                                    .frame(maxWidth: .infinity)
//
//                                Divider()
//
//                                Text("Not Adjusted")
//                                    .foregroundStyle(inputColor)
//                                    .frame(maxWidth: .infinity)
//                            }
//
//                            HStack(spacing: 0){
//
//                                UnevenRoundedRectangle(topLeadingRadius: 25, bottomLeadingRadius: 25, bottomTrailingRadius: 0, topTrailingRadius: 0, style: .continuous)
//                                    .garnish(inputColor, Color(.systemBackground))
//
//
//                                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 0, bottomTrailingRadius: 25, topTrailingRadius: 25, style: .continuous)
//                                    .foregroundStyle(inputColor)
//
//                            }
//                            .frame(height: 80)
//
//                            HStack(spacing: 30){
//
//                                CodeBlockLeg(code: Text("`.garnish(inputColor, Color(.systemBackground))`"))
//
//
//                                Divider()
//                                    .padding(.vertical, 5)
//
//                                CodeBlockLeg(code: Text("`.foregroundStyle(inputColor)`"))
//                            }
//                            .padding(.horizontal, 10)
//                        }
//
//                        Divider()
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 16)
//
//                        VStack(alignment: .leading, spacing: 15){
//
//                            VStack{
//                                TitleSection(title: "Adjust for Given Background", description: "Used when displaying colored text agaisnt a given background, like the one this text is against")
//
//
//                            }
//                            HStack(alignment: .top, spacing: 20){
//                                VStack{
//                                    Text("Adjusted")
//                                        .frame(maxWidth: .infinity)
//                                        .padding(.horizontal, 20)
//                                        .padding(.vertical, 25)
//                                        .garnish(inputColor, backgroundColor)
//                                        .clipShape(.rect(cornerRadius: 25))
//                                }
//
//
//                                Divider()
//                                    .padding(.vertical)
//
//                                VStack{
//                                    Text("Not Adjusted")
//                                        .frame(maxWidth: .infinity)
//                                        .padding(.horizontal, 20)
//                                        .padding(.vertical, 25)
//                                        .foregroundStyle(inputColor)
//                                        .background(backgroundColor)
//                                        .clipShape(.rect(cornerRadius: 25))
//
//                                }
//                            }
//
//                            HStack(alignment: .top, spacing: 30){
//
//                                CodeBlockLeg(code: Text("`.garnish(inputColor, backgroundColor)`"))
//
//
//                                Divider()
//
//                                VStack{
//                                    CodeBlockLeg(code: Text("`.foregroundStyle(inputColor)`"))
//                                    CodeBlockLeg(code: Text("`.background(backgroundColor)`"))
//                                }
//                            }
//                            .padding(.horizontal, 10)
//                        }
//
//
//                        Divider()
//                            .padding(.vertical, 8)
//                            .padding(.horizontal, 16)
//
//
//                    }
//                    .padding(.horizontal, 20)
//
//                    // Contrasting Foreground Color
//                    VStack(alignment: .leading, spacing: 15){
//
//                        TitleSection(title: "Create a Contrasting Foreground Color", code: Text("`Garnish.contrastingForeground`"), description: "Make sure a color can display agaisn't itself.")
//
//                        let contrastingForeground = Garnish.contrastingForeground(for: inputColor, blendAmount: blendAmount)
//                        HStack{
//                            Group{
//                                Text("Adjusted Style")
//                                    .frame(maxWidth: .infinity)
//
//                                Rectangle()
//                                    .frame(width: 1)
//                                    .opacity(0.5)
//                            }
//
//                            .garnish(inputColor)
//                            Text("Not Adjusted")
//                                .frame(maxWidth: .infinity)
//
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 25)
//                        .background(
//                            RoundedRectangle(cornerRadius: 25)
//                                .fill(inputColor)
//                        )
//                    }
//                    .padding(.horizontal, 20)
//
//
//                    VStack(alignment: .leading, spacing: 10){
//                        VStack(alignment: .leading, spacing: 5){
//                            Text("Utility Tests")
//                                .font(.headline)
//
//                            Text("Some tests of other utility functions")
//                                .font(.caption)
//                                .opacity(0.7)
//                        }
//
//
//                        // Utility Tests
//                        VStack(alignment: .leading, spacing: 10) {
//
//                            let luminance = Garnish.relativeLuminance(of: inputColor)
//                            let brightness = Garnish.brightness(of: inputColor)
//
//                            Text("Relative Luminance: \(luminance, specifier: "%.2f")")
//                            Text("Brightness: \(brightness, specifier: "%.2f")")
//                            Text("Is Light Color: \(Garnish.isLightColor(inputColor) ? "Yes" : "No")")
//                            Text("Colorscheme: \(Garnish.determineColorScheme(inputColor))")
//                            Text("Is Dark Color: \(Garnish.isDarkColor(inputColor) ? "Yes" : "No")")
//                        }
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(.horizontal, 20)
//                }
//            }
//            //            .safeAreaInset(edge: .bottom, content: {
//            //                Color.clear.frame(height: detent == .fraction(0.05) ? 50 : 230)
//            //            })
//            //            .safeAreaInset(edge: .top, content: {
//            //                Color.clear.frame(height: 10)
//            //            })
//            //            .navigationTitle("Garnish")
//            .navigationBarTitleDisplayMode(.inline)
//            //            .sheet(isPresented: .constant(true)) {
//            //                GarnishSheet(inputColor: $inputColor, backgroundColor: $backgroundColor, colorScheme: $colorScheme, blendAmount: $blendAmount, detent: $detent)
//            //            }
//        }
//
//        .colorScheme(colorScheme)
//        .preferredColorScheme(colorScheme)
//    }
//
//
// }
//
// @available(iOS 16.4, *)
// @available(macOS, unavailable)
// struct TitleSection: View {
//    var title: String
//    var code: Text? = nil
//    var description: String
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 10){
//            Text(title)
//                .frame(maxWidth: .infinity, alignment: .leading)
//                .font(.headline)
//
//
//            Text(description)
//                .font(.caption)
//                .opacity(0.7)
//
//            if let code{
//                code
//                    .opacity(0.7)
//                    .font(.caption)
//                    .padding(8)
//                    .background(Color(.secondarySystemBackground))
//                    .clipShape(.rect(cornerRadius: 10))
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 10)
//                            .stroke(Color.primary.opacity(0.1), style: StrokeStyle(lineWidth: 1))
//                    }
//            }
//
//        }
//    }
// }
//
// @available(iOS 15.0, *)
// @available(macOS, unavailable)
// struct CodeBlockLeg: View {
//    var code: Text
//
//    var body: some View{
//        code
//            .opacity(0.7)
//            .font(.caption)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .padding(8)
//            .background(Color(.secondarySystemBackground))
//            .clipShape(.rect(cornerRadius: 10))
//            .overlay {
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.primary.opacity(0.1), style: StrokeStyle(lineWidth: 1))
//            }
//    }
// }
//
//
// @available(iOS 16.4, *)
// @available(macOS, unavailable)
// struct GarnishSheet: View {
//    @Binding var inputColor: Color
//    @Binding var backgroundColor: Color
//    @Binding var colorScheme: ColorScheme
//    @Binding var blendAmount: CGFloat
//
//    @Binding var detent: PresentationDetent
//    var body: some View {
//
//        VStack(spacing: 20){
//            VStack(spacing: 15){
//                ColorPicker("Color", selection: $inputColor)
//
//
//                ColorPicker("Background", selection: $backgroundColor)
//
//                let exampleColor: [Color] = [Color(red: 189/255, green: 117/255, blue: 199/255),
//                                             Color(red: 0.8, green: 0.3, blue: 0.2),
//                                             Color(red: 0.8, green: 0.3, blue: 0.4),
//                                             Color(red: 150/255, green: 240/255, blue: 180/255),
//                                             Color(red: 200/255, green: 210/255, blue: 240/255),
//                                             Color.white,
//                                             Color.black,
//                                             Color.teal,
//                ]
//
//                //                if detent == .fraction(0.6){
//                //                    LazyVGrid(columns: [
//                //                        GridItem(),
//                //                        GridItem(),
//                //                        GridItem(),
//                //                        GridItem()
//                //                    ]) {
//                //                        ForEach(exampleColor, id: \.self){ color in
//                //                            Button {
//                //                                inputColor = color
//                //                            } label: {
//                //                                color
//                //                                    .frame(height: 35)
//                //                                    .clipShape(Capsule())
//                //                                    .overlay(
//                //                                        Capsule()
//                //                                            .strokeBorder(color.adjustedBrightness(for: colorScheme, by: 0.1), lineWidth: 3)
//                //                                    )
//                //                            }
//                //
//                //                        }
//                //                    }
//                //                }else{
//                //                    ScrollView(.horizontal){
//                //                        HStack{
//                //                            ForEach(exampleColor, id: \.self){ color in
//                //                                Button {
//                //                                    inputColor = color
//                //                                } label: {
//                //                                    color
//                //                                        .frame(width: 80, height: 35)
//                //                                        .clipShape(Capsule())
//                //                                        .overlay(
//                //                                            Capsule()
//                //                                                .strokeBorder(color.adjustedBrightness(for: colorScheme, by: 0.1), lineWidth: 3)
//                //                                        )
//                //                                }
//                //
//                //                            }
//                //                        }
//                //                        .padding(.horizontal, 25)
//                //                    }
//                //                    .padding(.horizontal, -25)
//                //                }
//            }
//
//            Divider()
//            HStack{
//                Text("Environment")
//                Picker("Color Scheme", selection: $colorScheme) {
//                    Text("Light").tag(ColorScheme.light)
//                    Text("Dark").tag(ColorScheme.dark)
//                }
//                .pickerStyle(.menu)
//                .frame(maxWidth: .infinity, alignment: .trailing)
//            }
//            HStack(spacing: 30){
//                Button {
//                    withAnimation {
//                        blendAmount = 0.9
//                    }
//                } label: {
//                    Text("Blend")
//                        .foregroundStyle(blendAmount == 0.9 ? Color.primary : (Garnish.adjustForBackground(for: inputColor, in: colorScheme)))
//                }
//
//                Slider(value: $blendAmount, in: 0...1, step: 0.01) {
//                }
//            }
//
//
//
//            Spacer()
//        }
//        .tint(Garnish.adjustForBackground(for: inputColor, in: colorScheme))
//        .scaleEffect(detent != .fraction(0.05) ? 1 : 0.9)
//        .blur(radius: (detent != .fraction(0.05) ? 0 : 2))
//        .opacity(detent != .fraction(0.05) ? 1 : 0)
//        .animation(.smooth, value: detent)
//        .padding(.top, 25)
//        .padding(.horizontal, 25)
//        .overlay(content: {
//            Text("Open for Options")
//                .opacity(detent == .fraction(0.05) ? 1 : 0)
//                .font(.caption)
//                .padding(.top, 10)
//                .opacity(0.5)
//                .animation(.smooth, value: detent)
//        })
//        .presentationDetents([.fraction(0.05), .height(230), .fraction(0.6)], selection: $detent)
//        .presentationCornerRadius(30)
//        .presentationBackgroundInteraction(.enabled)
//        .interactiveDismissDisabled()
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background{
//            Color(.secondarySystemBackground)
//                .ignoresSafeArea()
//        }
//        .colorScheme(colorScheme)
//        .preferredColorScheme(colorScheme)
//    }
// }
