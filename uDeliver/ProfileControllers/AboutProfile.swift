import UIKit

class AboutProfile: UIViewController {
    
    @IBOutlet weak var aboutInfo: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        let asUserInfo = defaults.bool(forKey: "asUserInfo")
        if asUserInfo == true{
            let userInfoId = defaults.string(forKey: "userInfoID")!
            let token = defaults.string(forKey: "Token")
            let url = URL(string: "https://back.fix-up.org/users/" + userInfoId)!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            //Get response
            let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                do{
                    if response != nil{
                        if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                            DispatchQueue.main.async {
                                if (json["about"] as? String != nil){
                                    self.aboutInfo.text = (json["about"] as! String)
                                }
                                else{
                                    self.aboutInfo.text = "Информация"
                                }
                                print("OK <About controller as User Info>")
                            }
                        }
                        else{
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с сервером…", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                                self.present(alert, animated: true)
                            }
                        }
                    }
                    else{
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с сервером…", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                            self.present(alert, animated: true)
                        }
                    }
                }
                catch{
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с сервером…", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
                        self.present(alert, animated: true)
                    }
                }
            })
            task.resume()
        }
        else{
            if defaults.string(forKey: "About") != nil{
               aboutInfo.textColor = UIColor.black
               aboutInfo.text = defaults.string(forKey: "About")
           }
        }
    }
}
