//
//  ImagePickerModel.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 18/05/23.
//

import Foundation
import Photos
import UIKit
import SwiftUI


class ImagePickerModel: ObservableObject {
    private var _selectedImage: UIImage?
    private var _selectedPHAsset: PHAsset?
    private var _isPresented: Bool = false
    private var _isImageSelected: Bool = false
    private var _isVideoSelected: Bool = false
    private var _originalAssetSize: String?
    private var _originalAssetDimension: String?
    private var _selectedVideoURL: URL?

    var selectedImage: UIImage? {
        get { _selectedImage }
        set {
            _selectedImage = newValue
            objectWillChange.send()
        }
    }

    


    var selectedVideoURL: URL? {
            get { _selectedVideoURL }
            set {
                _selectedVideoURL = newValue
                _isImageSelected = false
                _isVideoSelected = newValue != nil
                objectWillChange.send()
            }
        }
    
    var isVideoSelected: Bool {
        get { _isVideoSelected }
        set {
            _isVideoSelected = newValue
            objectWillChange.send()
        }
    }
    var selectedPHAsset: PHAsset? {
        get { _selectedPHAsset }
        set {
            _selectedPHAsset = newValue
            objectWillChange.send()
        }
    }

    var isPresented: Bool {
        get { _isPresented }
        set {
            _isPresented = newValue
            objectWillChange.send()
        }
    }

    var isImageSelected: Bool {
        get { _isImageSelected }
        set {
            _isImageSelected = newValue
            objectWillChange.send()
        }
    }
    
    var originalAssetSize: String? {
           get { _originalAssetSize }
           set {
               _originalAssetSize = newValue
               objectWillChange.send()
           }
       }
       
       var originalAssetDimension: String? {
           get { _originalAssetDimension }
           set {
               _originalAssetDimension = newValue
               objectWillChange.send()
           }
       }
}

