//
//  ThreadsAndQueuesView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 02/09/26.
//

import SwiftUI

struct ThreadsAndQueuesView: View {
    var body: some View {
        VStack {
            Button("Create a thread") {
                Task {
                    await createThreadDirectly()
                }
            }
            
            Button("Simple queue example") {
                simpleQueueExample()
            }
            
            Button("Queue concurrency example") {
                runQueueConcurrencyExample()
            }
            
            Button("Queue sync work example") {
                runQueueSyncWorkExample()
            }
            
            Button("Serial queue example") {
                runSerialQueueExample()
            }
            
            Button("Concurrent queue example") {
                runConcurrentQueueExample()
            }
            
            Button("Race condition example") {
                runRaceConditionExample()
            }
            
            Button("Race condition fixed example") {
                runRaceConditionFixedExample()
            }
            
            Button("Without Barrier example") {
                withoutBarrierExample()
            }
            
            Button("Barrier example") {
                barrierExample()
            }
            
            Button("Wait for all tasks to finish with a group") {
                dispatchGroupExample()
            }
            
            Button("Do heavy work and then update the UI") {
                backgroundWorkExample()
            }
            
            Button("Semaphore example") {
                semaphoreExample()
            }
            
            Button("Qos/priority example") {
                qosExample()
            }
            
            Button("Main queue example") {
                mainQueueExample()
            }
        }
        .navigationTitle("Threads And Queues")
    }
    
    private func createThreadDirectly() async {
        print("Creating a thread directly")
        
        let thread = Thread {
            print("This is inside the directly created thread")
        }
        
        print("Is Main Thread: \(thread.isMainThread)")
        print("Is thread finished: \(thread.isFinished)")
        
        thread.start()
        
        try? await Task.sleep(for: .milliseconds(100))
        
        print("Is thread finished: \(thread.isFinished)")
    }
    
    private func simpleQueueExample() {
        let queue = DispatchQueue(label: "Simple Serial Queue")
        
        queue.async {
            print("This work was scheduled in a queue")
            print("Thread: \(Thread.current)")
        }
    }
    
    private func runQueueConcurrencyExample() {
        let queue = DispatchQueue(label: "Queue For Concurrency Example")
        
        print("1")
        
        queue.async {
            print("2")
        }
        
        print("3")
        
        queue.async {
            print("4")
        }
        
        print("5")
    }
    
    private func runQueueSyncWorkExample() {
        Task {
            let queue = DispatchQueue(label: "Queue For Concurrency Example")
            
            print("1")
            
            queue.sync {
                print("2")
            }
            
            print("3")
            
            queue.sync {
                print("4")
            }
            
            print("5")
        }
    }
    
    private func runSerialQueueExample() {
        let queue = DispatchQueue(label: "Serial Queue Example")
        
        queue.async {
            print("Task 1 - Start")
            
            Thread.sleep(forTimeInterval: 2)
            
            print("Task 1 - End")
        }
        
        queue.async {
            print("Task 2 - Start")
            
            Thread.sleep(forTimeInterval: 1)
            
            print("Task 2 - End")
        }
        
        queue.async {
            print("Task 3 - Start")
            print("Task 3 - End")
        }
    }
    
    private func runConcurrentQueueExample() {
        let queue = DispatchQueue(label: "Concurrent Queue Example", attributes: .concurrent)
        
        queue.async {
            print("Task 1 - Start")
            
            Thread.sleep(forTimeInterval: 2)
            
            print("Task 1 - End")
        }
        
        queue.async {
            print("Task 2 - Start")
            
            Thread.sleep(forTimeInterval: 1)
            
            print("Task 2 - End")
        }
        
        queue.async {
            print("Task 3 - Start")
            print("Task 3 - End")
        }
    }
    
    private func runRaceConditionExample() {
        let queue = DispatchQueue(label: "Race Condition Example", attributes: .concurrent)
        
        var count = 0
        
        let group = DispatchGroup()
        
        for _ in 1...100_000 {
            group.enter()
            
            queue.async {
                count += 1
                group.leave()
            }
        }
        
        group.wait()
        
        print("Count: \(count)")
    }
    
