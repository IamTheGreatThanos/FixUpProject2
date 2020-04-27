import UIKit
import Foundation

class MainPageSpecialty: UIViewController{
    
    @IBOutlet weak var MySpecialtyView: UIView!
    @IBOutlet weak var SideJobView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MySpecialtyView.alpha = 1.0
        SideJobView.alpha = 0.0
        
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            MySpecialtyView.alpha = 1.0
            SideJobView.alpha = 0.0
        }
        else{
            
            MySpecialtyView.alpha = 0.0
            SideJobView.alpha = 1.0
        }
    }
    
}
