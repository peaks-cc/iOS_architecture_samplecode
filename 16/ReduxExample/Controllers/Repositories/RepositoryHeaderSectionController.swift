import UIKit
import Redux
import IGListKit
import GitHubAPI

final class RepositoryHeaderSectionController: SectionController<RepositoryHeaderElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: RepositoryHeaderCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return dequeueReusableCell(RepositoryHeaderCell.self, at: index)
    }

    override func didSelectItem(at index: Int) {
        reduxStore.dispatch(
            RoutingState.Action.transitionActionCreator(
                transitionStyle: .present,
                from: viewController,
                to: element.routingPage
            )
        )
    }
}
