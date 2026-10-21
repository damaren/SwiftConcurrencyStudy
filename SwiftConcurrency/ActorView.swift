//
//  ActorView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 21/10/26.
//

import SwiftUI

struct ActorView: View {
    var body: some View {
        List {
            Button("Tap me") {
                print("Button tapped")
            }
        }
        .navigationTitle("Actors")
    }
}

#Preview {
    ActorView()
}
