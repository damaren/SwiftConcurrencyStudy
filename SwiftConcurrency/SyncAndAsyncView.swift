//
//  SyncAndAsyncView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 07/09/26.
//

import SwiftUI

private func syncFunctionExample() {
    print("Sync func started")
    
    printThreadInfo()
    
    firstAuxSyncFunc()
    
    print("Sync func finished")
}

private func firstAuxSyncFunc() {
    print("First aux sync func started")
    
    printThreadInfo()
    
    secondAuxSyncFunc()
    
    print("First aux sync func finished")
}

private func secondAuxSyncFunc() {
    print("Second aux sync func started")
    
    printThreadInfo()
    
    print("Second aux sync func finished")
}

private func currentThreadID() -> UInt64 {
    var threadID: UInt64 = 0
    pthread_threadid_np(nil, &threadID)
    return threadID
}

private func printThreadInfo() {
    print("Thread ID: \(currentThreadID()). Is main: \(Thread.isMainThread)")
}

private func tasksWithBlockingFuncsExample() {
    print("Before tasks")
    printThreadInfo()
    
    Task {
        blockingFuncOne()
    }
    
    Task {
        blockingFuncTwo()
    }
    
    Task {
        blockingFuncThree()
    }
}

private func blockingFuncOne() {
    print("Blocking func one started")
    
    printThreadInfo()
    
    Thread.sleep(forTimeInterval: 3)
    
    print("Blocking func one finished")
}

private func blockingFuncTwo() {
    print("Blocking func two started")
    
    printThreadInfo()
    
    Thread.sleep(forTimeInterval: 2)
    
    print("Blocking func two finished")
}

private func blockingFuncThree() {
    print("Blocking func three started")
    
    printThreadInfo()
    
    Thread.sleep(forTimeInterval: 1)
    
    print("Blocking func three finished")
}

struct SyncAndAsyncView: View {
    var body: some View {
        List {
            Button("Sync function example") {
                Task.detached {
                    syncFunctionExample()
                }
            }
            
            Button("Sync function sequential example") {
                syncSequentialExample()
            }
            
            Button("Async function example") {
                asyncFunctionExample()
            }
            
            Button("Blocking the main thread example") {
                blockingMainThreadExample()
            }
            
            Button("Tasks with blocking funcs example") {
                Task.detached {
                    tasksWithBlockingFuncsExample()
                }
            }
        }
        .navigationTitle("Sync and Async")
    }
    
    private func syncSequentialExample() {
        firstSequentialSyncFunc()
        
        secondSequentialSyncFunc()
        
        thirdSequentialSyncFunc()
    }
    
    private func firstSequentialSyncFunc() {
        print("First aux func started")
        
        printThreadInfo()
        
        print("First aux func finished")
    }
    
    private func secondSequentialSyncFunc() {
        print("Second aux func started")
        
        printThreadInfo()
        
        print("Second aux func finished")
    }
    
    private func thirdSequentialSyncFunc() {
        print("Third aux func started")
        
        printThreadInfo()
        
        print("Third aux func finished")
    }
    
    private func asyncFunctionExample() {
        Task {
            await firstAsyncFunc()
        }
        
        Task {
            await secondAsyncFunc()
        }
        
        Task {
            await thirdAsyncFunc()
        }
    }
    
    private func firstAsyncFunc() async {
        print("First async func started")
        printThreadInfo()
        try? await Task.sleep(for: .seconds(3))
        print("First async func finished")
    }
    
    private func secondAsyncFunc() async {
        print("Second async func started")
        printThreadInfo()
        try? await Task.sleep(for: .seconds(2))
        print("Second async func finished")
    }
    
    private func thirdAsyncFunc() async {
        print("Third async func started")
        printThreadInfo()
        try? await Task.sleep(for: .seconds(1))
        print("Third async func finished")
    }
    
    private func blockingMainThreadExample() {
        Task {
            firstBlockingFunc()
        }
        
        Task {
            secondBlockingFunc()
        }
        
        Task {
            thirdBlockingFunc()
        }
    }
    
    private func firstBlockingFunc() {
        print("First blocking func started")
        printThreadInfo()
        Thread.sleep(forTimeInterval: 3)
        print("First blocking func finished")
    }
    
    private func secondBlockingFunc() {
        print("Second blocking func started")
        printThreadInfo()
        Thread.sleep(forTimeInterval: 2)
        print("Second blocking func finished")
    }
    
    private func thirdBlockingFunc() {
        print("Third blocking func started")
        printThreadInfo()
        Thread.sleep(forTimeInterval: 1)
        print("Third blocking func finished")
    }
}
