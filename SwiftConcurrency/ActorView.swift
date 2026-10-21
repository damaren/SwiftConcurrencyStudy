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
            Button("Create and access actor") {
                createAndAccessActor()
            }
        }
        .navigationTitle("Actors")
    }
    
    private func createAndAccessActor() {
        actor MyActor {
            var myInt = 0
            
            func myFunc() {
                myInt += 1
            }
        }
        
        let myActor = MyActor()
        
        Task {
            await myActor.myFunc()
        }
        
        Task {
            let value = await myActor.myInt
            print("myInt: \(value)")
        }
    }
}
