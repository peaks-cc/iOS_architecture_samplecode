import UIKit

class RepoListTableViewCell: UITableViewCell {

    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var starLabel: UILabel!

    func set(model: GitHubRepoModel) {
        nameLabel.text = model.name
        starLabel.text = "🌟 \(model.star)"
    }
}
