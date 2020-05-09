import Foundation
import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var SpecialtyMainContainer: UIView!
    @IBOutlet weak var CustomerMainContainer: UIView!
    @IBOutlet weak var refreshButtonOutlet: UIBarButtonItem!
    
    var navBarTitle = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()

        let defaults = UserDefaults.standard
        let value = defaults.bool(forKey: "isCourier")
        
        if value == false{
            self.navBarTitle = "FIXUP"
            self.SpecialtyMainContainer?.alpha = 0.0
            self.CustomerMainContainer?.alpha = 1.0
            self.refreshButtonOutlet.width = 0.01
        }
        else{
            self.navBarTitle = "Список заказов"
            self.SpecialtyMainContainer.alpha = 1.0
            self.CustomerMainContainer.alpha = 0.0
            self.refreshButtonOutlet.width = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        nav?.topItem?.title = self.navBarTitle
        nav?.backgroundColor = UIColor.white
        
    }
    
    func sideMenus(){
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = 300
//            self.disabledView.alpha = 1.0
            
            
//            revealViewController()?.rightViewRevealWidth = 160
//
//            alertButton.target = revealViewController()
//            alertButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
            
        }
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: UIBarButtonItem) {
        SpecialistMySpecialtyTableView().refresh()
        SpecialistSideJobTableView().refresh()
    }
    
    
}
