//
//  HomeView.swift
//  SwiftUIApp
//
//  Created by Vishal Kamble on 13/07/23.
//

import SwiftUI

struct HomeView: View {
    
    @State private var items = [
        FileItem(fileName: "File 1", fileSize: "10 MB", optimizationPercentage: 80),
        FileItem(fileName: "File 2", fileSize: "5 MB", optimizationPercentage: 60),
        FileItem(fileName: "File 3", fileSize: "8 MB", optimizationPercentage: 75),
        FileItem(fileName: "File 4", fileSize: "12 MB", optimizationPercentage: 90),
        FileItem(fileName: "File 5", fileSize: "3 MB", optimizationPercentage: 50)
    ]


    var body: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                Text("Home")
                    .font(
                        Font.custom("Lato", size: 32)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.02, green: 0.27, blue: 0.58))
                    .frame(width: 88, height: 40, alignment: .center)
                Spacer()
                Button(action: {
                    // Perform action for Button 1
                }) {
                    Text("Optimize Setting")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.02, green: 0.27, blue: 0.58))
                        .cornerRadius(10)
                }
                
                Button(action: {
                    // Perform action for the button
                }) {
                    Text("File Settings")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.02, green: 0.27, blue: 0.58))
                        .cornerRadius(10)
                }
            }
            .padding(.top, -60)
            Spacer()
            
            List {
                        HStack {
                            Button(action: {}) {
                                Image(systemName: "square")
                                    .foregroundColor(.white)
                                    .bold()
                            }
                            Spacer()
                            Text("File Name")
                                .font(Font.custom("Lato", size: 16).weight(.semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 1, green: 1, blue: 1))
                            Spacer()
                            Text("File Size")
                                .font(Font.custom("Lato", size: 16).weight(.semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 1, green: 1, blue: 1))
                            Spacer()
                            Text("Optimize %")
                                .font(Font.custom("Lato", size: 16).weight(.semibold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color(red: 1, green: 1, blue: 1))
                        }
                        .listRowBackground(Color(red: 0.02, green: 0.27, blue: 0.58))
                        
                ForEach(items.indices, id: \.self) { index in
                    HStack {
                        CheckboxButton(isChecked: $items[index].isChecked)
                        Spacer()
                        Text(items[index].fileName)
                            .font(Font.custom("Lato", size: 16).weight(.semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.black)
                        
                        Spacer()
                        
                        Text(items[index].fileSize)
                            .font(Font.custom("Lato", size: 16).weight(.semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.black)
                        Spacer()
                        Text("\(items[index].optimizationPercentage)%")
                            .font(Font.custom("Lato", size: 16).weight(.semibold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.black)
                    }
                    .listRowBackground(index % 2 == 0 ? Color.gray.opacity(0.2) : Color.white)
        
                }

                    }
            
            HStack {
                Spacer()
                
                Text("Total Files Added: 18")
                    .font(
                        Font.custom("Lato", size: 16)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(20)
                    .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.15))
                    .cornerRadius(5)

                
                Text("Total Size: 50.26MB")
                    .font(
                        Font.custom("Lato", size: 16)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(20)
                    .background(Color(red: 0.02, green: 0.27, blue: 0.58).opacity(0.15))
                    .cornerRadius(5)

                
                Text("Shrink Size: 25.23 MB(50%)")
                    .font(
                        Font.custom("Lato", size: 16)
                            .weight(.semibold)
                    )
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding(20)
                    .background(Color(red: 0.83, green: 0, blue: 0.1).opacity(0.15))
                    .cornerRadius(5)

                
                Spacer()
            }
            
            HStack {
                Button(action: {
                    // Perform action for Add File button
                }) {
                    Image(systemName: "trash.fill")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color(red: 0.02, green: 0.27, blue: 0.58))
                        .cornerRadius(10)
                }
                Spacer()
                
                
                Button(action: {
                    // Perform action for the button
                }) {
                    Text("Shrink your files")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: 256) // Increase the width to fill the available space
                        .background(Color(red: 0.83, green: 0, blue: 0.1))
                        .cornerRadius(20)
                }
                .frame(height: 40) // Decrease the height of the button
                Spacer()
                
                HStack {
                   
                    
                    Button(action: {
                        // Perform action for Add File button
                    }) {
                        Image(systemName: "doc.badge.plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0.83, green: 0, blue: 0.1))
                            .cornerRadius(10)
                    }
                    .frame(height: 40)
                    
                    Button(action: {
                        // Perform action for Add Folder button
                    }) {
                        Image(systemName: "folder.badge.plus")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0.83, green: 0, blue: 0.1))
                            .cornerRadius(10)
                    }
                    .frame(height: 40)
                    
                    Button(action: {
                        // Perform action for third button
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color(red: 0.83, green: 0, blue: 0.1))
                            .cornerRadius(10)
                    }
                    .frame(height: 40)
                    
        
                }
                .frame(height: 40) // Decrease the height of the nested HStack
            }

        }
        .padding()
    }
}



struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}




struct SectionHeaderView: View {
    var body: some View {
        HStack {
            Button(action: {
                // Toggle all optimizations
            }) {
                Image(systemName: "square")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            Text("File Name")
                .fontWeight(.bold)
            Spacer()
            Text("File Size")
                .fontWeight(.bold)
            Spacer()
            Text("Optimize %")
                .fontWeight(.bold)
        }
        .foregroundColor(.white)
        .background(Color.blue)
        .cornerRadius(8)
        .padding(4)
    }
}



struct CheckboxButton: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                .foregroundColor(isChecked ? Color(red: 0.02, green: 0.27, blue: 0.58) : Color.black.opacity(0.6))
        }
    }
}
