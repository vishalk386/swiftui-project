//
//  LoginView.swift
//  AdstringODemoSwiftUI
//
//  Created by Vishal Kamble on 16/05/23.
//

import SwiftUI
import Combine


struct LoginView: View {
    // MARK: - Propertiers
    @State private var email = ""
    @State private var password = ""
    @State private var isLoggedIn = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var showContentView = false
    
    init() {
        setupNavigationBarAppearance(titleColor: UIColor.red, barColor: UIColor(.blue))
    }
    
    var body: some View {
       
            VStack(spacing: 20) {
                Text("AdstringO Software Tool")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .padding(.top, 40)
                    .shadow(radius: 10.0, x: 20, y: 10)
                
                Image("logo")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10.0, x: 20, y: 10)
                    .padding(.bottom, 50)
                
                VStack(alignment: .leading, spacing: 15) {
                    TextField("Email", text: self.$email)
                        .padding()
                        .keyboardType(.emailAddress)
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .textContentType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onAppear {
                            self.email = "test@example.com" // Set the hard-coded email value
                        }
                    
                    SecureField("Password", text: self.$password)
                        .padding()
                        .background(Color.themeTextField)
                        .cornerRadius(20.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                        .textContentType(.password)
                        .onAppear {
                            self.password = "password" // Set the hard-coded password value
                        }
                }
                .padding([.leading, .trailing], 27.5)
                
                Button(action: {
                    if let errorMessage = self.validateFields() {
                        print(errorMessage)
                        return
                    }
                    
                    // Hardcoded email and password for demonstration purposes
                    let hardcodedEmail = "test@example.com"
                    let hardcodedPassword = "password"
                    
                    if email == hardcodedEmail && password == hardcodedPassword {
                        showContentView = true
                    } else {
                        print("Invalid email or password")
                    }
                }) {
                    Text("Sign In")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                        .shadow(radius: 10.0, x: 20, y: 10)
                }.padding(.top, 50)
                
                Spacer()
                
                HStack(spacing: 0) {
                    Text("Don't have an account?")
                    Button(action: {}) {
                        Text("Sign Up")
                            .foregroundColor(.black)
                    }
                }
                
            }

//        .padding(.bottom, keyboardHeight) // Adjust the bottom padding based on the keyboard height
        .padding()
        .gradientBackground()
        .ignoresSafeArea(.keyboard)
               .onReceive(Publishers.keyboardHeight) { height in
                   self.keyboardHeight = height
               }
               .animation(.easeOut(duration: 0.3)) // Add animation for smooth transition
               .offset(y: -keyboardHeight / 3) // Adjust the offset based on your needs
        .fullScreenCover(isPresented: $showContentView) {
            MainView()
        }
    }


    
    // MARK: - Email Validation
    private func validateFields() -> String? {
        if email.isEmpty {
            return "Email is empty"
        }
        
        if !isValidEmail(email) {
            return "Invalid email format"
        }
        
        if password.isEmpty {
            return "Password is empty"
        }
        
        if password.count < 5 {
            return "Password should be at least 8 characters long"
        }
        
        // Add any additional validation as needed
        
        return nil
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}






extension Publishers {
    static var keyboardHeight: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return MergeMany(willShow, willHide)
            .eraseToAnyPublisher()
    }
}
