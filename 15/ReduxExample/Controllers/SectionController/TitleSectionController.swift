import UIKit
import Redux
import IGListKit

final class TitleSectionController: SectionController<TitleElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: TitleCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(TitleCell.self, at: index)
        cell.titleLabel.text = element.title
        return cell
    }
}
