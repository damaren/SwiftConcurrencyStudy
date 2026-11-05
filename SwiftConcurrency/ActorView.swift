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
            
            Button("Main actor") {
                mainActor()
            }
            
            Button("Actor Hopping") {
                actorHopping()
            }
            
            Button("Actor reentrancy") {
                actorReentrancy()
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
    
    nonisolated private func mainActor() {
        Task {
            await MainActor.run {
                print("On the main actor")
            }
        }
        
        @MainActor
        func mainActorFunc() {
            print("This can only execute on the main actor")
        }
        
        Task {
            await mainActorFunc()
        }
        
        print("This is called from a non isolated context")
    }
    
    private func actorHopping() {
        func printThreadInfo() {
            print("Main: \(Thread.isMainThread). Thread: \(Thread.current)")
        }
        
        actor NotTheMainActor {
            func doWork(_ i: Int) {
                print("Main: \(Thread.isMainThread). Thread: \(Thread.current). Doing work: \(i)")
            }
        }
        
        let localActor = NotTheMainActor()
        
        @MainActor // not really necessary because we inherit the MainActor context from the SwiftUI view, but still useful for educational purposes
        func doIterativeWork() {
            Task {
                for i in 1...100 {
                    printThreadInfo()
                    await localActor.doWork(i)
                }
            }
        }
        
        doIterativeWork()
    }
    
    private func actorReentrancy() {
        actor MyActor {
            var score: Int = 0
            
            func increaseScore() {
                Task {
                    score += 1
                    try? await Task.sleep(for: .seconds(1))
                    print("Score: \(score)")
                }
            }
        }
        
        let actor = MyActor()
        
        Task {
            await actor.increaseScore()
            await actor.increaseScore()
            await actor.increaseScore()
        }
    }
}
