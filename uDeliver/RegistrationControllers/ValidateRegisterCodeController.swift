
import Foundation
import UIKit

class ValidateRegisterCodeController: ViewController, UITextFieldDelegate {
    @IBOutlet weak var ValidateCodeTextField: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoIcon: UIImageView!
    @IBOutlet weak var logoText: UIImageView!
    
    var switcher = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
    
    @IBAction func ValidateButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let url = URL(string: "https://back.ontimeapp.club/users/register/")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let phone = defaults.string(forKey: "Phone")
        let postString = "phone=" + phone! + "&code=" + ValidateCodeTextField.text!
        request.httpBody = postString.data(using: .utf8)
        //Get response
        let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
            do{
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
//                print(json)
//                print("<------>")
                let status = json["status"] as! String
                DispatchQueue.main.async {
                    if status == "ok" {
                        let uid = json["uid"]
                        let token = json["key"] as! String
                        defaults.set(uid, forKey: "UID")
                        defaults.set(token, forKey: "Token")
                        defaults.set("true", forKey: "isRegister")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier :"ChoosingPosition")
                        self.present(viewController, animated: true)
                    }
                    else{
                        let alert = UIAlertController(title: "Sorry", message: "Your code is incorrect", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
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
