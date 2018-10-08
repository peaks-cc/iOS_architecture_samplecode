import UIKit
import Redux
import IGListKit
import GitHubAPI
import Kingfisher

final class PublicUserSectionController: SectionController<PublicUserElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: PublicUserCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(PublicUserCell.self, at: index)
        cell.avatorImageView.kf.setImage(with: element.avatarUrl)
        cell.namelabel.text = element.login
        return cell
    }
}
