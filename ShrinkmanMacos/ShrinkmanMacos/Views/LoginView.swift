//
//  LoginView.swift
//  ShrinkmanMacos
//
//  Created by Vishal Kamble on 19/06/23.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var productKeySegment1 = ""
    @State private var productKeySegment2 = ""
    @State private var productKeySegment3 = ""
    @State private var productKeySegment4 = ""
    @State private var productKeySegment5 = ""
    
    var body: some View {
        VStack {
            HStack {
                Text("User Name")
                    .font(.headline)
                TextField("", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 20)
            
            HStack {
                Text("Product Key")
                    .font(.headline)
                
                ProductKeySegmentField(segment: $productKeySegment1)
                ProductKeySegmentField(segment: $productKeySegment2)
                ProductKeySegmentField(segment: $productKeySegment3)
                ProductKeySegmentField(segment: $productKeySegment4)
                ProductKeySegmentField(segment: $productKeySegment5)
            }
            .padding(.horizontal, 50)
            .padding(.bottom, 20)
            
            // Other login components
            
            Button("Log In") {
                // Perform login action
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct ProductKeySegmentField: View {
    @Binding var segment: String
    
    var body: some View {
        TextField("", text: $segment)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

