import Foundation

public struct TitleElement: Diffable {
    public let identifier: Identifier
    public let title: String

    init(_ title: String) {
        self.title = title
        self.identifier = .init("\(String(describing: TitleElement.self))-\(title)")
    }

    public static func == (lhs: TitleElement, rhs: TitleElement) -> Bool {
        return lhs.title == rhs.title
    }
}
