import UIKit
import Foundation


class MainPageCustomer: UIViewController {
    
    @IBOutlet weak var mySpecialtyView: UIView!
    @IBOutlet weak var sideJobView: UIView!
    
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            mySpecialtyView.alpha = 1.0
            sideJobView.alpha = 0.0
        }
        else{
            
            mySpecialtyView.alpha = 0.0
            sideJobView.alpha = 1.0
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mySpecialtyView.alpha = 1.0
        sideJobView.alpha = 0.0
    }
}
