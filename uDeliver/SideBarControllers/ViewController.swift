import Foundation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        
        let url = URL (string: "https://2gis.kz/almaty")
        let requestObj = URLRequest(url: url!)
        DispatchQueue.main.async {
            self.webView.loadRequest(requestObj)
        }

    }
    
    func sideMenus(){
        if revealViewController() != nil{
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController()?.rearViewRevealWidth = 300
            
//            revealViewController()?.rightViewRevealWidth = 160
//
//            alertButton.target = revealViewController()
//            alertButton.action = #selector(SWRevealViewController.rightRevealToggle(_:))
            
            view.addGestureRecognizer((self.revealViewController()?.panGestureRecognizer())!)
            
        }
    }
}
