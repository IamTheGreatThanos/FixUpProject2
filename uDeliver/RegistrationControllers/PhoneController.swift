import UIKit


class PhoneController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var PhoneTextField: UITextField!
    @IBOutlet weak var NickNameTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var logoIcon: UIImageView!

    
    var switcher = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isCourier")
        PhoneTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        addDoneButtonOnKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.switcher == 1{
        
            UIView.animate(withDuration: 0.6, animations: {
                self.logoIcon.alpha = 1.0
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
            })
            
            UIView.animate(withDuration: 0.6, animations: {
                self.topConstraint.constant -= 200
                self.bottomConstraint.constant += 200
            })
            
            self.switcher = 1
        }
        if textField == PhoneTextField{
            if self.PhoneTextField.text!.count < 6{
                self.PhoneTextField.text = "+7 ("
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == PhoneTextField{
            if PhoneTextField.text?.count == 3{
                PhoneTextField.text = "+7 ("
            }
            
            if PhoneTextField.text?.count == 7{
                PhoneTextField.text! += ") "
            }
            if PhoneTextField.text?.count == 8{
                PhoneTextField.text! = String(PhoneTextField.text!.prefix(6))
            }
            
            if PhoneTextField.text?.count == 12{
                PhoneTextField.text! += "  "
            }
            if PhoneTextField.text?.count == 13{
                PhoneTextField.text! = String(PhoneTextField.text!.prefix(11))
            }
            if PhoneTextField.text?.count == 16{
                PhoneTextField.text! += "  "
            }
            if PhoneTextField.text?.count == 17{
                PhoneTextField.text! = String(PhoneTextField.text!.prefix(15))
            }
            if PhoneTextField.text?.count == 21{
                PhoneTextField.text! = String(PhoneTextField.text!.prefix(20))
            }
        }
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        PhoneTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        if self.switcher == 1{
            UIView.animate(withDuration: 0.6, animations: {
                self.logoIcon.alpha = 1.0
            })
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant += 200
                self.bottomConstraint.constant -= 200
            })
            self.switcher = 0
        }
        self.view.endEditing(true)
    }
    
    
    @IBAction func RegistButtonTapped(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            if PhoneTextField.text?.count == 20 && NickNameTextField.text?.count != 0 && NickNameTextField.text!.count > 1 {
                let url = URL(string: "https://back.fix-up.org/users/phone/")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                let phoneNumber = String(PhoneTextField.text!.prefix(2)) + String(PhoneTextField.text!.prefix(7).suffix(3)) + String(PhoneTextField.text!.prefix(12).suffix(3)) + String(PhoneTextField.text!.prefix(16).suffix(2)) + String(PhoneTextField.text!.prefix(20).suffix(2))
                let postString = "phone=" + phoneNumber + "&nickname=" + NickNameTextField.text!
                request.httpBody = postString.data(using: .utf8)
                //Get response
                let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                    do{
                        if response != nil{
                            if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                                let status = json["status"] as! String
                                DispatchQueue.main.async {
                                    if status == "ok"{
                                        let defaults = UserDefaults.standard
                                        defaults.set(phoneNumber, forKey: "Phone")
                                        defaults.set(self.NickNameTextField.text!, forKey: "MyName")
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let viewController = storyboard.instantiateViewController(withIdentifier :"ValidateRegisterCodeController")
                                        self.present(viewController, animated: true)
                                    }
                                }
                            }
                            else{
                                let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с сервером…", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                                self.present(alert, animated: true)
                            }
                        }
                        else{
                            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с сервером…", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                    catch{
                        let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с сервером…", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                })
                task.resume()
            }
            else{
                let alert = UIAlertController(title: "Извините", message: "Введите полную информацию!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                self.present(alert, animated: true)
            }
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
