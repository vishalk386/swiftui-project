//
//  HelpView.swift
//  SwiftUIApp
//
//  Created by Vishal Kamble on 13/07/23.
//

import SwiftUI

struct HelpView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Key Details")
                    .font(
                        Font.custom("Lato", size: 32)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
                    .padding(50)
                Spacer() // Add Spacer to push the image to the right
            }
            
            VStack(alignment: .trailing){
                Image("keypage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 248.36395, height: 145.97322)
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 840)
                    .frame(height: 170)
                    .foregroundColor(.white)
                    .shadow(color: Color.gray.opacity(0.6), radius: 3, x: 0, y: 2)
            }
            Spacer() // Add Spacer to fill the remaining space at the bottom
        }
    }
}




struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView()
    }
}
