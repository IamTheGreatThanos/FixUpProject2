import UIKit
import Foundation

class ProfileController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var thirdView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let isRegisterAsSpecialist = defaults.bool(forKey: "isRegisterAsSpecialist")
        if isRegisterAsSpecialist == false{
            moreButton.isHidden = true
        }
        firstView.alpha = 1.0
        secondView.alpha = 0.0
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            firstView.alpha = 1.0
            secondView.alpha = 0.0
            thirdView.alpha = 0.0
        }
        else if (sender.selectedSegmentIndex == 1){
            firstView.alpha = 0.0
            secondView.alpha = 1.0
            thirdView.alpha = 0.0
        }
        else{
            firstView.alpha = 0.0
            secondView.alpha = 0.0
            thirdView.alpha = 1.0
        }
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MoreInformationController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
    }
    
    
    @IBAction func EditButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"EditProfileController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
    }
    
}
