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
            
            Button("Isolated func param") {
                isolatedFuncParam()
            }
            
            Button("Nonisolated func") {
                nonIsolated()
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
    
    private func isolatedFuncParam() {
        actor MyActor {
            var name = "name"
            var list = [Int]()
        }
        
        func myFunc(myActor: isolated MyActor) {
            print(myActor.name)
            print(myActor.list)
        }
        
        Task {
            let myActor = MyActor()
            await myFunc(myActor: myActor)
        }
    }
    
    private func nonIsolated() {
        actor MyActor {
            var name = "name"
            let id = 1
            
            nonisolated func printName() async {
                print("My name is \(await name)")
            }
            
            nonisolated func printID() {
                print("My id is \(id)")
            }
        }
        
        let myActor = MyActor()
        
        myActor.printID()
        
        Task {
            await myActor.printName()
        }
    }
}
