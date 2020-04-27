import UIKit
import Foundation

class SettingsController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
        self.present(viewController, animated: true)
    }
    @IBAction func ExitButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
                   let domain = Bundle.main.bundleIdentifier!
                   defaults.removePersistentDomain(forName: domain)
                   defaults.synchronize()
    }
}
