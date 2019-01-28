import UIKit
import RxSwift
import IGListKit
import Redux

final class ReadmeSectionController: SectionController<ReadmeElement> {
    private var height: CGFloat = 120

    override func sizeForItem(at index: Int) -> CGSize {
        return CGSize(width: containerSize.width, height: height)
    }

    override func cellForItem(at index: Int) -> UICollectionViewCell {
        let cell = dequeueReusableCell(ReadmeCell.self, at: index)
        cell.markdownView.load(markdown: element.readme, enableImage: true)

        if element.isRenderedMarkdown {
            cell.loadingView.isHidden = true
            cell.markdownView.isHidden = false
        } else {
            cell.loadingView.isHidden = false
            cell.markdownView.isHidden = true
        }

        cell.markdownView.onRendered = { [weak self] height in
            self?.height = height + ReadmeCell.Metric.Margin
            self?.renderedMarkdown() // To force reload
        }
        // height = cell.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize).height
        return cell
    }

    func renderedMarkdown() {
        reduxStore.dispatch(RepositoryState.Action.renderedMarkdown)
    }
}
