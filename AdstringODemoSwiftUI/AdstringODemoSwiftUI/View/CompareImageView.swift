//
//  CompareImageView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 24/05/23.
//

import SwiftUI
import Photos

struct CompareImageView: View {
    let originalImage: Image?
    let originalPHAsset: PHAsset?
    let compressedImage: Image?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if originalPHAsset != nil {
                Text("Original Image")
                    .font(.headline)
                    .foregroundColor(.white)
                
                PHAssetImageView(phAsset: originalPHAsset!)
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else if originalImage != nil {
                Text("Original Image")
                    .font(.headline)
                    .foregroundColor(.white)
                
                originalImage!
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            
            Spacer()
            
            Text("Compressed Image")
                .font(.headline)
                .foregroundColor(.white)
            
            compressedImage!
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            Text("© 2023 AdstringO Software Pvt. Ltd. All rights reserved.")
                .font(.caption)
                .foregroundColor(.white)
                .padding(.bottom, 10)
        }
        .padding()
        .gradientBackground()
        .navigationBarBackButtonHidden(true)
//        .toolbar {
//            ToolbarItem(placement: .navigationBarLeading) {
//                Button(action: {
//                    presentationMode.wrappedValue.dismiss() // Dismiss the current view
//                }) {
//                    Image(systemName: "chevron.left")
//                        .foregroundColor(.white)
//                }
//            }
//        }
        .toolbarBackground(
            Color.clear,
            for: .navigationBar)
    }
}


struct CompareImageView_Previews: PreviewProvider {
    static var previews: some View {
        CompareImageView(originalImage:  Image(systemName: "image"), originalPHAsset: PHAsset(), compressedImage: Image(systemName: "image"))
    }
}
