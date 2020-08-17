//
//  Deprecations.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 17/08/2020.
//

import Foundation

public extension Endpoint.Media.Posts {
    /// All posts for user matching `identifier`.
    /// - parameters:
    ///     - identifier: A `String` holding reference to a valid user identifier.
    ///     - page: An optional `String` holding reference to a valid cursor. Defaults to `nil`.
    /// - warning: This method will be removed in `4.2.0`.
    @available(*, deprecated, renamed: "owned")
    static func by(_ identifier: String, startingAt page: String? = nil) -> Endpoint.Paginated<MediaCollection> {
        owned(by: identifier, startingAt: page)
    }
}

public extension Endpoint.Media.Stories {
    /// All available stories for user matching `identifier`.
    /// - parameter identifier: A `String` holding reference to a valid user identifier.
    /// - warning: This method will be removed in `4.2.0`.
    @available(*, deprecated, renamed: "owned")
    static func by(_ identifier: String) -> Endpoint.Disposable<TrayItemUnit> {
        owned(by: identifier)
    }
}
