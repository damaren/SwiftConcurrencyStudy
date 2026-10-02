//
//  ConcurrencyView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 01/09/26.
//

import SwiftUI

struct ConcurrencyView: View {
    @State private var executionResult = [String]()
    
    var body: some View {
        List {
            Button("Single task") {
                singleTaskFunc()
            }
            
            Button("Multiple task") {
                multipleTaskFunc()
            }
            
            ForEach(executionResult, id: \.self) { result in
                Text(result)
            }
        }
        .navigationTitle("Concurrency")
    }
    
    private func singleTaskFunc() {
        executionResult = []
        
        executionResult.append("Single task - beginning")
        
        Task {
            executionResult.append("Inside the task. This can execute out of order")
        }
        
        executionResult.append("Single task - end")
    }
    
    private func multipleTaskFunc() {
        executionResult = []
        
        executionResult.append("Multiple task - beginning")
        
        Task {
            for i in 0...20 {
                executionResult.append("First task: \(i)")
                try? await Task.sleep(nanoseconds: 100)
            }
        }
        
        Task {
            for i in 0...20 {
                executionResult.append("Second task: \(i)")
                try? await Task.sleep(nanoseconds: 100)
            }
        }
        
        executionResult.append("Multiple task - end")
    }
}
