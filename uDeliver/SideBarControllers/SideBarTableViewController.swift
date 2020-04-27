import UIKit
import Foundation


class SideBarTableViewController: UITableViewController {
    
    
    @IBOutlet weak var BeCourierOutlet: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let value = defaults.bool(forKey: "isCourier")
        
        if (value == true){
            BeCourierOutlet.setOn(true, animated: false)
        }
        
    }
    
    @IBAction func BeCourier(_ sender: UISwitch) {
        let value = sender.isOn
        if (value == true){
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "isCourier")
        }
        else{
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isCourier")
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if (indexPath.row == 1) {
                let defaults = UserDefaults.standard
                let value = defaults.bool(forKey: "isCourier")
                
                if (value == true){
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier :"CourierProfileEditingController")
                    self.present(viewController, animated: true)
                }
                else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier :"ProfileEditingController")
                    self.present(viewController, animated: true)
                }
            }
        }
}
