import UIKit
import Foundation


class ChooseLocationController: UIViewController {
    
    @IBOutlet weak var mapView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.scrollView.isScrollEnabled = false
        
        if Reachability.isConnectedToNetwork() == true {
            let url = URL (string: "https://map.ontimeapp.club")
            let requestObj = URLRequest(url: url!)
            self.mapView.loadRequest(requestObj)
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func BackButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func DoneButtonTapped(_ sender: UIButton) {
        let lat = mapView.stringByEvaluatingJavaScript(from: "document.getElementById('lat').innerHTML.toString()") as! String
        let lng = mapView.stringByEvaluatingJavaScript(from: "document.getElementById('lng').innerHTML.toString()") as! String
        let address = mapView.stringByEvaluatingJavaScript(from: "document.getElementById('address').innerHTML.toString()") as! String
        
        
        let defaults = UserDefaults.standard
        defaults.set(address, forKey: "OrderAddress")
        defaults.set(lat, forKey: "OrderLat")
        defaults.set(lng, forKey: "OrderLng")
        
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
