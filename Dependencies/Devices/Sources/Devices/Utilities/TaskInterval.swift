//
//  File.swift
//  
//
//  Created by Kamil Wójcicki on 30/12/2023.
//

struct Every: AsyncSequence, AsyncIteratorProtocol {
    typealias Element = Int

    var duration: Duration
    private(set) var tick = 0

    init(_ duration: Duration) { self.duration = duration }
    func makeAsyncIterator() -> Self { self }

    mutating func next() async throws -> Element? {
        try await Task.sleep(for: duration)
        guard !Task.isCancelled else { return nil }

        tick += 1
        return tick
    }
}
