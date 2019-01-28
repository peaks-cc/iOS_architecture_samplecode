import Foundation
import IGListKit

public class DataSourceElements: Identifierable {
    public private(set) var elements: [ListDiffable]
    public var hasElements: Bool { return elements.isEmpty == false }
    public let animated: Bool
    public let identifier: Identifier = .init()

    public convenience init() {
        self.init(animated: false)
    }

    public init(elements: [ListDiffable] = [], animated: Bool) {
        self.elements = elements
        self.animated = animated
    }

    public func append<T: Diffable>(_ diffable: T) {
        elements.append(DiffableWrap(diffable))
    }
}
