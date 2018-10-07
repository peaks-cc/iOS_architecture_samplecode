import UIKit
import Redux
import IGListKit
import GitHubAPI

final class NoticeSectionController: SectionController<NoticeElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: NoticeCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(NoticeCell.self, at: index)
        cell.titleLabel.text = element.title
        return cell
    }

    override func didSelectItem(at index: Int) {
        reduxStore.dispatch(
            RoutingState.Action.transitionActionCreator(
                transitionStyle: .push,
                from: viewController,
                to: element.routingPage
            )
        )
    }
}
