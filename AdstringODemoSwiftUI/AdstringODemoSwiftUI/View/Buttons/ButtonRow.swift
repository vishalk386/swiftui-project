//
//  ButtonRow.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 17/05/23.
//

import SwiftUI

struct ButtonRow: View {
    let title: String
    let systemImage: String
    let backgroundColor: Color
    let action: (() -> Void)?
    
    var body: some View {
        Button(action: {
            action?()
        }) {
            VStack {
                if #available(iOS 15.0, *) {
                       // Use the `tint` modifier for iOS 15 and newer
                       Image(systemName: systemImage)
                           .resizable()
                           .tint(.white)
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 50, height: 50)
                   } else {
                       // Use a regular `foregroundColor` modifier for iOS 14 and earlier
                       Image(systemName: systemImage)
                           .resizable()
                           .foregroundColor(.white)
                           .aspectRatio(contentMode: .fit)
                           .frame(width: 50, height: 50)
                   }
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 5)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(15.0)
            .shadow(radius: 10.0, x: 20, y: 10)
        }
        .padding(.horizontal, 20)
    }
}
