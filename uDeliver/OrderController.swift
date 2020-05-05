import UIKit
import Foundation
import AVFoundation

class OrderController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,  UINavigationControllerDelegate {
    
    @IBOutlet weak var orderInformation: UILabel!
    @IBOutlet weak var orderInfo: UILabel!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var SpecTitle: UILabel!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    var counter = 0
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityView: UIView!
    
    var pickedImg1: UIImage!
    var pickedImg2: UIImage!
    var pickedImg3: UIImage!
    
    var switcher = 0
    var isRegister = ""
    var timer = Timer()
    let imagePicker = UIImagePickerController()
    var image_sw = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        addDoneButtonOnKeyboard()
        priceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        activityView.alpha = 0.0
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "OrderAddress") != nil {
            locationLabel.text = defaults.string(forKey: "OrderAddress")
        }
        commentTextView.text = "Пожалуйста, напишите немного информации о заказе!"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.layer.borderWidth = 1.0
        commentTextView.layer.borderColor = UIColor.lightGray.cgColor
        commentTextView.layer.cornerRadius = 5.0
        
        SpecTitle.text = defaults.string(forKey: "CurrentOrderSpecTitle")
        orderInfo.text = defaults.string(forKey: "CurrentOrderSpecDesc")
        
        if defaults.string(forKey: "isRegister") != nil{
            self.isRegister = defaults.string(forKey: "isRegister")!
        }
        else{
            self.isRegister = "false"
        }
        
        if self.isRegister == "false"{
            let alert = UIAlertController(title: "Внимание", message: "Вы должны зарегистрироваться! Вы уверены?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier :"PhoneController")
                self.present(viewController, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
            }))
            
            self.present(alert, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "OrderAddress") != nil {
            locationLabel.text = defaults.string(forKey: "OrderAddress")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey:"OrderLat")
        defaults.removeObject(forKey:"OrderLng")
        defaults.removeObject(forKey:"OrderAddress")
        
        activityView.alpha = 0.0
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == priceTextField{
            if priceTextField.text?.count == 7{
                priceTextField.text = String(priceTextField.text!.prefix(6))
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
        
        priceTextField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction()
    {
        if self.switcher == 1{
        
            UIView.animate(withDuration: 0.6, animations: {
                self.orderInfo.alpha = 1.0
                self.orderInformation.alpha = 1.0
                self.SpecTitle.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant += 150
                self.bottomConstraint.constant -= 150
            })
            
            
            self.switcher = 0
        }
        
        self.view.endEditing(true)
    }
    
    
    @IBAction func ChooseLocationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"ChooseLocationController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
        }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            if image_sw == 1{
                self.image1.contentMode = .scaleAspectFill
                self.image1.image = pickedImage
                self.pickedImg1 = pickedImage
            }
            else if image_sw == 2{
                self.image2.contentMode = .scaleAspectFill
                self.image2.image = pickedImage
                self.pickedImg2 = pickedImage
            }
            else{
                self.image3.contentMode = .scaleAspectFill
                self.image3.image = pickedImage
                self.pickedImg3 = pickedImage
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func image1ButtonTapped(_ sender: UIButton) {
        image_sw = 1
        imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { (alert: UIAlertAction!) in
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    DispatchQueue.main.async {
                        self.imagePicker.sourceType = .camera
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            DispatchQueue.main.async {
                                self.imagePicker.sourceType = .camera
                                self.present(self.imagePicker, animated: true, completion: nil)
                            }
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
            }
            
        })
        let photoLibraryAction = UIAlertAction(title: "Галерея", style: .default, handler: { (alert: UIAlertAction!) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            UIApplication.shared.statusBarStyle = .default
        })

        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (alert: UIAlertAction!) in
            UIApplication.shared.statusBarStyle = .lightContent
        }))
        
        present(actionSheet, animated: true, completion: nil)
        
        if self.switcher == 1{
            UIView.animate(withDuration: 0.6, animations: {
                self.orderInfo.alpha = 1.0
                self.orderInformation.alpha = 1.0
                self.SpecTitle.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant += 150
                self.bottomConstraint.constant -= 150
            })
            
            self.switcher = 0
        }
    }
    
    
    @IBAction func image2ButtonTapped(_ sender: UIButton) {
        image_sw = 2
        imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { (alert: UIAlertAction!) in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    DispatchQueue.main.async {
                        self.imagePicker.sourceType = .camera
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                
                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            DispatchQueue.main.async {
                                self.imagePicker.sourceType = .camera
                                self.present(self.imagePicker, animated: true, completion: nil)
                            }
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
            }
        })
        let photoLibraryAction = UIAlertAction(title: "Галерея", style: .default, handler: { (alert: UIAlertAction!) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            UIApplication.shared.statusBarStyle = .default
        })

        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (alert: UIAlertAction!) in
            UIApplication.shared.statusBarStyle = .lightContent
        }))
        
        present(actionSheet, animated: true, completion: nil)
        
        
        if self.switcher == 1{
        
            UIView.animate(withDuration: 0.6, animations: {
                self.orderInfo.alpha = 1.0
                self.orderInformation.alpha = 1.0
                self.SpecTitle.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant += 150
                self.bottomConstraint.constant -= 150
            })
            
            
            self.switcher = 0
        }
    }
    
    
    @IBAction func image3ButtonTapped(_ sender: UIButton) {
        image_sw = 3
        imagePicker.allowsEditing = true
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Камера", style: .default, handler: { (alert: UIAlertAction!) in
            switch AVCaptureDevice.authorizationStatus(for: .video) {
                case .authorized: // The user has previously granted access to the camera.
                    DispatchQueue.main.async {
                        self.imagePicker.sourceType = .camera
                        self.present(self.imagePicker, animated: true, completion: nil)
                    }
                
                case .notDetermined: // The user has not yet been asked for camera access.
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        if granted {
                            DispatchQueue.main.async {
                                self.imagePicker.sourceType = .camera
                                self.present(self.imagePicker, animated: true, completion: nil)
                            }
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
            }
        })
        let photoLibraryAction = UIAlertAction(title: "Галерея", style: .default, handler: { (alert: UIAlertAction!) in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
            UIApplication.shared.statusBarStyle = .default
        })

        actionSheet.addAction(cameraAction)
        actionSheet.addAction(photoLibraryAction)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (alert: UIAlertAction!) in
            UIApplication.shared.statusBarStyle = .lightContent
        }))
        
        present(actionSheet, animated: true, completion: nil)
        
        if self.switcher == 1{
        
            UIView.animate(withDuration: 0.6, animations: {
                self.orderInfo.alpha = 1.0
                self.orderInformation.alpha = 1.0
                self.SpecTitle.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant += 150
                self.bottomConstraint.constant -= 150
            })
            
            
            self.switcher = 0
        }
    }
    
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            let value = defaults.bool(forKey: "isCourier")
            
            if defaults.string(forKey: "isRegister") != nil{
                self.isRegister = defaults.string(forKey: "isRegister")!
            }
            else{
                self.isRegister = "false"
            }
            
            if self.isRegister == "true"{
                if priceTextField.text!.count > 2 && locationLabel.text!.count != 0 && commentTextView.text!.count > 10 && commentTextView.text != "Пожалуйста, напишите немного информации о заказе!" {
                    activityView.alpha = 1.0
                    activityIndicator.isHidden = false
                    activityIndicator.startAnimating()
                    
                    let defaults = UserDefaults.standard
                    let token = defaults.string(forKey: "Token")
                    let lat = defaults.string(forKey: "OrderLat")!
                    let lng = defaults.string(forKey: "OrderLng")!
                    let address = defaults.string(forKey: "OrderAddress")!
                    let url = URL(string: "https://back.fix-up.org/maps/order/")!
                    let specID = defaults.integer(forKey: "SpecialtyId")
                    var request = URLRequest(url: url)
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    
                    var strBase64_1 = "None"
                    var strBase64_2 = "None"
                    var strBase64_3 = "None"
                    
                    if pickedImg1 != nil{
                        let resizedImage1 = pickedImg1.resizeWithWidth(width: 480)
                        let imageData1:NSData = resizedImage1!.pngData()! as NSData
                        strBase64_1 = imageData1.base64EncodedString(options: .lineLength64Characters)
                        strBase64_1 += "=="
                    }
                    
                    if pickedImg2 != nil{
                        let resizedImage2 = pickedImg2.resizeWithWidth(width: 480)
                        let imageData2:NSData = resizedImage2!.pngData()! as NSData
                        strBase64_2 = imageData2.base64EncodedString(options: .lineLength64Characters)
                        strBase64_2 += "=="
                    }
                        
                    if pickedImg3 != nil{
                        let resizedImage3 = pickedImg3.resizeWithWidth(width: 480)
                        let imageData3:NSData = resizedImage3!.pngData()! as NSData
                        strBase64_3 = imageData3.base64EncodedString(options: .lineLength64Characters)
                        strBase64_3 += "=="
                    }
                    
                    let postString = "comment=" + commentTextView.text! + "&price=" + priceTextField.text! + "&a_lat=" + lat + "&a_long=" + lng + "&a_name=" + address + "&image1=" + strBase64_1 + "&image2=" + strBase64_2 + "&image3=" + strBase64_3 + "&spec=" + String(specID+1)
                    
                    print(specID)
                    
                    
                    request.httpBody = postString.data(using: .utf8)
                    //Get response
                    let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                        do{
                            if response != nil{
                                if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                                    let status = json["status"] as! String
                                    let id = json["id"] as! String
                                    DispatchQueue.main.async {
                                        if status == "ok"{
                                            defaults.removeObject(forKey:"OrderLat")
                                            defaults.removeObject(forKey:"OrderLng")
                                            defaults.removeObject(forKey:"OrderAddress")
                                            defaults.set(id, forKey: "MyOrder")
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let viewController = storyboard.instantiateViewController(withIdentifier :"ListOfSpecialistsController")
                                            self.navigationController?.pushViewController(viewController,
                                            animated: true)
                                            
                                            defaults.set(true,forKey: "isCurrentOrder")
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
                    let alert = UIAlertController(title: "Простите", message: "Пожалуйста, введите правильную информацию!", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else{
                let alert = UIAlertController(title: "Внимание", message: "Вы должны зарегистрироваться! Вы уверены?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier :"PhoneController")
                    self.present(viewController, animated: true)
                }))
                alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
                }))
                
                self.present(alert, animated: true)
            }
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.switcher == 1{
        
            UIView.animate(withDuration: 0.6, animations: {
                self.orderInfo.alpha = 1.0
                self.orderInformation.alpha = 1.0
                self.SpecTitle.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.topConstraint.constant += 150
                self.bottomConstraint.constant -= 150
            })
            
            
            self.switcher = 0
        }
        
        
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.switcher == 0 {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.orderInformation.alpha = 0.0
                self.orderInfo.alpha = 0.0
                self.SpecTitle.alpha = 0.0
            })
            
            UIView.animate(withDuration: 0.6, animations: {
                self.topConstraint.constant -= 150
                self.bottomConstraint.constant += 150
            })
            
            self.switcher = 1
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if self.switcher == 1{
            
                UIView.animate(withDuration: 0.6, animations: {
                    self.orderInfo.alpha = 1.0
                    self.orderInformation.alpha = 1.0
                    self.SpecTitle.alpha = 1.0
                })
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.topConstraint.constant += 150
                    self.bottomConstraint.constant -= 150
                })
                
                if commentTextView.text!.count == 0{
                    commentTextView.text = "Пожалуйста, напишите еще немного информации о заказе!"
                    commentTextView.textColor = UIColor.lightGray
                }
                
                
                self.switcher = 0
            }
            
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.switcher == 0 {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.orderInformation.alpha = 0.0
                self.orderInfo.alpha = 0.0
                self.SpecTitle.alpha = 0.0
            })
            
            UIView.animate(withDuration: 0.6, animations: {
                self.topConstraint.constant -= 150
                self.bottomConstraint.constant += 150
            })
            
            self.switcher = 1
            
        }
        if counter != 1{
            commentTextView.text = ""
            commentTextView.textColor = UIColor.black
            counter = 1
        }
    }
}
