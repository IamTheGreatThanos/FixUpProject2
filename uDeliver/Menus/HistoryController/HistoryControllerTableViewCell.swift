import UIKit

class HistoryControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var FromLabel: UILabel!
    @IBOutlet weak var ToLabel: UILabel!
    @IBOutlet weak var CommentLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var DistancePriceLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
