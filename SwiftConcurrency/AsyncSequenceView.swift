//
//  AsyncSequenceView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 15/09/26.
//

import SwiftUI

struct RandomIntGenerator: AsyncSequence, AsyncIteratorProtocol {
    func next() async -> Int? {
        return Int.random(in: 0...1_000_000)
    }
    
    func makeAsyncIterator() -> RandomIntGenerator {
        self
    }
}

struct FiniteIntGenerator: AsyncSequence, AsyncIteratorProtocol {
    let numberOfElements = 20
    var counter = 0
    
    mutating func next() async -> Int? {
        if counter < numberOfElements {
            counter += 1
            return Int.random(in: 0...1_000_000)
        } else {
            return nil
        }
    }
    
    func makeAsyncIterator() -> FiniteIntGenerator {
        self
    }
}

extension AsyncSequence {
    public func collect() async throws -> [Element] {
        try await self.reduce(into: [Element]()) { $0.append($1) }
    }
}

struct AsyncSequenceView: View {
    @State private var resultingIntegers = [Int]()
    @State nonisolated private var nextGenerator = FiniteIntGenerator()
    @State private var currentIntUsingNext: Int? = 0
    @State private var originalValue = 0
    @State private var result = 0
    
    private let intGenerator = RandomIntGenerator()
    
    var body: some View {
        VStack {
            Button("Generate another integer with an infinite async sequence") {
                Task {
                    originalValue = await intGenerator.next() ?? 0
                    result = originalValue
                }
            }
            
            Button("Iterate over an async sequence using next") {
                Task {
                    currentIntUsingNext = await nextGenerator.next()
                }
            }
            
            if let currentIntUsingNext {
                Text("Current integer using the 'next()' func: \(currentIntUsingNext)")
            } else {
                Text("The sequence reached it's end")
            }
            
            Button("Generate 20 integers with an async sequence") {
                resultingIntegers = []
                let generator = FiniteIntGenerator()
                Task {
                    for await randomInt in generator {
                        resultingIntegers.append(randomInt)
                    }
                }
            }
            
            Button("Generate 20 integers and filter the odd integers out") {
                resultingIntegers = []
                let generator = FiniteIntGenerator().filter { $0 % 2 == 0 }
                Task {
                    for await randomInt in generator {
                        resultingIntegers.append(randomInt)
                    }
                }
            }
            
            Button("Create an array from an async sequence") {
                resultingIntegers = []
                let generator = FiniteIntGenerator()
                Task {
                    let array = try? await generator.collect()
                    resultingIntegers = array ?? []
                }
            }
            
            if !resultingIntegers.isEmpty {
                List {
                    ForEach(Array(resultingIntegers.enumerated()), id: \.offset) { _, integer in
                        Text("\(integer)")
                    }
                }
            }
            
            Button("Map integers to 3n+1 or n/2") {
                Task {
                    let mappedIntGenerator = intGenerator.map { value in
                        originalValue = value
                        if value%2 == 0 {
                            result = value/2
                        } else {
                            result = value*3 + 1
                        }
                    }
                    
                    var seq = mappedIntGenerator.makeAsyncIterator()
                    
                    await seq.next()
                }
            }
            
            Button("Sum over a 20 integers using reduce") {
                let generator = FiniteIntGenerator()
                Task {
                    let sum = await generator.reduce(0) { result, value in return result + value }
                    
                    originalValue = sum
                    result = sum
                }
            }
            
            Text("Original value: \(originalValue)")
            Text("Result: \(result)")
        }
        .navigationTitle("Async Sequences")
    }
}
