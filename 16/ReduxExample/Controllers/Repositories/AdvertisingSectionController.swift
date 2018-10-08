import UIKit
import RxSwift
import RxCocoa
import IGListKit
import Redux

final class AdvertisingSectionController: SectionController<AdvertisingElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: AdvertisingCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(AdvertisingCell.self, at: index)
        cell.titleLabel.text = element.title
        return cell
    }

    override func didSelectItem(at index: Int) {
        reduxStore.dispatch(
            RoutingState.Action.transitionActionCreator(
                transitionStyle: .present,
                from: viewController,
                to: element.routingPage
            )
        )

        guard let viewController = viewController else { assertionFailureUnreachable(); return }
        viewController.rx.viewDidAppear
            .single()
            .bind(to: Binder(self) { me, _ in
                me.reduxStore.dispatch(me.element.hideAdvertisingAction)
            })
            .disposed(by: disposeBag)
    }
}
