import Foundation
import IGListKit

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Identifier
//////////////////////////////////////////////////////////////////////////////////////////
public struct Identifier: Hashable {
    private let identifierRaw: String

    init(_ identifier: String = UUID().uuidString) {
        self.identifierRaw = identifier
    }

    init<Subject>(_ instance: Subject) {
        self.init(String(describing: instance))
    }
}

extension Identifier: CustomStringConvertible {
    public var description: String {
        return self.identifierRaw
    }
}

public protocol Identifierable: Equatable {
    var identifier: Identifier { get }
}

extension Equatable where Self: Identifierable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Diffable
//////////////////////////////////////////////////////////////////////////////////////////
public protocol Diffable: Identifierable {
    var diffIdentifier: NSObjectProtocol { get }
}

extension Diffable {
    public var diffIdentifier: NSObjectProtocol {
        return self.identifier.description as NSObjectProtocol
    }
}

extension Collection where Element: Identifierable {
    internal var identifier: String {
        return self.map { $0.identifier.description }.joined(separator: "-")
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - DiffableWrapable
//////////////////////////////////////////////////////////////////////////////////////////
public protocol DiffableWrapable: ListDiffable { }

public final class DiffableWrap<T: Diffable>: NSObject, DiffableWrapable, ListDiffable {
    public let diffable: T

    public init(_ diffable: T) {
        self.diffable = diffable
    }

    // For ListDiffable
    public func diffIdentifier() -> NSObjectProtocol {
        return diffable.diffIdentifier
    }

    // For ListDiffable
    public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
        guard let object = object as? DiffableWrap<T> else { return false }
        return object.diffable == diffable
    }
}
