//
//  CustomCellView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 23/05/23.
//

import SwiftUI

struct CustomCellView: View {
    var image: UIImage
    var title: String
    var compressedSize: String
    
    var body: some View {
        HStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                
                Text("Compressed Size: \(compressedSize)")
                    .font(.subheadline)
            }
            
            Spacer()
        }
        .padding(10)
    }
}


struct CustomCellView_Previews: PreviewProvider {
    static var previews: some View {
        CustomCellView(image: UIImage(named: "asd") ?? UIImage(), title: "Test", compressedSize: "Test")
    }
}
