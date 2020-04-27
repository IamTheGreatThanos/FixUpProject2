import Foundation
import UIKit
import MapKit
import CoreLocation

class GreetingController: UIViewController, UIScrollViewDelegate, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var GreetingLabel: UILabel!
    
    var GreetingText = ["Срочно ищите специалиста?", "Долго ждете нового заказчика?", "FixUp предлагает наиболее удобные и близкие варианты!", "FixUp объединяет заказчиков и специалистов!"]
    
    var currentPageInd = 0
    
    var isRegister = ""
    
    var contentWidth: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GreetingLabel.text = GreetingText[0]
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        scrollView.contentSize.height = 1.0
        pageControl.isEnabled = false
        scrollView.delegate = self
        
        for image in 1...4{
            let imageToDisplay = UIImage(named: "Delivery-\(image).png")
            let imageView = UIImageView(image: imageToDisplay)
            
            scrollView.addSubview(imageView)
            
            let xCoordinate = view.frame.midX + view.frame.width * CGFloat(image)
            
            imageView.frame = CGRect(x: contentWidth, y: 100, width: view.frame.width, height: view.frame.height/2)
            
            contentWidth += view.frame.width
        }
        
        scrollView.contentSize = CGSize(width: contentWidth, height: view.frame.height)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        currentPageInd = Int(scrollView.contentOffset.x / CGFloat(375))
        pageControl.currentPage = currentPageInd
        UIView.animate(withDuration: 1, animations: {
            self.GreetingLabel.alpha = 0.0
            self.GreetingLabel.text = self.GreetingText[self.currentPageInd]
        })
        UIView.animate(withDuration: 0.5, animations: {
            self.GreetingLabel.alpha = 1.0
        })
        if scrollView.contentOffset.y > 0 || scrollView.contentOffset.y < 0 {
           scrollView.contentOffset.y = 0
        }
    }
    
    
    @IBAction func pageControlChangeValue(_ sender: UIPageControl) {
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let defaults = UserDefaults.standard
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        defaults.set(String(locValue.latitude), forKey: "MyLat")
        defaults.set(String(locValue.longitude), forKey: "MyLong")
        
//        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)

//        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, _) -> Void in
//
//            placemarks?.forEach { (placemark) in
//
//                if let city = placemark.locality { print(city) } // Prints "New York"
//            }
//        })
//        let userLocation = locations.last
//        let viewRegion = MKCoordinateRegion(center: (userLocation?.coordinate)!, latitudinalMeters: 600, longitudinalMeters: 600)
//        self.map.setRegion(viewRegion,animated: true)
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
            let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
            self.present(viewController, animated: true)
        }
    }
    
}