    private func runRaceConditionFixedExample() {
        let queue = DispatchQueue(label: "Race Condition Fixed Example")
        
        var count = 0
        
        let group = DispatchGroup()
        
        for _ in 1...100_000 {
            group.enter()
            
            queue.async {
                count += 1
                group.leave()
            }
        }
        
        group.wait()
        
        print("Count: \(count)")
    }
    
    private func withoutBarrierExample() {
        let queue = DispatchQueue(label: "Barrier example", attributes: .concurrent)
        
        queue.async {
            print("Read 1 start")
            
            Thread.sleep(forTimeInterval: 2)
            
            print("Read 1 end")
        }
        
        queue.async {
            print("Read 2 start")
            
            Thread.sleep(forTimeInterval: 2)
            
            print("Read 2 end")
        }
        
        queue.async {
            print("Write started")
            
            Thread.sleep(forTimeInterval: 1)
            
            print("Write ended")
        }
        
        queue.async {
            print("Read 3 start")
            
            print("Read 3 end")
        }
        
        queue.async {
            print("Read 4 start")
            
            print("Read 4 end")
        }
    }
    
    private func barrierExample() {
        let queue = DispatchQueue(label: "Barrier example", attributes: .concurrent)
        
        queue.async {
            print("Read 1 start")
            
            Thread.sleep(forTimeInterval: 2)
            
            print("Read 1 end")
        }
        
        queue.async {
            print("Read 2 start")
            
            Thread.sleep(forTimeInterval: 2)
            
            print("Read 2 end")
        }
        
        queue.async(flags: .barrier) {
            print("Write started")
            
            Thread.sleep(forTimeInterval: 1)
            
            print("Write ended")
        }
        
        queue.async {
            print("Read 3 start")
            
            print("Read 3 end")
        }
        
        queue.async {
            print("Read 4 start")
            
            print("Read 4 end")
        }
    }
    
    private func dispatchGroupExample() {
        let queue = DispatchQueue.global()
        let group = DispatchGroup()
        
        group.enter()
        
        queue.async {
            print("Task 1 started")
            Thread.sleep(forTimeInterval: 1)
            print("Task 1 ended")
            
            group.leave()
        }
        
        group.enter()
        
        queue.async {
            print("Task 2 started")
            Thread.sleep(forTimeInterval: 1)
            print("Task 2 ended")
            
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("All tasks finished")
        }
    }
    
    private func backgroundWorkExample() {
        let queue = DispatchQueue.global()
        
        print("Before async - main:", Thread.isMainThread)
        
        queue.async {
            print("Calculating - main:", Thread.isMainThread)
            
            var sum = 0
            
            for i in 0..<1_000_000 {
                sum += i
            }
            
            DispatchQueue.main.async {
                print("Updating UI - main:", Thread.isMainThread)
                print("Work finished, now we can update the UI with the sum: \(sum)")
            }
        }
        
        print("After async - main:", Thread.isMainThread)
    }
    
    private func semaphoreExample() {
        let queue = DispatchQueue.global()
        
        print(queue.qos)

        let semaphore = DispatchSemaphore(value: 2)

        for i in 1...5 {
            queue.async {
                semaphore.wait()

                print("Task \(i) started")

                Thread.sleep(forTimeInterval: 2)

                print("Task \(i) finished")

                semaphore.signal()
            }
        }
    }
    
    private func qosExample() {
        let highPriorityQueue = DispatchQueue(
            label: "com.example.highPriority",
            qos: .userInitiated,
            attributes: .concurrent
        )

        let lowPriorityQueue = DispatchQueue(
            label: "com.example.lowPriority",
            qos: .background,
            attributes: .concurrent
        )

        lowPriorityQueue.async {
            print("Background task started")

            var sum = 0

            for i in 0..<10_000_000 {
                sum += i
            }

            print("Background task finished: \(sum)")
        }

        highPriorityQueue.async {
            print("User-initiated task started")

            var sum = 0

            for i in 0..<10_000_000 {
                sum += i
            }

            print("User-initiated task finished: \(sum)")
        }
    }
    
    private func mainQueueExample() {
        for _ in 0..<200 {
            DispatchQueue.global().async {
                print("Global queue. isMainThread: \(Thread.isMainThread). Thread: \(Thread.current)")
            }
        }
        
        for _ in 0..<20 {
            DispatchQueue.main.async {
                print("Main queue. isMainThread: \(Thread.isMainThread). Thread: \(Thread.current)")
            }
        }
    }
}
