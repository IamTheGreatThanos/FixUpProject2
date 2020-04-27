import UIKit

class PhoneController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var NickNameTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var logoIcon: UIImageView!
    @IBOutlet weak var logoText: UIImageView!
    
    var switcher = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.switcher == 1{
        
            UIView.animate(withDuration: 0.6, animations: {
                self.logoIcon.alpha = 1.0
                self.logoText.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant += 200
                self.bottomConstraint.constant -= 200
            })
            
            
            self.switcher = 0
        }
        
        
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.switcher == 0 {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.logoIcon.alpha = 0.0
                self.logoText.alpha = 0.0
            })
            
            UIView.animate(withDuration: 0.6, animations: {
                self.topConstraint.constant -= 200
                self.bottomConstraint.constant += 200
            })
            
            self.switcher = 1
        }
    }
    
    
    @IBAction func RegistButtonTapped(_ sender: UIButton) {
        let url = URL(string: "https://back.ontimeapp.club/users/phone/")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let postString = "phone=" + PhoneTextField.text! + "&nickname=" + NickNameTextField.text!
        request.httpBody = postString.data(using: .utf8)
        //Get response
        let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                let status = json["status"] as! String
                DispatchQueue.main.async {
                    if status == "ok"{
                        let defaults = UserDefaults.standard
                        defaults.set(self.PhoneTextField.text!, forKey: "Phone")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier :"ValidateRegisterCodeController")
                        self.present(viewController, animated: true)
                    }
                }
            }
            catch{
                print("Error")
            }
        })
        task.resume()
    }
}




@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}



@IBDesignable extension UIView {
    @IBInspectable var ViewCornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var ViewBorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var ViewBorderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.masksToBounds = false
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.masksToBounds = false
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.masksToBounds = false
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

//
//class Reachability {
//    class func isConnectedToNetwork() -> Bool {
//        var zeroAddress = sockaddr_in()
//        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
//        zeroAddress.sin_family = sa_family_t(AF_INET)
//        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
//            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
//                zeroSockAddress in SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)}
//        } ) else {
//            return false
//        }
//        var flags : SCNetworkReachabilityFlags = []
//        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {return false}
//        let isReachable = flags.contains(.reachable)
//        let needsConnection = flags.contains(.connectionRequired)
//        return (isReachable && !needsConnection)
//    } // isConnectedToNetwork
//} // class Reachabilit`
