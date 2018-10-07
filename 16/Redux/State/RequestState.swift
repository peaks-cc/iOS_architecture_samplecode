import Foundation
import ReSwift
import API

public enum ConnectionType {
    case none
    case initialRequest
    case refreshReload
    case forceReload // Show loading
    case implicitlyReload // Hide loading

    var connectingState: ConnectingState {
        switch self {
        case .none: return .none
        case .initialRequest: return .initialRequesting
        case .refreshReload: return .refreshReloading
        case .forceReload: return .forceReloading
        case .implicitlyReload: return .implicitlyReloading
        }
    }
}
public enum ConnectingState {
    case none
    case initialRequesting
    case refreshReloading
    case forceReloading
    case implicitlyReloading

    var connectionType: ConnectionType {
        switch self {
        case .none: return .none
        case .initialRequesting: return .initialRequest
        case .refreshReloading: return .refreshReload
        case .forceReloading: return .forceReload
        case .implicitlyReloading: return .implicitlyReload
        }
    }
}

public struct RequestState<Response>: ReSwift.StateType {
    public let response: Response?
    public let connecting: Bool
    public let error: APIDomainError?
    public let connectionType: ConnectionType

    public var initialRequesting: Bool { return connecting && connectionType == .initialRequest }
    public var refreshing: Bool { return connecting && connectionType == .refreshReload }
    public var forceReloading: Bool { return connecting && connectionType == .forceReload }
    public var implicitlyReloading: Bool { return connecting && connectionType == .implicitlyReload }
    public var hasResponse: Bool { return response != nil }

    // MARK: - Initial variable
    init() {
        self.response = nil
        self.connecting = false
        self.connectionType = .none
        self.error = nil
    }

    // MARK: - Request strat
    init(requestState: RequestState, connectionType: ConnectionType) {
        self.response = requestState.response
        self.connecting = true
        self.connectionType = connectionType
        self.error = nil
    }

    // MARK: - Request strat
    init(requestState: RequestState, connectingState: ConnectingState) {
        self.response = requestState.response
        self.connecting = true
        self.connectionType = connectingState.connectionType
        self.error = nil
    }

    // MARK: - Request success
    init(requestState: RequestState, response: Response) {
        self.response = response
        self.connecting = false
        self.connectionType = requestState.connectionType
        self.error = nil
    }

    // MARK: - Request failed
    init(requestState: RequestState, error: APIDomainError) {
        switch requestState.connectionType {
        case .none, .initialRequest:
            self.response = nil
        case .forceReload, .implicitlyReload, .refreshReload:
            self.response = requestState.response
        }
        self.connecting = false
        self.connectionType = requestState.connectionType
        self.error = error
    }
}
