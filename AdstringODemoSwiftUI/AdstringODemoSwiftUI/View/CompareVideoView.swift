//
//  CompareVideoView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 23/05/23.
//

import SwiftUI
import AVKit

struct CompareVideoView: View {
    let originalVideoURL: URL
    let compressedVideoURL: URL
    
    var body: some View {
        NavigationView {
            
            VStack(spacing: 20) {
                Text("Original Video")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VideoPlayer(player: AVPlayer(url: originalVideoURL))
                    .frame(height: 300)
                Spacer()
                Text("Compressed Video")
                    .font(.headline)
                    .foregroundColor(.white)
                
                VideoPlayer(player: AVPlayer(url: compressedVideoURL))
                    .frame(height: 300)
                Spacer()
                Text("© 2023 AdstringO Software Pvt. Ltd. All rights reserved.")
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
            }
            .padding()
            .gradientBackground()
            
        }
        .navigationBarBackButtonHidden(true)
        .toolbarBackground(
            Color.clear,
            for: .navigationBar)
        
    }
       
}
struct CompareVideoView_Previews: PreviewProvider {
    static var previews: some View {
        CompareVideoView(originalVideoURL: URL(fileURLWithPath: "path_to_original_video"), compressedVideoURL: URL(fileURLWithPath: "path_to_original_video"))
    }
}
