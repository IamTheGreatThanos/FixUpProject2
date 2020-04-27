import UIKit

class SpecialtyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var SpecialtyName: UILabel!
    @IBOutlet weak var SpecialtyIcon: UIImageView!
    @IBOutlet weak var SpecialtyInto: UILabel!
    @IBOutlet weak var SpecialtyView: DesignOfViewWithCR!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
