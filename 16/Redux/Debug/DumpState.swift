import Foundation

func dumpState<T>(_ value: T) -> String {
    var stream: String = .init()
    dump(value, to: &stream)
    return stream
}
