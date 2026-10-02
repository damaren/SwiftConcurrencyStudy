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
}
