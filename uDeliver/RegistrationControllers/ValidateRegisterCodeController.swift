
import Foundation
import UIKit

class ValidateRegisterCodeController: ViewController, UITextFieldDelegate {
    @IBOutlet weak var ValidateCodeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        ValidateCodeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
        
        ValidateCodeTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        self.view.endEditing(true)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if textField == ValidateCodeTextField{
            if textField.text!.count == 5{
                ValidateCodeTextField.text = String(ValidateCodeTextField.text!.prefix(4))
            }
        }
    }
    
    
    
    @IBAction func ValidateButtonTapped(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            let url = URL(string: "https://back.fix-up.org/users/register/")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let phone = defaults.string(forKey: "Phone")
            let postString = "phone=" + phone! + "&code=" + ValidateCodeTextField.text!
            request.httpBody = postString.data(using: .utf8)
            //Get response
            let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                do{
                    if response != nil{
                        if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
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
                                    let alert = UIAlertController(title: "Извините", message: "Вы ввели неправильный код!", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
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
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
