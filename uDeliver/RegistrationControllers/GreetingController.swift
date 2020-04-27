import Foundation
import UIKit

class GreetingController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var isRegister = ""
    
    var contentWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.contentSize.height = 1.0
        
        scrollView.delegate = self
        
        for image in 1...3{
            let imageToDisplay = UIImage(named: "Delivery-\(image).png")
            let imageView = UIImageView(image: imageToDisplay)
            
            scrollView.addSubview(imageView)
            
            let xCoordinate = view.frame.midX + view.frame.width * CGFloat(image)
            
            imageView.frame = CGRect(x: contentWidth + 50, y: 100, width: view.frame.width - 100, height: view.frame.height/2 - 60)
            
            contentWidth += view.frame.width
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / CGFloat(375))
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
           scrollView.contentOffset.y = 0
        }
    }
    
    
    @IBAction func NextButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "isRegister") != nil{
            self.isRegister = defaults.string(forKey: "isRegister")!
        }
        
        if ( isRegister == "true") {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
            self.present(viewController, animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"PhoneController")
            self.present(viewController, animated: true)
        }
        
        
    }
    
}
