//
//  AsyncStreamView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 22/09/26.
//

import SwiftUI

struct AsyncStreamView: View {
    var body: some View {
        List {
            Button("Async stream example") {
                Task {
                    await asyncStreamExample()
                }
            }
            
            Button("Read a prefix from a stream") {
                Task {
                    await readStreamPrefix()
                }
            }
            
            Button("Read the whole stream through a prefix") {
                Task {
                    await readWholeStreamThroughPrefix()
                }
            }
            
            Button("Read stream in multiple tasks") {
                Task.detached {
                    await readStreamInMultipleTasks()
                }
            }
            
            Button("Wait before adding more items to the stream") {
                Task {
                    await waitBeforeAddingMoreItems()
                }
            }
            
            Button("Unbounded buffer") {
                Task {
                    await unboundedBufferExample()
                }
            }
            
            Button("Buffer newest") {
                Task {
                    await bufferNewestExample()
                }
            }
            
            Button("Buffer oldest") {
                Task {
                    await bufferOldestExample()
                }
            }
        }
        .navigationTitle("Async Stream")
    }
    
    private func asyncStreamExample() async {
        let stream = AsyncStream { continuation in
            for i in 1...9 {
                continuation.yield(i)
            }

            continuation.finish()
        }

        for await item in stream {
            print(item)
        }
    }
    
    private func readStreamPrefix() async {
        let stream = AsyncStream { continuation in
            for i in 1...9 {
                continuation.yield(i)
            }
            
            continuation.finish()
        }
        
        for await item in stream.prefix(3) {
            print(item)
        }
    }
    
    private func readWholeStreamThroughPrefix() async {
        let stream = AsyncStream { continuation in
            
            for i in 0...9 {
                continuation.yield(i)
            }
            
            continuation.finish()
            
        }
        
        let prefix = stream.prefix(3)
        
        for _ in 0..<3 {
            
            print("Next 3:")
            
            for await i in prefix {
                print("Item: \(i)")
            }
        }
    }
    
    private func waitBeforeAddingMoreItems() async {
        let stream = AsyncStream { continuation in
            Task {
                for i in 0...9 {
                    continuation.yield(i)
                }
                
                try? await Task.sleep(for: .seconds(2))
                
                for i in 10...19 {
                    continuation.yield(i)
                }
            }
        }
        
        for await item in stream {
            print(item)
        }
    }
    
    private func unboundedBufferExample() async {
        let stream = AsyncStream(bufferingPolicy: .unbounded) { continuation in
            for i in 0...9 {
                continuation.yield(i)
            }
            
            continuation.finish()
        }
        
        try? await Task.sleep(for: .seconds(1))
        
        for await item in stream {
            print(item)
        }
    }
    
    private func bufferNewestExample() async {
        let stream = AsyncStream(bufferingPolicy: .bufferingNewest(5)) { continuation in
            for i in 0...9 {
                continuation.yield(i)
            }
            
            continuation.finish()
        }
        
        try? await Task.sleep(for: .seconds(1))
        
        for await item in stream {
            print(item)
        }
    }
    
    private func bufferOldestExample() async {
        let stream = AsyncStream(bufferingPolicy: .bufferingOldest(5)) { continuation in
            for i in 0...9 {
                continuation.yield(i)
            }
            
            continuation.finish()
        }
        
        try? await Task.sleep(for: .seconds(1))
        
        for await item in stream {
            print(item)
        }
    }
}

nonisolated func readStreamInMultipleTasks() async {
    let stream = AsyncStream { continuation in
        for i in 0...9 {
            continuation.yield(i)
        }
        
        continuation.finish()
    }
    
    Task {
        for await item in stream {
            print("First task: \(item)")
        }
    }
    
    Task {
        for await item in stream {
            print("Second task: \(item)")
        }
    }
    
    Task {
        for await item in stream {
            print("Third task: \(item)")
        }
    }
}
