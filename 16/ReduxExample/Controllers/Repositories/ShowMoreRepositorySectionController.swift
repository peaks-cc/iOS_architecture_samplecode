import UIKit
import Redux
import IGListKit
import GitHubAPI

final class ShowMoreRepositorySectionController: SectionController<ShowMoreRepositoryElement> {
    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: ShowMoreRepositoryCell.Metric.Height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(ShowMoreRepositoryCell.self, at: index)
        cell.moreButton.addTarget(self, action: #selector(moreButton), for: .touchUpInside)
        return cell
    }

    @objc func moreButton(_ sender: UIButton) {
        reduxStore.dispatch(element.repositoryType.action)
    }
}
