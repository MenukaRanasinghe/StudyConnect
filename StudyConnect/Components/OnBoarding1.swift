//
//  OnBoarding1.swift
//  StudyConnect
//
//  Created by Menuka 046 on 2025-04-09.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var onboardingCompleted=false
    
    let onboardingData = [
        ("OnBoarding1", "Find the perfect study group", "Join or create study groups based on your courses and interests!"),
        ("OnBoarding2", "Record & summarize your sessions", "Turn study sessions into notes with speech-to-text and AI summarization."),
        ("OnBoarding3", "Let’s Get Started!", "Join study groups, record your sessions, and track your progress—all in one place.")
           ]
    
    var body: some View {
        if onboardingCompleted{
            LoginPage()
        }
        else{
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        VStack(spacing: 20) {
                            Image(onboardingData[index].0)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 300)
                            
                            Text(onboardingData[index].1)
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 15)
                                .padding(.horizontal, 50)
                            
                            Text(onboardingData[index].2)
                                .font(.body)
                                .padding(.top, 10)
                                .padding(.horizontal, 50)
                            
                            Button(action: {
                                if currentPage == onboardingData.count - 1 {
                                    onboardingCompleted=true
                                } else {
                                    currentPage += 1
                                }
                            }) {
                                Text(currentPage == onboardingData.count - 1 ? "Get Started" : "Next")
                                    .fontWeight(.semibold)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .padding(.top, 30)
                            .padding([.leading, .trailing], 50)
                        }
                        .tag(index)
                        .padding(.top, 30)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                
                HStack(spacing: 10) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentPage ? Color.blue : Color.gray.opacity(0.4))
                            .frame(width: 12, height: 12)
                    }
                }
                .padding(.bottom, 30)
            }
        }
    }
}

#Preview {
    OnboardingView()
}

