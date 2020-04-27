import UIKit
import Foundation


class ChoosingPosition: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func SpecialistButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SpecialtyController")
        self.present(viewController, animated: true)
    }
    
    @IBAction func CustomerButton(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
        self.present(viewController, animated: true)
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isCourier")
    }
}
