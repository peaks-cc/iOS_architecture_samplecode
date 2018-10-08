import Foundation
import KeychainAccess

public protocol KeychainStorable {
    func save(key: String, value: String)
    func load(key: String) -> String?
    func delete(key: String)
}

public struct KeychainStore: KeychainStorable {
    private let keychain: Keychain

    public init(_ keychainServiceeName: String) {
        self.keychain = Keychain(service: keychainServiceeName)
    }

    public func save(key: String, value: String) {
        keychain[key] = value
    }

    public func load(key: String) -> String? {
        return keychain[key]
    }

    public func delete(key: String) {
        return keychain[key] = nil
    }
}
