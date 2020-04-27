import UIKit

class FinishController: UIViewController {
    
    
    @IBOutlet weak var dislikeButtonOutlet: UIButton!
    @IBOutlet weak var likeButtonOutlet: UIButton!
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        
        nameLabel.text = defaults.string(forKey: "CurrentName")
        specialtyLabel.text = defaults.string(forKey: "CurrentSpecialty")
        let url = defaults.string(forKey: "CurrentAvatar")!
        let loadUrl = URL(string: "https://back.ontimeapp.club/" + url)!
        self.avaImage.load(url: loadUrl)
        
        
    }
    
    @IBAction func mainPageButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
        self.present(viewController, animated: true)
    }
    
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        likeButtonOutlet.layer.borderWidth = 3
        likeButtonOutlet.layer.borderColor = UIColor.green.cgColor
        likeButtonOutlet.layer.cornerRadius = 40
        
        dislikeButtonOutlet.layer.borderWidth = 0
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            let worker_id = defaults.string(forKey: "CurrentWorkerId")!
            let token = defaults.string(forKey: "Token")
            let url = URL(string: "https://back.ontimeapp.club/maps/rating/")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let postString = "id=" + worker_id + "&action=like"
            request.httpBody = postString.data(using: .utf8)
            //Get response
            let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                do{
                    if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                        let status = json["status"] as! String
                        DispatchQueue.main.async {
                            if status == "ok"{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
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
    @IBAction func dislikeButtonTapped(_ sender: UIButton) {
        likeButtonOutlet.layer.borderWidth = 0
        
        dislikeButtonOutlet.layer.cornerRadius = 40
        dislikeButtonOutlet.layer.borderColor = UIColor.red.cgColor
        dislikeButtonOutlet.layer.borderWidth = 3
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            let worker_id = defaults.string(forKey: "CurrentWorkerId")!
            let token = defaults.string(forKey: "Token")
            let url = URL(string: "https://back.ontimeapp.club/maps/rating/")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let postString = "id=" + worker_id + "&action=dislike"
            request.httpBody = postString.data(using: .utf8)
            //Get response
            let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                do{
                    if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                        let status = json["status"] as! String
                        DispatchQueue.main.async {
                            if status == "ok"{
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
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
