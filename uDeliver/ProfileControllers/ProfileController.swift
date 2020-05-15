import UIKit
import Foundation
import AVFoundation

class ProfileController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var specialtyNameOutlet: UIButton!
    @IBOutlet weak var firstView: UIView!
    
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var editButtonOutlet: UIButton!
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBOutlet weak var moreButtonOutlet: UIButton!
    @IBOutlet weak var addPhotoButtonOutlet: UIButton!
    @IBOutlet weak var segmentOutlet: UISegmentedControl!
    
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var closeViewButtonOutlet: UIButton!
    @IBOutlet weak var seeingImage: UIImageView!
    @IBOutlet weak var activityForAva: UIActivityIndicatorView!
    
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var allOrdersLabel: UILabel!
    @IBOutlet weak var dislikeLabel: UILabel!
    
    var avaUrl: URL!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alphaView.alpha = 0.0
        closeViewButtonOutlet.alpha = 0.0
        seeingImage.alpha = 0.0
        activityForAva.alpha = 0.0
        
        let defaults = UserDefaults.standard
        let isRegisterAsSpecialist = defaults.bool(forKey: "isRegisterAsSpecialist")
        if isRegisterAsSpecialist == false{
            moreButton.isHidden = true
            specialtyNameOutlet.isUserInteractionEnabled = false
        }
        
        firstView.alpha = 1.0
        secondView.alpha = 0.0
        thirdView.alpha = 0.0
        
        imagePicker.delegate = self
        
        if Reachability.isConnectedToNetwork() == true {
            getProfileInfo()
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        let asUserInfo = defaults.bool(forKey: "asUserInfo")
        
        if asUserInfo == false{
            if defaults.data(forKey: "AvaImage") != nil{
                let image = UIImage(data: defaults.data(forKey: "AvaImage")!)
                avaImage.image = image
            }
        }
        
//        if let filePath = Bundle.main.path(forResource: "imageName", ofType: "jpg"), let image = UIImage(contentsOfFile: filePath) {
//            imageView.contentMode = .scaleAspectFit
//            imageView.image = image
//        }
    }
    
    
    func getProfileInfo(){
        let defaults = UserDefaults.standard
        let isCourier = defaults.bool(forKey: "isCourier")
        let asUserInfo = defaults.bool(forKey: "asUserInfo")
        
        if asUserInfo == true{
            if isCourier == true{
                firstView.alpha = 0.0
                segmentOutlet.alpha = 0.0
            }
            
            editButtonOutlet.alpha = 0.0
            moreButtonOutlet.alpha = 0.0
            specialtyNameOutlet.isEnabled = false
            addPhotoButtonOutlet.alpha = 0.0
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
                                self.nameLabel.text = json["nickname"] as! String
                                if let spec_value = json["spec"] as? String{
                                    self.specialtyNameOutlet.setTitle(spec_value, for: .normal)
                                    defaults.set(json["spec"] as! String, forKey: "MySpec")
                                }
                                else{
                                    self.specialtyNameOutlet.setTitle("Заказчик", for: .normal)
                                    defaults.set("Заказчик", forKey: "MySpec")
                                }
                                if json["avatar"] != nil{
                                    let url = json["avatar"] as! String
                                    let loadUrl = URL(string: "https://back.fix-up.org/" + url)!
                                    self.avaImage.load(url: loadUrl)
                                    self.avaUrl = loadUrl
                                }
                                if (json["about"] as? String != nil){
                                    defaults.set(json["about"], forKey: "OtherAbout")
                                }
                                else{
                                    defaults.set("Информация отсутствует...", forKey: "OtherAbout")
                                }
                                defaults.set(json["like"], forKey: "OtherLike")
                                defaults.set(json["dislike"], forKey: "OtherDislike")
                                
                                self.likeLabel.text = String(json["like"] as! Int)
                                self.dislikeLabel.text = String(json["dislike"] as! Int)
                                self.allOrdersLabel.text = String((json["customer"] as! Int) + (json["worder"] as! Int))
                                
                                print("OK <Profile controller>")
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
            let token = defaults.string(forKey: "Token")
            let url = URL(string: "https://back.fix-up.org/users/me/")!
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
                                self.nameLabel.text = (json["nickname"] as! String)
                                if let spec_value = json["spec"] as? String{
                                    self.specialtyNameOutlet.setTitle(spec_value, for: .normal)
                                    defaults.set(json["spec"] as! String, forKey: "MySpec")
                                }
                                else{
                                    self.specialtyNameOutlet.setTitle("Заказчик", for: .normal)
                                    defaults.set("Заказчик", forKey: "MySpec")
                                }
                                
                                let url = json["avatar"] as! String
                                let loadUrl = URL(string: "https://back.fix-up.org/" + url)!
                                self.avaImage.loadAva(url: loadUrl)
                                self.avaUrl = loadUrl
                                defaults.set(loadUrl, forKey: "MyAvatar")
                                defaults.set(json["nickname"] as! String, forKey: "MyName")
                                if ((json["about"] as? String) != nil){
                                    defaults.set(json["about"] as! String, forKey: "About")
                                }
                                defaults.set(json["like"], forKey: "MyLike")
                                defaults.set(json["dislike"], forKey: "MyDislike")
                                if json["front_passport"] as? String != nil && json["back_passport"] as? String != nil{
                                    defaults.set(json["back_passport"] as! String, forKey: "BackPas")
                                    defaults.set(json["front_passport"] as! String, forKey: "FrontPas")
                                }
                                
                                self.likeLabel.text = String(json["like"] as! Int)
                                self.dislikeLabel.text = String(json["dislike"] as! Int)
                                self.allOrdersLabel.text = String((json["customer"] as! Int) + (json["worder"] as! Int))
                                
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
    }
    
    
    @IBAction func seeAvaButtonTapped(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            if avaUrl != nil{
                UIView.animate(withDuration: 1.0, animations: {
                    self.activityForAva.alpha = 1.0
                    self.activityForAva.startAnimating()
                    self.alphaView.alpha = 1.0
                    self.closeViewButtonOutlet.alpha = 1.0
                    self.seeingImage.alpha = 1.0
                    
                })
                self.seeingImage.load(url: avaUrl)
            }
            else{
                let alert = UIAlertController(title: "Извините", message: "Фотка загружается...", preferredStyle: .alert)
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
    
    @IBAction func closeViewButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.alphaView.alpha = 0.0
            self.closeViewButtonOutlet.alpha = 0.0
            self.seeingImage.alpha = 0.0
            self.activityForAva.alpha = 0.0
            self.activityForAva.stopAnimating()
        })
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func segmentControl(_ sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0){
            firstView.alpha = 1.0
            secondView.alpha = 0.0
            thirdView.alpha = 0.0
        }
        else if (sender.selectedSegmentIndex == 1){
            firstView.alpha = 0.0
            secondView.alpha = 0.0
            thirdView.alpha = 1.0
        }
        else{
            firstView.alpha = 0.0
            secondView.alpha = 0.0
            thirdView.alpha = 1.0
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.avaImage.contentMode = .scaleAspectFill
            
            let resizedImage = pickedImage.resizeWithWidth(width: 480)!

//            let compressData = pickedImage.jpegData(compressionQuality: 0.0) //max value is 1.0 and minimum is 0.0
//            let compressedImage = UIImage(data: compressData!)!
            self.avaImage.image = resizedImage
            
            
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/users/avatar/")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                let imageData:NSData = resizedImage.pngData()! as NSData
                
                var strBase64 = imageData.base64EncodedString(options: .lineLength64Characters)
                if strBase64.suffix(2) != "=="{
                    strBase64 += "="
                }
                if strBase64.suffix(2) != "=="{
                    strBase64 += "="
                }
                let postString = "avatar=" + strBase64
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
                                        print("OK! <Change Avatar>")
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
                let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
     
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func moreButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MoreInformationController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
    }
    
    
    @IBAction func EditButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"EditProfileController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
    }
    
    @IBAction func changeAvatarButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "asUserInfo") == true{
            self.navigationController?.popViewController(animated: true)
            defaults.set(false, forKey: "asUserInfo")
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
            self.present(viewController, animated: true)
        }
    }
    
    
    @IBAction func specialtyChangeButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SpecialtyController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "changeByProfile")
    }
    
}
