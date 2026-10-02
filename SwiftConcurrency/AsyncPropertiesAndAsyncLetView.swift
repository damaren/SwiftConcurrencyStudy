//
//  AsyncPropertiesAndAsyncLetView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 10/09/26.
//

import SwiftUI

struct AsyncPropertiesAndAsyncLetView: View {
    @State private var optionalString: String?
    
    @State private var optionalIndependentValueOne: String?
    @State private var optionalIndependentValueTwo: String?
    
    private var exampleAsyncVar: String {
        get async {
            return await someAsyncWork()
        }
    }
    
    var body: some View {
        List {
            Text(optionalString == nil ? "Haven't accessed the async var yet" : optionalString!)
            
            Button("Access async var") {
                Task {
                    optionalString = await exampleAsyncVar
                }
            }
            
            Text(optionalIndependentValueOne == nil ? "Haven't set value one yet" : optionalIndependentValueOne!)
            Text(optionalIndependentValueTwo == nil ? "Haven't set value two yet" : optionalIndependentValueTwo!)
            Button("Async let example") {
                Task {
                    await asyncLetExample()
                }
            }
        }
        .navigationTitle("Async Properties and Async Let")
    }
    
    private func asyncLetExample() async {
        async let firstIndependentResult = indepentendAsyncFuncOne()
        
        async let secondIndependentResult = indepentendAsyncFuncTwo()
        
        optionalIndependentValueOne = await firstIndependentResult
        optionalIndependentValueTwo = await secondIndependentResult
    }
    
    private func someAsyncWork() async -> String {
        let randomInt = Int.random(in: 0...100)
        return "Hello there \(randomInt)"
    }
    
    private func indepentendAsyncFuncOne() async -> String {
        let randomInt = Int.random(in: 0...100)
        return "Independent value one \(randomInt)"
    }
    
    private func indepentendAsyncFuncTwo() async -> String {
        let randomInt = Int.random(in: 0...100)
        return "Independent value two \(randomInt)"
    }
}
