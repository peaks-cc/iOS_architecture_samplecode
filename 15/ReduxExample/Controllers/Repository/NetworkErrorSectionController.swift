import UIKit
import RxSwift
import RxCocoa
import IGListKit
import Redux

final class NetworkErrorSectionController: SectionController<NetworkErrorElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: NetworkErrorCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(NetworkErrorCell.self, at: index)
        if let viewController = viewController as? RepositoryViewController {
            cell.retryButton.rx.tap
                .bind(to: Binder(viewController) { vc, _ in vc.request() })
                .disposed(by: cell.disposeBag)
        }
        return cell
    }
}
