import UIKit
import Foundation
import AVFoundation

class EditPortfolioController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    var PortfolioImages = [UIImage]()
    var ImageIDs = [Int]()
    let imagePicker = UIImagePickerController()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == true {
            getImages()
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        imagePicker.delegate = self
        activityIndicator.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func getImages(){
        PortfolioImages = [UIImage]()
        ImageIDs = [Int]()
        self.mainTableView.reloadData()
        self.activityIndicator.startAnimating()
        self.activityIndicator.alpha = 1.0
        self.alphaView.alpha = 1.0
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "Token")
        let url = URL(string: "https://back.fix-up.org/users/profile/")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        //Get response
        let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
            do{
                if response != nil{
                    if (try JSONSerialization.jsonObject(with: data!, options: []) as? [NSDictionary]) != nil{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [NSDictionary]
                        DispatchQueue.main.async {
                            for i in json{
                                self.ImageIDs.append(i["id"] as! Int)
                                let dataDecoded:NSData = NSData(base64Encoded: i["image_base64"] as! String, options: NSData.Base64DecodingOptions(rawValue: 0))!
                                let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                                self.PortfolioImages.append(decodedimage)
                            }
                            print("OK <Portfolio controller>")
                            self.mainTableView.reloadData()
                            if self.PortfolioImages.count == 0{
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.alpha = 0.0
                                self.alphaView.alpha = 0.0
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
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PortfolioImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PTVCell", for: indexPath) as! PortfolioTableViewCell
        
        cell.portfolioImage.image = PortfolioImages[indexPath.row]
        
        cell.buttonAction = { sender in
            let refreshAlert = UIAlertController(title: "Внимание", message: "Фото будет удалено. Продолжить?", preferredStyle: UIAlertController.Style.alert)

            refreshAlert.addAction(UIAlertAction(title: "Да", style: .default, handler: { (action: UIAlertAction!) in
                
                self.activityIndicator.startAnimating()
                self.activityIndicator.alpha = 1.0
                self.alphaView.alpha = 1.0
                
                if Reachability.isConnectedToNetwork() == true {
                    let defaults = UserDefaults.standard
                    let token = defaults.string(forKey: "Token")
                    let url = URL(string: "https://back.fix-up.org/users/profile/" + String(self.ImageIDs[indexPath.row]))!
                    var request = URLRequest(url: url)
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    //Get response
                    let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                        do{
                            if response != nil{
                                if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                                    let status = json["status"] as! String
                                    DispatchQueue.main.async {
                                        if status == "ok"{
                                            self.getImages()
                                            print("OK! <Delete Photo Portfolio>")
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
                
            }))

            refreshAlert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (action: UIAlertAction!) in
            }))

            self.present(refreshAlert, animated: true, completion: nil)
        }
        
        if indexPath.row + 1 >= PortfolioImages.count{
            self.activityIndicator.stopAnimating()
            self.activityIndicator.alpha = 0.0
            self.alphaView.alpha = 0.0
        }
        
        return cell
    }
    
    
    
    @IBAction func addImageButton(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            if PortfolioImages.count < 10{
                imagePicker.allowsEditing = true
                imagePicker.sourceType = .photoLibrary

                let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { (alert: UIAlertAction!) in

                    switch AVCaptureDevice.authorizationStatus(for: .video) {
                        case .authorized: // The user has previously granted access to the camera.
                            self.imagePicker.sourceType = .camera
                            self.present(self.imagePicker, animated: true, completion: nil)

                        case .notDetermined: // The user has not yet been asked for camera access.
                            AVCaptureDevice.requestAccess(for: .video) { granted in
                                if granted {
                                    self.imagePicker.sourceType = .camera
                                    self.present(self.imagePicker, animated: true, completion: nil)
                                }
                            }

                        case .denied: // The user has previously denied access.
                            let alert = UIAlertController(title: "Внимание", message: "Чтобы настроить доступ к камере зайдите в настройки!", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)

                        case .restricted: // The user can't grant access due to restrictions.
                            let alert = UIAlertController(title: "Внимание", message: "Чтобы настроить доступ к камере зайдите в настройки!", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                    @unknown default:
                        let alert = UIAlertController(title: "Внимание", message: "Чтобы настроить доступ к камере зайдите в настройки!", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }

                })
                let photoLibraryAction = UIAlertAction(title: "Галерея", style: .default, handler: { (alert: UIAlertAction!) in
                    self.imagePicker.sourceType = .photoLibrary
                    self.present(self.imagePicker, animated: true, completion: nil)
                })

                actionSheet.addAction(cameraAction)
                actionSheet.addAction(photoLibraryAction)
                actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (alert: UIAlertAction!) in
                }))

                present(actionSheet, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: "Извините", message: "Невозможно загрузить больше чем 10 фотографии", preferredStyle: .alert)
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.activityIndicator.startAnimating()
            self.activityIndicator.alpha = 1.0
            self.alphaView.alpha = 1.0
            
            let resizedImage = pickedImage.resizeWithWidth(width: 480)!
            
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/users/profile/")!
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
                let postString = "image=" + strBase64
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
                                        self.getImages()
                                        print("OK! <Add Photo Portfolio>")
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
}
