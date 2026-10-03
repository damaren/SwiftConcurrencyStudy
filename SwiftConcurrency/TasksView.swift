//
//  TasksView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 01/10/26.
//

import SwiftUI

struct TasksView: View {
    var body: some View {
        List {
            Button("Non returning task example") {
                Task {
                    print("This task doesn't return anything")
                }
            }
            
            Button("Returning task example") {
                Task {
                    await returningTaskExample()
                }
            }
            
            Button("Task with explicit return value example") {
                Task {
                    await explicitReturnTypeExample()
                }
            }
            
            Button("Detached vs non detached example") {
                Task {
                    await detachedVsNonDetachedExample()
                }
            }
        }
        .navigationTitle("Tasks")
    }
    
    private func returningTaskExample() async {
        let task = Task {
            return("This task returns a string")
        }
        
        let result = await task.value
        print(result)
    }
    
    private func explicitReturnTypeExample() async {
        let task = Task<String, Never> {
            return("This is the return value of a task with an explicit return type (String)")
        }
        
        let result = await task.value
        print(result)
    }
    
    private func detachedVsNonDetachedExample() async {
        Task {
            for i in 0...20 {
                print("Task 1: \(i)")
            }
        }
        
        Task {
            for i in 0...20 {
                print("Task 2: \(i)")
            }
        }
        
        try? await Task.sleep(for: .seconds(1))
        
        Task.detached {
            for i in 0...20 {
                print("Task detached 1: \(i)")
            }
        }
        
        Task.detached {
            for i in 0...20 {
                print("Task detached 2: \(i)")
            }
        }
    }
}
