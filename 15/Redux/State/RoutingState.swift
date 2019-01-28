import Foundation
import ReSwift
import API

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - State
//////////////////////////////////////////////////////////////////////////////////////////
public struct RoutingState: ReSwift.StateType {
    public struct TransitionState: Identifierable {
        public let identifier: Identifier = .init()
        public let transitionStyle: Routing.TransitionStyle
        public let routingPage: Routing.Page
    }
    public typealias ThisState = RoutingState
    public private(set) var transitionState: TransitionState?
    public private(set) var shouldShowServiceUnavailableTriger: ShouldTrigger?
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Action
//////////////////////////////////////////////////////////////////////////////////////////
extension RoutingState {
    public enum Action: ReSwift.Action {
        case completeTransition(
            transitionStyle: Routing.TransitionStyle,
            routingPage: Routing.Page
        )
        case shouldShowServiceUnavailable

        public static func transitionActionCreator(
            transitionStyle: Routing.TransitionStyle,
            from: UIViewController? = nil,
            to routingPage: Routing.Page,
            completion: ((_ vc: UIViewController) -> ())? = nil
        ) -> TransitionActionCreator {
            return { (reduxStore: RxReduxStore, transitioner: Transitionable) in
                let vc = transitioner.transition(
                    reduxStore,
                    transitionStyle: transitionStyle,
                    from: from,
                    to: routingPage
                )
                guard let vcNotOptional = vc else { return nil }
                completion?(vcNotOptional)
                return Action.completeTransition(
                    transitionStyle: transitionStyle,
                    routingPage: routingPage
                )
            }
        }
    }
}

//////////////////////////////////////////////////////////////////////////////////////////
// MARK: - Reducer
//////////////////////////////////////////////////////////////////////////////////////////
extension RoutingState {
    public static func reducer(action: ReSwift.Action, state: ThisState) -> ThisState {
        guard let action = action as? ThisState.Action else { return state }
        var state = state
        switch action {
        case .completeTransition(let transitionStyle, let routingPage):
            state.transitionState = TransitionState(
                                        transitionStyle: transitionStyle,
                                        routingPage: routingPage
                                    )
        case .shouldShowServiceUnavailable:
            state.shouldShowServiceUnavailableTriger = ShouldTrigger()
        }
        return state
    }
}
