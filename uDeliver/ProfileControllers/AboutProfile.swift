import UIKit

class AboutProfile: UIViewController {
    
    @IBOutlet weak var aboutInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        let asUserInfo = defaults.bool(forKey: "asUserInfo")
        if asUserInfo == true{
            let userInfoId = defaults.string(forKey: "userInfoID")!
            let token = defaults.string(forKey: "Token")
            let url = URL(string: "https://back.ontimeapp.club/users/" + userInfoId)!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "GET"
            //Get response
            let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                do{
                    if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                        DispatchQueue.main.async {
                            self.aboutInfo.text = (json["about"] as! String)
                            print("OK <About controller as User Info>")
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
            if defaults.string(forKey: "About") != nil{
               aboutInfo.text = defaults.string(forKey: "About")
           }
        }
    }
}
