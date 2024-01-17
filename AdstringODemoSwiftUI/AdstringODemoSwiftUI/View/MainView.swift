//
//  MainView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 16/05/23.
//
import SwiftUI
import UIKit
import PhotosUI

struct MainView: View {
    @ObservedObject var imagePickerModel = ImagePickerModel()
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentVideoPicker = false
    @State private var shouldPresentActionSheet = false
    @State private var shouldPresentCamera = false
    @State private var showOutputsView = false
    @State private var showResultView = false
    @State private var showSettingView = false
    @State private var isLoggedIn = true
   
    
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.setBackIndicatorImage(UIImage(systemName: "chevron.left"), transitionMaskImage: UIImage(systemName: "chevron.left"))
        appearance.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().tintColor = .white
    }
    var body: some View {
        if isLoggedIn {
            NavigationView {
                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        ButtonRow(title: "Image Compression", systemImage: "photo.stack.fill", backgroundColor: .blue) {
                            shouldPresentActionSheet = true
                            shouldPresentVideoPicker = false
                        }
                        Spacer()
                        ButtonRow(title: "Video Compression", systemImage: "video.fill", backgroundColor: .red) {
                            shouldPresentActionSheet = true
                            shouldPresentVideoPicker = true
                        }
                    }
                    .actionSheet(isPresented: $shouldPresentActionSheet) { () -> ActionSheet in
                    if shouldPresentVideoPicker {
                        return ActionSheet(
                            title: Text("Choose mode"),
                            message: Text("Please choose your preferred mode to compress video"),
                            buttons: [
                                ActionSheet.Button.default(Text("Camera"), action: {
                                    self.shouldPresentVideoPicker = true
                                    self.shouldPresentImagePicker = true
                                    self.shouldPresentCamera = true
                                }),
                                ActionSheet.Button.default(Text("Photo Library"), action: {
//                                    checkPhotoLibraryAuthorizationStatus {
                                        self.shouldPresentVideoPicker = true
                                        self.shouldPresentImagePicker = true
                                        self.shouldPresentCamera = false
//                                    }
                                }),
                                ActionSheet.Button.cancel()
                            ]
                        )
                    } else {
                        return ActionSheet(
                            title: Text("Choose mode"),
                            message: Text("Please choose your preferred mode to compress image"),
                            buttons: [
                                ActionSheet.Button.default(Text("Camera"), action: {
                                    self.shouldPresentVideoPicker = false
                                    self.shouldPresentImagePicker = true
                                    self.shouldPresentCamera = true
                                }),
                                ActionSheet.Button.default(Text("Photo Library"), action: {
                                    checkPhotoLibraryAuthorizationStatus {
                                        self.shouldPresentVideoPicker = false
                                        self.shouldPresentImagePicker = true
                                        self.shouldPresentCamera = false
                                    }
                                }),
                                ActionSheet.Button.cancel()
                            ]
                        )
                    }
                }
                    Spacer().frame(height: 20)
                    HStack(spacing: 20) {
                        ButtonRow(title: "Outputs", systemImage: "folder.fill", backgroundColor: .green) {
                            showOutputsView = true
                        }
                        NavigationLink(destination: OutputsView(), isActive: $showOutputsView) {
                            EmptyView()
                        }
                        .hidden()
                        Spacer()
                        
                        ButtonRow(title: "Settings", systemImage: "gearshape.fill", backgroundColor: .yellow) {
                            showSettingView = true
                        }
                       
                    }
                    
                    Spacer()
                    
                    Text("© 2023 AdstringO Software Pvt. Ltd. All rights reserved.")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                }
                
                .navigationBarItems(leading:
                    HStack {
                    Spacer()
                        Image("logo")
                            .resizable()
                            .clipShape(Circle())
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                    Text("AdstringO Software Tool")
                        .font(.system(size: 20))
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                    }
                )
                .toolbarBackground(
                    Color.clear,
                                for: .navigationBar)
                .navigationBarItems(trailing: LogoutButton(logoutAction: handleLogout))
                
                .background(
                    Group {
                        NavigationLink(
                            destination: ImageResultView(imagePickerModel: imagePickerModel),
                            isActive: $imagePickerModel.isImageSelected
                        ) {
                            EmptyView()
                        }
                        .hidden()
                        
                        NavigationLink(
                            destination: ImageResultView(imagePickerModel: imagePickerModel),
                            isActive: $imagePickerModel.isVideoSelected
                        ) {
                            EmptyView()
                        }
                        .hidden()
                        
                        NavigationLink(destination: SettingsMenuView(), isActive: $showSettingView) {
                            EmptyView()
                        }
                        .hidden()
                    }
                )

                .onAppear {
                            DispatchQueue.main.async {
                                // Preload the image picker view when the view appears
                               
                                UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]

                                _ = VUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, imagePickerModel: imagePickerModel, shouldPresentVideoPicker: $shouldPresentVideoPicker,shouldPresentImagePicker: $shouldPresentImagePicker)
                            }
                        }
               
                .sheet(isPresented: $shouldPresentImagePicker) {
                    if shouldPresentCamera {
                        VUImagePickerView(sourceType: .camera, imagePickerModel: imagePickerModel, shouldPresentVideoPicker: $shouldPresentVideoPicker,shouldPresentImagePicker: $shouldPresentImagePicker)
                    } else {
                        VUImagePickerView(sourceType: .photoLibrary, imagePickerModel: imagePickerModel,  shouldPresentVideoPicker: $shouldPresentVideoPicker,shouldPresentImagePicker: $shouldPresentImagePicker)
                    }
                }

                .gradientBackground()
            }
        }else {
            LoginView()
        }
    
    }
    
    
    func handleLogout() {
           isLoggedIn = false
       }
    private func checkPhotoLibraryAuthorizationStatus(completion: @escaping () -> Void) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            completion()
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized {
                    DispatchQueue.main.async {
                        completion()
                    }
                }
            }
        case .denied, .restricted:
            // Handle denied or restricted authorization status
            // Show an alert or guide the user to settings to enable photo library access
            break
        case .limited: break
        @unknown default:
            break
        }
    }
   
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}




struct CommonNavigationTitleModifier: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(.white)
            .accentColor(.white)
    }
}
