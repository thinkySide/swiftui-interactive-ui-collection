//
//  ContentView.swift
//  Infinite_Looping_ScrollView_iOS_17
//
//  Created by 김민준 on 9/15/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Looping ScrollView")
        }
    }
}

#Preview {
    ContentView()
}
