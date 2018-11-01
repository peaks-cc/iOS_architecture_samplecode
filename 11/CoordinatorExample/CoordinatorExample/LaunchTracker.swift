import UIKit
import CoreSpotlight
import UserNotifications

struct LaunchTracker {
    enum Event: Equatable {
        case normal
        case localNotification(identifier: String)
        case remoteNotification(identifier: String)
        case deepLink(url: URL)
        case spotlight(resultIdentifier: String)
        case spotlight(query: String)
        case widget(identifier: String)
        case homeScreen(type: String)

        static func create(launchType: AppCoordinator.LaunchType) -> Event? {
            switch launchType {
            case .normal:
                return .normal
            case .notification(let request):
                if request.trigger is UNPushNotificationTrigger {
                    return .remoteNotification(identifier: request.identifier)
                } else if request.trigger is UNTimeIntervalNotificationTrigger {
                    return .localNotification(identifier: request.identifier)
                }
            case .userActivity(let activity):
                switch activity.activityType {
                case NSUserActivityTypeBrowsingWeb:
                    guard let url = activity.webpageURL else {
                        fatalError("unreachable")
                    }
                    return .deepLink(url: url)
                case CSSearchableItemActionType:
                    guard let identifier = activity.userInfo?[CSSearchableItemActivityIdentifier] as? String else {
                        fatalError("unreachable")
                    }
                    return .spotlight(resultIdentifier: identifier)
                case CSQueryContinuationActionType:
                    guard let query = activity.userInfo?[CSSearchQueryString] as? String else {
                        fatalError("unreachable")
                    }
                    return .spotlight(query: query)
                default:
                    return nil // untracked in this app
                }
            case .openURL(let url):
                if url.scheme == "coordinator-example-widget" {
                    let identifier = url.lastPathComponent
                    return .widget(identifier: identifier)
                } else if url.scheme == "adjustSchemeExample" {
                    //TODO: replace your adjust url scheme
                    return .deepLink(url: url)
                } else if url.scheme == "FirebaseDynamicLinksExmaple" {
                    //TODO: handle your FDL
                    return .deepLink(url: url)
                } else {
                    return nil // untracked any other urls
                }
            case .shortcutItem(let item):
                return .homeScreen(type: item.type)
            }
            return nil
        }
    }

    static func track(launchType: AppCoordinator.LaunchType) {
        guard let event = Event.create(launchType: launchType) else {
            return
        }
        send(event: event)
    }

    private static func send(event: Event) {
        // TODO: send event to your analytics
    }
}
