import UIKit
import Foundation

class WelcomeController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isGreated") != nil{
            let isGreated = defaults.bool(forKey: "isGreated")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
            self.present(viewController, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"GreetingController")
            self.present(viewController, animated: true)
            
            defaults.set("True", forKey: "isGreated")
        }
    }
}
