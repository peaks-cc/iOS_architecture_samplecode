import UIKit
import Redux
import IGListKit

final class UnknownErrorSectionController: SectionController<UnknownErrorElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: UnknownErrorCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(UnknownErrorCell.self, at: index)
        return cell
    }
}
