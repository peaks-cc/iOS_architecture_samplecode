import UIKit
import RxSwift
import RxCocoa
import IGListKit
import Redux

final class RepositorySectionController: SectionController<RepositoryElement> {
    let selectable: Bool

    init(_ dw: DiffableWrap<Element>, reduxStore: ReduxStoreType, disposeBag: RxSwift.DisposeBag, selectable: Bool) {
        self.selectable = selectable
        super.init(dw, reduxStore: reduxStore, disposeBag: disposeBag)
    }

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: RepositoryCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(RepositoryCell.self, at: index)
        cell.titleLabel.text = element.fullName
        cell.descriptionForRepository.text = element.descriptionForRepository
        cell.launguageLabel.text = element.launguage
        cell.issueCountLabel.text = element.openIssuesCount
        cell.forkCountLabel.text = element.forkCount
        cell.watchCountLabel.text = element.watchersCount
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
        guard selectable else { return }
        reduxStore.dispatch(
            RoutingState.Action.transitionActionCreator(
                transitionStyle: .push,
                from: viewController,
                to: element.routingPage
            )
        )
    }
}
