//
//  HomeView.swift
//  barky
//
//  Created by Derrick Lee on 11/12/20.
//

import Foundation
import SwiftUI

// code that allows us to display all user's dogs on the home page.
struct HomeView: View {
    @ObservedObject var profile: User = user
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    // for each user profile in our database,
                    ForEach(userArr, id:\.id) { prf in
                        //for all dogs in each user profile,
                    ForEach(prf.listOfDogs, id: \.id) { dog in
                        NavigationLink(destination: detailedView(dog: dog,profile: prf)) {
                            LargeDogCard(dog: dog)
                        }.padding(0)
                    }
                    }
                }
            }
            .navigationBarTitle("Home")
        }
    }
}
