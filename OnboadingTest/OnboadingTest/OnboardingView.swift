//
//  OnboardingView.swift
//  OnboadingTest
//
//  Created by Vishal Kamble on 22/11/23.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    private let onboardingPages: [OnboardingPage] = [
        OnboardingPage(imageName: "sm1"),
        OnboardingPage(imageName: "sm2"),
        OnboardingPage(imageName: "sm3"),
        OnboardingPage(imageName: "sm4"),
        OnboardingPage(imageName: "sm5"),
        OnboardingPage(imageName: "sm6"),
        OnboardingPage(imageName: "sm7"),
        OnboardingPage(imageName: "sm8"),
        OnboardingPage(imageName: "sm9"),
    ]

    var body: some View {

            ZStack {
                // Container view for the image
                Image(onboardingPages[currentPage].imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .edgesIgnoringSafeArea(.all)

            HStack {
                Button("Skip") {
                    // Handle skip action
                    print("Skip pressed")
                }
                Spacer()

                if currentPage == onboardingPages.count - 1 {
                    Button("Finish") {
                        // Handle finish action or navigate to the main screen
                        print("Onboarding completed")
                    }
                } else {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    })
                    
                    Button("Next") {
                        // Handle next action
                        currentPage += 1
                    }
                }
            }
            .padding()
        }
        .frame(minWidth: 500, minHeight: 400)
    }
}

struct OnboardingPage {
    let imageName: String
    // You can add more properties for additional onboarding page information
}

#Preview {
    OnboardingView()
}
