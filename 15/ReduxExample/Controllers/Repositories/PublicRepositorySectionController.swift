import UIKit
import Redux
import RxSwift
import RxCocoa
import IGListKit
import GitHubAPI

final class PublicRepositorySectionController: SectionController<PublicRepositoryElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: PublicRepositoryCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(PublicRepositoryCell.self, at: index)
        cell.titleLabel.text = element.fullName
        cell.descriptionForRepositoryLabel.text = element.descriptionForRepository
        cell.favoriteButton.isSelected = element.isFavorite
        cell.favoriteButton.rx.tap
            .bind(to: Binder(self) { me, _ in me.toggleFavorite() })
            .disposed(by: cell.disposeBag)
        return cell
    }

    func toggleFavorite() {
        if element.isFavorite {
            reduxStore.dispatch(
                FavoritesState.Action.unfavoriteActionCreator(repositoryId: element.id)
            )
        } else {
            reduxStore.dispatch(
                FavoritesState.Action.favoriteActionCreator(favorite: element.favorite)
            )
        }
        reduxStore.dispatch(FavoritesState.Action.loadFavoritesActionCreator())
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
