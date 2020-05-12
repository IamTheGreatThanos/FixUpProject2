import UIKit
import Foundation

class SettingsController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func callButton(sender: UIButton) {
        let phoneNumber = "+77005050908"
          if let url = URL(string: "tel://" + phoneNumber),
          UIApplication.shared.canOpenURL(url) {
          UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    }
    
   /* @IBAction func btnCall(_ sender:UIButton){
        func makePhoneCall(phoneNumber: String){
            let phoneNumber = "+7 708 999 99 99"
            if let phoneURL = NSURL(string: ("tel://" + phoneNumber)){

                    let alert = UIAlertController(title: ("Call " + phoneNumber + "?"), message: nil, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Call", style: .default, handler: { (action) in
                        UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
                    }))

                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                
            }
        }
    } */
    
    
    
    
    
   
    
    
    

    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
        self.present(viewController, animated: true)
    }
    @IBAction func ExitButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let domain = Bundle.main.bundleIdentifier!
        defaults.removePersistentDomain(forName: domain)
        defaults.synchronize()
    }
    
    @IBAction func firstSNButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "http://ontimeapp.club") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func secondSNButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "http://ontimeapp.club") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func thirdSNButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "http://ontimeapp.club") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
