import UIKit
import Foundation

class MainPageSpecialty: UIViewController{
    
    @IBOutlet weak var MySpecialtyView: UIView!
    @IBOutlet weak var SideJobView: UIView!
    @IBOutlet weak var segmentControlOutlet: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControlOutlet.alpha = 0.0
        MySpecialtyView.alpha = 1.0
        SideJobView.alpha = 0.0
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey:"OrderAddress")
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
