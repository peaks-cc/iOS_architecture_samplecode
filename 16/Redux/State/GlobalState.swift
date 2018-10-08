import Foundation
import ReSwift
import API

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - State
//////////////////////////////////////////////////////////////////////////////////////////
public struct GlobalState: ReSwift.StateType {
    public typealias ThisState = GlobalState
    public enum AppTab {
        case main
        case favorites
        case setting

        public func isSelected(with appTab: AppTab) -> Bool {
            return self == appTab
        }
    }
    public enum ApplicationState {
        case willResignActive
        case didEnterBackground
        case willEnterForeground
        case didBecomeActive
        case willTerminate
    }
    private var appState: ApplicationState = .willTerminate
    private var didBecomeActiveTrigger: ShouldTrigger?
    public private(set) var selectedAppTab: AppTab = .main
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
extension GlobalState {
    public enum Action: ReSwift.Action {
        case changeAppTab(appTab: AppTab)
        case changeApplicationState(appState: ApplicationState)
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Reducer
//////////////////////////////////////////////////////////////////////////////////////////
extension GlobalState {
    public static func reducer(action: ReSwift.Action, state: ThisState) -> ThisState {
        guard let action = action as? ThisState.Action else { return state }
        var state = state
        switch action {
        case .changeAppTab(let appTab):
            state.selectedAppTab = appTab
        case .changeApplicationState(let appState):
            state.appState = appState
            switch appState {
            case .didBecomeActive:
                state.didBecomeActiveTrigger = ShouldTrigger()
            default: break // Do nothing
            }
        }
        return state
    }
}
