//
//  AlertView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 18/05/23.
//

import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    
    func body(content: Content) -> some View {
        content.alert(isPresented: $isPresented) {
            Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

extension View {
    func showAlert(isPresented: Binding<Bool>, title: String, message: String) -> some View {
        self.modifier(AlertModifier(isPresented: isPresented, title: title, message: message))
    }
}
