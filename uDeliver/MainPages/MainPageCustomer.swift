import UIKit
import Foundation


class MainPageCustomer: UIViewController {
    
    @IBOutlet weak var mySpecialtyView: UIView!
    @IBOutlet weak var sideJobView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySpecialtyView.alpha = 1.0
        sideJobView.alpha = 0.0
    }
}
