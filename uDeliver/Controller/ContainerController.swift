import Foundation
import UIKit

class ContainerController:UIViewController{
    
    //MARK: - Properties
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHomeController()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    //MARK: - Handler
    
    func configureHomeController(){
        let homeController = HomeController()
        let controller  = UINavigationController(rootViewController: homeController)
        
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
        
    }
    
    func configureMenuController(){
        
    }
    
    
}
