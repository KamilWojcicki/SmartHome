//
//  Every.swift
//  
//
//  Created by Kamil Wójcicki on 30/12/2023.
//

public struct Every: AsyncSequence, AsyncIteratorProtocol {
    public typealias Element = Int

    var duration: Duration
    private(set) var tick = 0

    public init(_ duration: Duration) { self.duration = duration }
    public func makeAsyncIterator() -> Self { self }

    public mutating func next() async throws -> Element? {
        try await Task.sleep(for: duration)
        guard !Task.isCancelled else { return nil }

        tick += 1
        return tick
    }
}
