import UIKit
import Redux
import IGListKit

final class LoadingSectionController: SectionController<LoadingElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: LoadingCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(LoadingCell.self, at: index)
        return cell
    }
}
