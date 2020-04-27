import Foundation
import UIKit

class HomeController:UIViewController{
    
    //MARK: - Properties
    
    
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavigationBar()
    }
    //MARK: - Handler
    
    @objc func handleMenuToggle(){
        print("Toggle Menu...")
    }
    
    func configureNavigationBar(){
        navigationController?.navigationBar.barTintColor = .darkGray
        navigationController?.navigationBar.barStyle = .black
        
        navigationItem.title = "Slide Menu"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu.png").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleMenuToggle))
    }
}
