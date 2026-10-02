//
//  ContinuationsView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 12/09/26.
//

import SwiftUI

struct ContinuationsView: View {
    var body: some View {
        List {
            Button("Func with completion example") {
                fetchMessages { messages in
                    print(messages)
                }
            }
            
            Button("Convert to async await with continuations example") {
                Task {
                    let messages = await withCheckedContinuation { continuation in
                        fetchMessages { messages in
                            continuation.resume(returning: messages)
                        }
                    }
                    
                    print(messages)
                }
            }
        }
        .navigationTitle("Continuations")
    }
    
    /// Snippet copied from https://www.hackingwithswift.com/quick-start/concurrency/how-to-use-continuations-to-convert-completion-handlers-into-async-functions
    struct Message: Decodable, Identifiable {
        let id: Int
        let from: String
        let message: String
    }

    func fetchMessages(completion: @Sendable @escaping ([Message]) -> Void) {
        let url = URL(string: "https://hws.dev/user-messages.json")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data {
                if let messages = try? JSONDecoder().decode([Message].self, from: data) {
                    completion(messages)
                    return
                }
            }

            completion([])
        }.resume()
    }
    /// End of snippet copied from https://www.hackingwithswift.com/quick-start/concurrency/how-to-use-continuations-to-convert-completion-handlers-into-async-functions
}
