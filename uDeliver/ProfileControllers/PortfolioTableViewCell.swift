import UIKit
import Foundation

class PortfolioTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    @IBOutlet weak var portfolioImage: UIImageView!
    
    var buttonAction: ((Any) -> Void)?
    
    
    @IBAction func deleteButton(_ sender: UIButton) {
        self.buttonAction?(sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
