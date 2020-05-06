import UIKit
import Foundation

class MoreInformationController: UIViewController, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    
    @IBOutlet weak var disableView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var i_picker = 1
    var count = 0
    let imagePicker = UIImagePickerController()
    
    var img1 : UIImage!
    var img2 : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        disableView.alpha = 0.0
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0.0
        
        let defaults = UserDefaults.standard
        
        if defaults.string(forKey: "BackPas") != nil && defaults.string(forKey: "FrontPas") != nil{
            imageView.load(url: URL(string: "https://back.fix-up.org/" + defaults.string(forKey: "FrontPas")!)!)
            imageView2.load(url: URL(string: "https://back.fix-up.org/" + defaults.string(forKey: "BackPas")!)!)
            
            let alert = UIAlertController(title: "Внимание", message: "Идет загрузка ваших данных...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            
            if i_picker == 1{
                imageView.image = pickedImage
                let resizedImage = pickedImage.resizeWithWidth(width: 480)!
                img1 = resizedImage
                imageView.contentMode = .scaleAspectFill
                count += 1
            }
            else{
                imageView2.image = pickedImage
                let resizedImage = pickedImage.resizeWithWidth(width: 480)!
                img2 = resizedImage
                imageView2.contentMode = .scaleAspectFill
                count += 1
            }
            
        }
     
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func BackButtonTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func uploadButtonTapped(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        UIApplication.shared.statusBarStyle = .default
        i_picker = 1
    }
    
    
    @IBAction func uploadButton2Tapped(_ sender: UIButton) {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        UIApplication.shared.statusBarStyle = .default
        i_picker = 2
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            if count > 1{
                disableView.alpha = 1.0
                activityIndicator.startAnimating()
                activityIndicator.alpha = 1.0
                let defaults = UserDefaults.standard
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/users/passport/")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                let imageData_1:NSData = img1.pngData()! as NSData
                let imageData_2:NSData = img2.pngData()! as NSData
                var strBase64_1 = imageData_1.base64EncodedString(options: .init(rawValue: 0))
                var strBase64_2 = imageData_2.base64EncodedString(options: .init(rawValue: 0))
                if strBase64_1.suffix(2) != "=="{
                    strBase64_1 += "="
                }
                if strBase64_2.suffix(2) != "=="{
                    strBase64_2 += "="
                }
                let postString = "front=" + strBase64_1 + "&back=" + strBase64_2
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
                                        self.disableView.alpha = 0.0
                                        self.activityIndicator.stopAnimating()
                                        self.activityIndicator.alpha = 0.0
                                        
                                        let alert = UIAlertController(title: "Успешно!", message: "Данные отправлены, модератор проверяет!", preferredStyle: UIAlertController.Style.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                    else{
                                        self.disableView.alpha = 0.0
                                        self.activityIndicator.stopAnimating()
                                        self.activityIndicator.alpha = 0.0
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
                let alert = UIAlertController(title: "Извините", message: "Загрузите обе стороны!", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
