import Foundation
import API

public enum AppDomainError {
    case apiDomainError(error: APIDomainError)
    case unreachable
}
