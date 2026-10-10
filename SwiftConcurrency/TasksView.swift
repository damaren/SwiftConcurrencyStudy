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
            
            Button("Make a task sleep example") {
                Task {
                    await makeTasksSleepExample()
                }
            }
            
            Button("Get a Swift.Result from a task") {
                Task {
                    await getSwiftResultFromTask()
                }
            }
            
            Button("Task priority example") {
                Task {
                    await taskPriorityExample()
                }
            }
            
            Button("Task priority escalation example") {
                Task {
                    await priorityEscalationExample()
                }
            }
            
            Button("Cancel a task") {
                Task {
                    await cancelATask()
                }
            }
            
            Button("Voluntarily suspend task") {
                Task {
                    await voluntarilySuspendWithYield()
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
    
    private func makeTasksSleepExample() async {
        Task {
            print("First task started")
            try? await Task.sleep(for: .seconds(1))
            print("First task ended")
        }
        
        let secondTask = Task {
            print("Second task started")
            do {
                try await Task.sleep(for: .seconds(1))
            } catch {
                print("Second task was cancelled mid sleep")
                return
            }
            print("Second task ended")
        }
        
        secondTask.cancel()
    }
    
    private func getSwiftResultFromTask() async {
        let nonThrowingTask = Task {
            return "nonThrowingTask return value"
        }
        
        let nonThrowingTaskResult = await nonThrowingTask.result
        
        let nonThrowingTaskValue = nonThrowingTaskResult.get()
        
        print(nonThrowingTaskValue)
        
        let throwingTask = Task {
            throw(NSError(domain: "Any error", code: 1))
        }
        
        let throwingTaskResult = await throwingTask.result
        
        do {
            try throwingTaskResult.get()
        } catch {
            print("Throwing task threw an error")
        }
    }
    
    private func taskPriorityExample() async {
        Task {
            for i in 1...50 {
                print("Task 1 - \(i)")
                
            }
        }
        
        Task {
            for i in 1...50 {
                print("Task 2 - \(i)")
                
            }
        }
        
        try? await Task.sleep(for: .seconds(1))
        

        Task(priority: .low) {
            for i in 1...50 {
                print("Task 3 - \(i)")
                
            }
        }
        
        Task(priority: .high) {
            for i in 1...50 {
                print("Task 4 - \(i)")
                
            }
        }
    }
    
    private func priorityEscalationExample() async {
        let outerTask = Task(priority: .high) {
            let innerTask = Task(priority: .low) {
                print("Inner: \(Task.currentPriority)")
                
                try? await Task.sleep(for: .seconds(1))
                
                print("Inner: \(Task.currentPriority)")
            }
            
            try? await Task.sleep(for: .seconds(0.5))
            await innerTask.value
        }
        
        await outerTask.value
    }
    
    private func cancelATask() async {
        let task1 = Task {
            print("Task 1 started")
            try? await Task.sleep(for: .seconds(1))
            print("Task 1 finished")
        }
        
        task1.cancel()
        
        let task2 = Task {
            print("Task 2 started")
            try? await Task.sleep(for: .seconds(1))
            if Task.isCancelled {
                print("Task 2 was cancelled.")
                return
            }
            print("Task 2 finished")
        }
        
        task2.cancel()
        
        let task3 = Task {
            print("Task 3 started")
            
            do {
                try Task.checkCancellation()
            } catch {
                print("Task 3 was cancelled.")
                return
            }
            
            print("Task 3 finished")
        }
        
        task3.cancel()
        
        let task4 = Task {
            print("Task 4 started")
            do {
                try await Task.sleep(for: .seconds(1))
            } catch {
                print("Task 4 was cancelled mid sleep")
                return
            }
            print("Task 4 finished")
        }
        
        task4.cancel()
    }
    
    private func voluntarilySuspendWithYield() async {
        var isTaskTwoFinished = false
        
        Task {
            print("Task 1 started")
            for i in 0...100_000 {
                for j in 0...1_000 {
                    if (i*j).isMultiple(of: 1_000) {
                        if !isTaskTwoFinished {
                            print("Task 1 - before yield")
                            await Task.yield()
                            print("Task 1 - after yield")
                        }
                    }
                }
            }
            print("Task 1 finished")
        }
        
        Task {
            print("Task 2 started")
            
            for i in 0...100 {
                print(i)
            }
            
            print("Task 2 finished")
            isTaskTwoFinished = true
        }
    }
}
