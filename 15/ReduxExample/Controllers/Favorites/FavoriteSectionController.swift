import UIKit
import RxSwift
import RxCocoa
import IGListKit
import Redux

final class FavoriteSectionController: SectionController<FavoriteElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: PublicRepositoryCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(PublicRepositoryCell.self, at: index)
        cell.titleLabel.text = element.name
        cell.descriptionForRepositoryLabel.text = element.descriptionForRepository
        cell.favoriteButton.isSelected = true
        cell.favoriteButton.rx.tap
            .bind(to: Binder(self) { me, _ in me.unfavorite() })
            .disposed(by: cell.disposeBag)
        return cell
    }

    func unfavorite() {
        reduxStore.dispatch(
            FavoritesState.Action.unfavoriteActionCreator(repositoryId: element.id)
        )
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
