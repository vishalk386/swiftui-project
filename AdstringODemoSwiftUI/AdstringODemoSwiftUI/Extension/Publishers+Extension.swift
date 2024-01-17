//
//  Publishers+Extension.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 16/05/23.
//

import SwiftUI
import Combine
//
//extension Publishers {
//    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
//        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
//            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 }
//        
//        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
//            .map { _ -> CGFloat in 0 }
//        
//        return MergeMany(willShow, willHide)
//            .eraseToAnyPublisher()
//    }
//}
