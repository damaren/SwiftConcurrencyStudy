//
//  TableOfContentsView.swift
//  SwiftConcurrency
//
//  Created by José Damaren on 02/09/26.
//

import SwiftUI

enum MyPath: Hashable {
    case concurrency
    case threadsAndQueues
    case syncAndAsync
    case asyncPropertiesAndAsyncLet
    case continuations
    case asyncSequences
    case asyncStreams
    case tasks
}

struct TableOfContentsView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                Button("Concurrency") {
                    path.append(MyPath.concurrency)
                }
                
                Button("Threads and Queues") {
                    path.append(MyPath.threadsAndQueues)
                }
                
                Button("Sync and Async") {
                    path.append(MyPath.syncAndAsync)
                }
                
                Button("Async properties and async let") {
                    path.append(MyPath.asyncPropertiesAndAsyncLet)
                }
                
                Button("Continuations") {
                    path.append(MyPath.continuations)
                }
                
                Button("Async Sequences") {
                    path.append(MyPath.asyncSequences)
                }
                
                Button("Async Streams") {
                    path.append(MyPath.asyncStreams)
                }
                
                Button("Tasks") {
                    path.append(MyPath.tasks)
                }
            }
            .navigationDestination(for: MyPath.self) { route in
                switch route {
                case .concurrency:
                    ConcurrencyView()
                case .threadsAndQueues:
                    ThreadsAndQueuesView()
                case .syncAndAsync:
                    SyncAndAsyncView()
                case .asyncPropertiesAndAsyncLet:
                    AsyncPropertiesAndAsyncLetView()
                case .continuations:
                    ContinuationsView()
                case .asyncSequences:
                    AsyncSequenceView()
                case .asyncStreams:
                    AsyncStreamView()
                case .tasks:
                    TasksView()
                }
            }
            .navigationTitle("Table of contents")
        }
    }
}

#Preview {
    TableOfContentsView()
}
