//
//  KeyView.swift
//  SwiftUIApp
//
//  Created by Vishal Kamble on 13/07/23.
//

import SwiftUI

struct KeyView: View {
    
    @State private var text1 = ""
    @State private var text2 = ""
    @State private var text3 = ""
    @State private var text4 = ""
    var body: some View {
        
        
        Text("Key Details")
            .font(
                Font.custom("Lato", size: 32)
                    .weight(.semibold)
            )
            .multilineTextAlignment(.center)
            .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
            .frame(width: 163, height: 40, alignment: .center)
        
        VStack(alignment: .leading){
            Image("keypage")
                .frame(width: 248.36395, height: 145.97322)
            
        }
        VStack(alignment:.center){
            Spacer()
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 840)
                .frame(height: 170)
                .foregroundColor(.white)
                .shadow(color: Color.gray.opacity(0.6), radius: 3, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                HStack() {
                    Text("Enter key")
                        .font(Font.custom("Lato", size: 16).weight(.semibold))
                        .foregroundColor(Color(red: 0.83, green: 0, blue: 0.1))
                    Image(systemName: "info.circle")
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(red: 0.83, green: 0, blue: 0.1))
                }
                
                .padding(10)
                Spacer()
                HStack(spacing: 20) {
                    TextField("", text: $text1)
                        .foregroundColor(.black)
                        .frame(width: 96, height: 28)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 0.02, green: 0.27, blue: 0.58), lineWidth: 1)
                                .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.2))
                        )
                    
                    TextField("", text: $text2)
                        .foregroundColor(.black)
                        .frame(width: 96, height: 28)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 0.02, green: 0.27, blue: 0.58), lineWidth: 1)
                                .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.2))
                        )
                    
                    TextField("", text: $text3)
                        .foregroundColor(.black)
                        .frame(width: 96, height: 28)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 0.02, green: 0.27, blue: 0.58), lineWidth: 1)
                                .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.2))
                        )
                    
                    TextField("", text: $text4)
                        .foregroundColor(.black)
                        .frame(width: 96, height: 28)
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color(red: 0.02, green: 0.27, blue: 0.58), lineWidth: 1)
                                .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.2))
                        )
                }
                Spacer()
                
                HStack(alignment: .bottom){
                    Button(action: {
                        // Perform action for the button
                    }) {
                        Text("Activate")
                            .font(
                                Font.custom("Lato", size: 14)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 136, height: 24)
                            .background(Color(red: 0.83, green: 0, blue: 0.1))
                            .cornerRadius(5)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                    }
                    .frame(height: 25)
                    Spacer()
                    Button(action: {
                        // Perform action for the button
                    }) {
                        Text("Buy Now")
                            .font(
                                Font.custom("Lato", size: 14)
                                    .weight(.semibold)
                            )
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .frame(width: 136, height: 24)
                            .background(Color(red: 0.83, green: 0, blue: 0.1))
                            .cornerRadius(5)
                            .shadow(color: .black.opacity(0.25), radius: 4, x: 2, y: 2)
                        
                    }
                    .frame(height: 25)
                }
                Spacer()
            }
            .padding()
            Spacer()
        }
        
        
        HStack {
            Spacer()
            Text("Version:1.00.1225.15")
                .font(
                    Font.custom("Lato", size: 16)
                        .weight(.bold)
                )
            
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
                .padding(20)
                .frame(height: 28)
                .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.15))
                .cornerRadius(5)
            Spacer()
            
            Text("Deactivation date:15-Jan-2022")
                .font(
                    Font.custom("Lato", size: 16)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
                .padding(20)
                .frame(height: 28)
                .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.15))
                .cornerRadius(5)
            Spacer()
            Text("System MAC :D5DFWWDW")
                .font(
                    Font.custom("Lato", size: 16)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
                .padding(20)
                .frame(height: 28)
                .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.15))
                .cornerRadius(5)
            Spacer()
        }.padding()
        
    }
        VStack(alignment: .trailing){
            Text("Your Trail version end is 25 days. To use software kindly buy activation key")
                .font(Font.custom("Lato", size: 14))
                .multilineTextAlignment(.center)
                .foregroundColor(Color(red: 0.83, green: 0, blue: 0.1))
                .frame(width: 840, height: 28)
                .background(Color(red: 0.91, green: 0.91, blue: 0.91))
                .cornerRadius(5)
            HStack() {
                Button(action: {
                    // Perform action for the button
                }) {
                    Text("Show License")
                        .font(
                            Font.custom("Lato", size: 14)
                                .weight(.semibold)
                        )
                        .underline()
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
                }
                Button(action: {
                    // Perform action for the button
                }) {
                    Text("View legal notices")
                        .font(
                            Font.custom("Lato", size: 14)
                                .weight(.semibold)
                        )
                        .underline()
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
                }
            }
        }
        
        Spacer()
        
    }
    
}

struct KeyView_Previews: PreviewProvider {
    static var previews: some View {
        KeyView()
    }
}
