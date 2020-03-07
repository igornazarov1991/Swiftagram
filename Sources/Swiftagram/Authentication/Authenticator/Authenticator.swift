//
//  Authenticator.swift
//  Swiftagram
//
//  Created by Stefano Bertagno on 06/03/2020.
//

import Foundation

/// A `protocol` describing a form of fetching `Authentication.Response`s.
public protocol Authenticator {
    /// A `Storage` concrete type in which `Authentication.Response` are stored.
    associatedtype Storage: Swiftagram.Storage
    /// A `Storage` instance used to store `Authentication.Response`s.
    var storage: Storage { get }

    /// Return an `Authentication.Response` and store it in `storage`.
    /// - parameter onChange: A block providing a `Result<Authentication.Response, Error>`.
    /// - warning: Always call `Authentication.Response.store` with `storage` when receiving the `Authentication.Response` .
    /// - note: Using `TransientStorage` as `Storage` allows to disregard any storing mechanism.
    func authenticate(_ onChange: @escaping (Result<Authentication.Response, Error>) -> Void)
}

/// An `enum` describing `Authentictor` specific `Error`s.
public enum AuthenticatorError: Error {
    /// Checkpoint encountered.
    case checkpoint(Checkpoint?)
    /// Invalid code.
    case invalidCode
    /// Invalid cookies.
    case invalidCookies
    /// Invalid password.
    case invalidPassword
    /// Invalid response.
    case invalidResponse
    /// Invalid username.
    case invalidUsername
    /// Try again immediately.
    case retry
    /// Two factor challenge encountered
    case twoFactor(TwoFactor?)
}
