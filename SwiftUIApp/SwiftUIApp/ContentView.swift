//
//  ContentView.swift
//  SwiftUIApp
//
//  Created by Vishal Kamble on 24/04/23.
//

import SwiftUI

//struct ContentView: View {
//   @State var tapCount = 0
//    let students:[String] = ["Vishal", "Atul","Devanand","Kiran","Kabir"]
//    @State var selectedStudent = "Kabir"
//    var body: some View {
//        NavigationView{
//            Form{
//                Section {
//                    Text("Hello")
//                }
//                Text("Vishal Kamble")
//                Text("Vishal Kamble")
//                Text("Vishal Kamble")
//                Text("Vishal Kamble")
//                Button("TapCount::-  \(tapCount)"){
//                    self.tapCount += 1
//                }
//                ForEach(0..<5){
//                    num in
//                    Text("Numbers::- \(num)")
//                }
//                Picker("Selected Student is Favorite: ",selection: $selectedStudent ){
//                    ForEach(students, id: \.self){
//                        Text($0)
//                    }
//                }
//            }
//        }
//        .navigationTitle("Hello SwiftUI")
//        .navigationBarTitleDisplayMode(.inline)
//    }
//}



import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationBarView()
                    .frame(height: 50)
                
                Spacer()
                SideMenuView()
            }
            .background(Color.white) // Set the background color of the navigation view
            .navigationBarHidden(true) // Hide the default navigation bar
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Use stack navigation view style to prevent the detail view from overlapping the navigation bar
    }
}

struct NavigationBarView: View {
    var body: some View {
        HStack {
            Image("shrinkman-logo") // Replace "shrinkman-logo" with the name of your logo image asset
            
            Spacer()
            
            Button(action: {
                // Perform action for trail button
            }) {
                Text("Trial Version")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            Button(action: {
                // Perform action for minimize button
            }) {
                Image(systemName: "minus") // Customize with your minimize button icon
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                // Perform action for cross button
            }) {
                Image(systemName: "xmark") // Customize with your cross button icon
                    .font(.title)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color.white)
        .shadow(color: Color.gray.opacity(0.6), radius: 3, x: 0, y: 2)
    }
}
