import UIKit
import Redux
import IGListKit

final class SpaceBoxSectionController: ListSectionController {
    override func sizeForItem(at index: Int) -> CGSize {
        let width = collectionContext!.containerSize.width
        return CGSize(width: width, height: 44)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}
