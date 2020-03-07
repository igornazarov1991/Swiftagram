//
//  Requester.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 06/03/2020.
//

import Foundation

/// A `class` used to perform `Request`s.
public final class Requester {
    /// A `struct` holding reference to a specific `Request`.
    public struct Task: Hashable {
        /// A `tuple` holding reference to responses.
        public typealias Response<Type> = (data: Type, response: HTTPURLResponse?)

        /// A `String` representing the current `hashValue`.
        internal var identifier: String = UUID().uuidString
        /// A `Date` indicating when the `Request` was first resumed.
        public internal(set) var startedAt: Date = .init()
        /// An associated `Request`.
        public internal(set) var request: Request

        // MARK: Lifecycle
        /// Cancel the current request.
        public func cancel() {
            request.task?.cancel()
            request.requester?.requests.remove(self)
        }

        // MARK: Hashable
        public func hash(into hasher: inout Hasher) { hasher.combine(identifier) }
        public static func ==(lhs: Task, rhs: Task) -> Bool { lhs.identifier == rhs.identifier }
    }

    /// A shared instance of `Requester` using `URLSession.shared`.
    public static let `default` = Requester()
    /// A `URLSessionConfiguration`.
    public var configuration: URLSessionConfiguration
    /// A `URLSession` to use for requests. Defaults to `.shared`.
    public var session: URLSession { URLSession(configuration: configuration) }
    /// A set of `Task`s currently scheduled or undergoing fetching.
    private var requests: Set<Task> = [] {
        didSet {
            let inserted = requests.subtracting(oldValue)
            // Actually fetch `inserted` tasks.
            inserted.forEach { task in
                task.request.fetch(using: session) { [weak self] in
                    // Remove the task once it's done.
                    self?.requests.remove(task)
                }
            }
        }
    }

    // MARK: Lifecycle
    /// Deinit.
    deinit {
        /// Cancell all tasks.
        requests = []
    }
    /// Init.
    public init(configuration: URLSessionConfiguration = .default) { self.configuration = configuration }

    // MARK: Schedule
    @discardableResult
    /// Schedule a new `request`.
    /// - parameter request: A valid `Request`.
    internal func schedule(_ request: Request) -> Task {
        return requests.insert(Task(request: request)).memberAfterInsert
    }
}
