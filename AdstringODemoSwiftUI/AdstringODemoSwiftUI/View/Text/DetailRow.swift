//
//  DetailRow.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 18/05/23.
//

import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String
    @State private var isHidden = false
    
    var body: some View {
        if !isHidden {
            HStack {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
        }
    }
}

struct DetailRow_Previews: PreviewProvider {
    static var previews: some View {
        DetailRow(title: "Test", value: "Test")
    }
}



