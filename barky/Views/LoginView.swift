//
//  SwiftUIView.swift
//  barky
//
//  Created by Blue Bayani on 11/20/20.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationView {
                    VStack {
                        Text("Login to Bark!")
                            .font(.largeTitle)
                            .fontWeight(.medium)
                            .foregroundColor(Color.black)
                        Spacer()
                        NavigationLink(destination: ContentView()) {
                            Text("Login with Google")
                                .font(.system(size: 18, weight: .bold, design: .default))
                            .frame(minWidth: 0, maxWidth: 300)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.accentColor)
                                .cornerRadius(8)
                    }
                  }
                }
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
