//
//  ContentView.swift
//  OnBoarding
//
//  Created by Kentaro Mihara on 2023/07/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .preferredColorScheme(.light)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
