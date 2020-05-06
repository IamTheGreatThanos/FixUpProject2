import UIKit
import Foundation
import MapKit
import CoreLocation

class CardViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var commentLabel: UITextView!
    @IBOutlet weak var avaIcon: UIImageView!
    @IBOutlet weak var enterPriceTextField: UITextField!
    @IBOutlet weak var enterTimeTextField: UITextField!
    @IBOutlet weak var enterCommentTextView: UITextView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var orderView: DesignOfViewWithCR!
    @IBOutlet weak var sendButtonOutlet: UIButton!
    @IBOutlet weak var sendInformationView: DesignOfSpecialtyTableView!
    @IBOutlet weak var customerView: DesignOfSpecialtyTableView!
    @IBOutlet weak var finishButtonOutlet: UIButton!
    @IBOutlet weak var cancelButtonOutlet: UIButton!
    @IBOutlet weak var phoneButtonOutlet: UIButton!
    @IBOutlet weak var whatsappButtonOutlet: UIButton!
    
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var showImg1: UIButton!
    @IBOutlet weak var showImg2: UIButton!
    @IBOutlet weak var showImg3: UIButton!
    
    @IBOutlet weak var ViewShowImg: UIView!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var saveImg1:URL!
    var saveImg2:URL!
    var saveImg3:URL!
    
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var handleArea: UIView!
    var isCustomerView = true
    var isActiveOrders = false
    
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var timer = Timer()
    
    var switcher = 0
    var isAccepted = 0
    var currentLat = 0.0
    var currentLong = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButtonOnKeyboard()
        enterPriceTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        ViewShowImg.alpha = 0.0
        
        let defaults = UserDefaults.standard
        isCustomerView = defaults.bool(forKey: "isCustomerView")
        isActiveOrders = defaults.bool(forKey: "isActiveOrders")
        let isCourier = defaults.bool(forKey: "isCourier")
        
        if isCustomerView == true{
            if isActiveOrders == true{
                sendButtonOutlet.alpha = 0.0
//                sendButtonOutlet.setTitle("Cancel", for: .normal)
//                sendButtonOutlet.backgroundColor = UIColor(red: 0.9569, green: 0.3608, blue: 0.3608, alpha: 1.0)
                customerView.alpha = 1.0
                finishButtonOutlet.alpha = 1.0
            }
            else{
                sendButtonOutlet.setTitle("Принять", for: .normal)
                customerView.alpha = 0.0
            }
            sendInformationView.alpha = 0.0
            image1.alpha = 0.0
            image2.alpha = 0.0
            image3.alpha = 0.0
            showImg1.alpha = 0.0
            showImg2.alpha = 0.0
            showImg3.alpha = 0.0
        }
        else{
            if isActiveOrders == true{
                customerView.alpha = 1.0
                finishButtonOutlet.alpha = 0.0
                
                sendButtonOutlet.alpha = 0.0
//                sendButtonOutlet.setTitle("Cancel", for: .normal)
//                sendButtonOutlet.backgroundColor = UIColor(red: 0.9569, green: 0.3608, blue: 0.3608, alpha: 1.0)
                sendInformationView.alpha = 0.0
                image1.alpha = 0.0
                image2.alpha = 0.0
                image3.alpha = 0.0
                showImg1.alpha = 0.0
                showImg2.alpha = 0.0
                showImg3.alpha = 0.0
                
            }
            else{
                sendButtonOutlet.setTitle("Принять", for: .normal)
                customerView.alpha = 0.0
                enterPriceTextField.placeholder = defaults.string(forKey: "CurrentPrice")! + " тг"
                enterTimeTextField.placeholder = "1 час"
            }
        }
        
        if isCourier == false{
            sendInformationView.alpha = 0.0
            image1.alpha = 0.0
            image2.alpha = 0.0
            image3.alpha = 0.0
            if isActiveOrders == true{
                sendButtonOutlet.alpha = 0.0
                customerView.alpha = 1.0
            }
        }
        
        
        nameLabel.text = defaults.string(forKey: "CurrentName")!
        priceLabel.text = defaults.string(forKey: "CurrentPrice")! + " тг"
        commentLabel.text = defaults.string(forKey: "CurrentComment")!
        locationLabel.text = defaults.string(forKey: "CurrentLocation")!
        if defaults.string(forKey: "CurrentAvatar") != "Nil" && defaults.string(forKey: "CurrentAvatar") != nil{
            let url = defaults.string(forKey: "CurrentAvatar")!
            let loadUrl = URL(string: "https://back.fix-up.org/" + url)!
            self.avaIcon.load(url: loadUrl)
        }
        
        if defaults.string(forKey: "orderImg1") != "nil" && defaults.string(forKey: "orderImg1") != nil{
            let url = defaults.string(forKey: "orderImg1")!
            let loadUrl = URL(string: "https://back.fix-up.org/" + url)!
            self.image1.load(url: loadUrl)
            self.saveImg1 = URL(string: "https://back.fix-up.org/" + url)
        }
        else{
            self.image1.alpha = 0.0
            self.showImg1.alpha = 0.0
        }
        
        if defaults.string(forKey: "orderImg2") != "nil" && defaults.string(forKey: "orderImg2") != nil{
            let url = defaults.string(forKey: "orderImg2")!
            let loadUrl = URL(string: "https://back.fix-up.org/" + url)!
            self.image2.load(url: loadUrl)
            self.saveImg2 = URL(string: "https://back.fix-up.org/" + url)
        }
        else{
            self.image2.alpha = 0.0
            self.showImg2.alpha = 0.0
        }
        
        if defaults.string(forKey: "orderImg3") != "nil" && defaults.string(forKey: "orderImg3") != nil{
            let url = defaults.string(forKey: "orderImg3")!
            let loadUrl = URL(string: "https://back.fix-up.org/" + url)!
            self.image3.load(url: loadUrl)
            self.saveImg3 = URL(string: "https://back.fix-up.org/" + url)
        }
        else{
            self.image3.alpha = 0.0
            self.showImg3.alpha = 0.0
        }
        
        commentLabel.isEditable = false
        
        enterCommentTextView.text = "Пожалуйста, напишите немного информации о заказе!"
        enterCommentTextView.textColor = UIColor.lightGray
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isActiveOrders")
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
        
        enterPriceTextField.inputAccessoryView = doneToolbar
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if textField == enterPriceTextField{
            if enterPriceTextField.text?.count == 7{
                enterPriceTextField.text = String(enterPriceTextField.text!.prefix(6))
            }
        }
    }
    
    @objc func doneButtonAction()
    {
        if self.switcher == 1{
            UIView.animate(withDuration: 0.6, animations: {
                self.orderView.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomConstraint.constant -= 220
            })
            if enterPriceTextField.text!.count != 0 || enterTimeTextField.text!.count != 0{
                sendButtonOutlet.setTitle("Send", for: .normal)
            }
            else{
                sendButtonOutlet.setTitle("Accept", for: .normal)
            }
            self.switcher = 0
        }
        self.view.endEditing(true)
    }
    
    @objc func checkOrder(){
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            let order_id = defaults.string(forKey: "CurrentOrderID")!
            let token = defaults.string(forKey: "Token")
            let url = URL(string: "https://back.fix-up.org/maps/check")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let postString = "id=" + order_id
            request.httpBody = postString.data(using: .utf8)
            //Get response
            let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                do{
                    if response != nil{
                        if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                            print(json)
                            let status = json["status"] as! String
                            DispatchQueue.main.async {
                                if status == "accept"{
                                    let alert = UIAlertController(title: "Успешно", message: "Ваш заказ принят! Пожалуйста, пройдите в Меню - Мои заказы!", preferredStyle: UIAlertController.Style.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.timer.invalidate()
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        self.currentLat = locValue.latitude
        self.currentLong = locValue.longitude
    }
    
    @IBAction func SendButtonTapped(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            if isCustomerView == true{
                if isActiveOrders == true{
                    let alert = UIAlertController(title: "Внимание", message: "Ваш заказ будет отменен! Продолжить?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
                        let defaults = UserDefaults.standard
                        let token = defaults.string(forKey: "Token")
                        let order_id = defaults.string(forKey: "CurrentOrderID")!
                        
                        let url = URL(string: "https://back.fix-up.org/maps/cancel/")!
                        var request = URLRequest(url: url)
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                        request.httpMethod = "POST"
                        let postString = "id=" + order_id
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
                                                self.navigationController?.popViewController(animated: true)
                                                defaults.set(false, forKey: "isCurrentOrder")
                                                defaults.removeObject(forKey: "MyOrder")
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
                    }))
                    alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
                    }))
                    
                    self.present(alert, animated: true)
                }
                else{
                    let defaults = UserDefaults.standard
                    let order_id = defaults.string(forKey: "MyOrder")!
                    let worker_id = defaults.string(forKey: "CurrentWorkerId")!
                    let token = defaults.string(forKey: "Token")
                    let url = URL(string: "https://back.fix-up.org/maps/accept/")!
                    var request = URLRequest(url: url)
                    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                    request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                    request.httpMethod = "POST"
                    let postString = "order_id=" + order_id + "&worker_id=" + worker_id
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
                                            self.customerView.alpha = 1.0
                                            self.sendButtonOutlet.alpha = 0.0
                                            self.isAccepted = 1
                                            defaults.set(false, forKey: "isValidateTimer")
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
            }
            else{
                if isActiveOrders == true{
                    let alert = UIAlertController(title: "Внимание", message: "Ваш заказ будет отменен! Продолжить?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
                        
                        let defaults = UserDefaults.standard
                        let token = defaults.string(forKey: "Token")
                        let order_id = defaults.string(forKey: "CurrentOrderID")!
                        
                        let url = URL(string: "https://back.fix-up.org/maps/cancel/")!
                        var request = URLRequest(url: url)
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                        request.httpMethod = "POST"
                        let postString = "id=" + order_id
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
                                                self.navigationController?.popViewController(animated: true)
                                                defaults.set(false, forKey: "isCurrentOrder")
                                                defaults.removeObject(forKey: "MyOrder")
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
                        
                    }))
                    alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
                    }))
                    
                    self.present(alert, animated: true)
                }
                else{
                    if enterTimeTextField.text!.count != 0 && enterCommentTextView.text!.count != 0 && enterPriceTextField.text!.count != 0{
                        self.locationManager.requestWhenInUseAuthorization()
                        
                        if CLLocationManager.locationServicesEnabled(){
                            locationManager.delegate = self
                            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                            locationManager.startUpdatingLocation()
                        }
                        
                        
                        let defaults = UserDefaults.standard
                        let order_id = defaults.string(forKey: "CurrentOrderID")!
                        let token = defaults.string(forKey: "Token")
                        let url = URL(string: "https://back.fix-up.org/maps/send/")!
                        var request = URLRequest(url: url)
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                        request.httpMethod = "POST"
                        let postString = "id=" + order_id + "&price=" + enterPriceTextField.text! + "&comment=" + enterCommentTextView.text! + "&time=" + enterTimeTextField.text! + "&lat=" + String(self.currentLat) + "&lng=" + String(self.currentLong)
                    
                        request.httpBody = postString.data(using: .utf8)
                        //Get response
                        let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                            do{
                                if response != nil{
                                    if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                                        let status = json["status"] as! String
                                        DispatchQueue.main.async {
                                            if status == "ok"{
                                                self.sendButtonOutlet.isEnabled = false
                                                self.sendButtonOutlet.backgroundColor = UIColor.lightGray
                                                let alert = UIAlertController(title: "Успешно", message: "Ваша информация отправлена!", preferredStyle: UIAlertController.Style.alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.checkOrder), userInfo: nil, repeats: true)
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
                        self.locationManager.requestWhenInUseAuthorization()
                        
                        if CLLocationManager.locationServicesEnabled(){
                            locationManager.delegate = self
                            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                            locationManager.startUpdatingLocation()
                        }
                        
                        
                        let defaults = UserDefaults.standard
                        let order_id = defaults.string(forKey: "CurrentOrderID")!
                        let token = defaults.string(forKey: "Token")
                        let url = URL(string: "https://back.fix-up.org/maps/send/")!
                        var request = URLRequest(url: url)
                        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                        request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                        request.httpMethod = "POST"
                        let time = "1 час"
                        let price = defaults.string(forKey: "CurrentPrice")!
                        
                        let postString = "id=" + order_id + "&price=" + price + "&comment=Комментарий нет..." + "&time=" + time + "&lat=" + String(self.currentLat) + "&lng=" + String(self.currentLong)
                    
                        request.httpBody = postString.data(using: .utf8)
                        //Get response
                        let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                            do{
                                if response != nil{
                                    if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:AnyObject]
                                        let status = json["status"] as! String
                                        DispatchQueue.main.async {
                                            if status == "ok"{
                                                self.sendButtonOutlet.isEnabled = false
                                                self.sendButtonOutlet.backgroundColor = UIColor.lightGray
                                                let alert = UIAlertController(title: "Успешно", message: "Ваша информация отправлена!", preferredStyle: UIAlertController.Style.alert)
                                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                                                self.present(alert, animated: true, completion: nil)
                                                
                                                self.timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(self.checkOrder), userInfo: nil, repeats: true)
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
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func BackButtonTapped(_ sender: UIButton) {
        if self.isAccepted == 0{
            self.navigationController?.popViewController(animated: true)
        }
        else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
            self.present(viewController, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.switcher == 1{
        
            UIView.animate(withDuration: 0.6, animations: {
                self.orderView.alpha = 1.0
            })
            
            UIView.animate(withDuration: 0.2, animations: {
                self.bottomConstraint.constant -= 220
            })
            if enterPriceTextField.text!.count != 0 || enterTimeTextField.text!.count != 0{
                sendButtonOutlet.setTitle("Send", for: .normal)
            }
            else{
                sendButtonOutlet.setTitle("Accept", for: .normal)
            }
            
            
            self.switcher = 0
        }
        
        
        self.view.endEditing(true)
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.switcher == 0 {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.orderView.alpha = 0.0
            })
            
            UIView.animate(withDuration: 0.6, animations: {
                self.bottomConstraint.constant += 220
            })
            
            self.switcher = 1
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            if self.switcher == 1{
            
                UIView.animate(withDuration: 0.6, animations: {
                    self.orderView.alpha = 1.0
                })
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.bottomConstraint.constant -= 220
                })
                
                if enterCommentTextView.text!.count == 0{
                    enterCommentTextView.text = "Пожалуйста, напишите немного информации о заказе!"
                    enterCommentTextView.textColor = UIColor.lightGray
                }
                else{
                    sendButtonOutlet.setTitle("Отправить", for: .normal)
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
                self.orderView.alpha = 0.0
            })
            
            UIView.animate(withDuration: 0.6, animations: {
                self.bottomConstraint.constant += 220
            })
            
            self.switcher = 1
            
        }
        enterCommentTextView.text = ""
        enterCommentTextView.textColor = UIColor.black
    }
    
    
    @IBAction func phoneButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        let phoneNumber = defaults.string(forKey: "CurrentPhoneNumber")
        guard let number = URL(string: "tel://" + phoneNumber!) else { return }
        UIApplication.shared.open(number)
    }
    
    
    @IBAction func whatsappButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        var phoneNumber = defaults.string(forKey: "CurrentPhoneNumber")
        if phoneNumber?.prefix(2) == "+7"{
            UIApplication.shared.openURL(URL(string:"https://api.whatsapp.com/send?phone=" + phoneNumber!)!)
        }
        else{
            let len = (phoneNumber!.count as Int) - 1
            phoneNumber = "+7" + (phoneNumber?.suffix(len))!
            UIApplication.shared.openURL(URL(string:"https://api.whatsapp.com/send?phone=" + phoneNumber!)!)
        }
        
    }
    
    
    // MARK: -- Finish button Customer View
    @IBAction func finishOrderButtonTapped(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            var order_id = ""
            if defaults.string(forKey: "MyOrder") != nil {
                order_id = defaults.string(forKey: "MyOrder")!
            }
            else{
                order_id = defaults.string(forKey: "CurrentOrderID")!
            }
//            let worker_id = defaults.string(forKey: "CurrentWorkerId")!
            let token = defaults.string(forKey: "Token")
            let url = URL(string: "https://back.fix-up.org/maps/finish/")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let postString = "id=" + order_id
            request.httpBody = postString.data(using: .utf8)
            //Get response
            let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                do{
                    print(response)
                    if response != nil{
                        if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                            let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: AnyObject]
                            let status = json["status"] as! String
                            print(json)
                            DispatchQueue.main.async {
                                if status == "ok"{
                                    defaults.set(false,forKey: "isCurrentOrder")
                                    defaults.removeObject(forKey: "MyOrder")
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let viewController = storyboard.instantiateViewController(withIdentifier :"FinishController")
                                    self.present(viewController, animated: true)
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
    
    
    // MARK: -- Cancel button Customer View
    @IBAction func cancelOrderButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Внимание", message: "Ваш заказ будет отменен! Продолжить?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                let token = defaults.string(forKey: "Token")
                let order_id = defaults.string(forKey: "CurrentOrderID")!
                
                let url = URL(string: "https://back.fix-up.org/maps/cancel/")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                let postString = "id=" + order_id
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
                                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
                                        self.present(viewController, animated: true)
                                        defaults.set(false, forKey: "isCurrentOrder")
                                        defaults.removeObject(forKey: "MyOrder")
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
            
        }))
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
        }))
        
        self.present(alert, animated: true)
    }
    
    
    @IBAction func userInformationButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"ProfileController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "asUserInfo")
    }
    
    
    @IBAction func showImg1Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1.0, animations: {
            self.ViewShowImg.alpha = 1.0
            self.selectedImageView.image = nil
            self.selectedImageView.load(url: self.saveImg1)
        })
    }
    
    @IBAction func showImg2Tapped(_ sender: Any) {
        UIView.animate(withDuration: 1.0, animations: {
            self.ViewShowImg.alpha = 1.0
            self.selectedImageView.image = nil
            self.selectedImageView.load(url: self.saveImg2)
        })
    }
    
    @IBAction func showImg3Tapped(_ sender: Any) {
        UIView.animate(withDuration: 1.0, animations: {
            self.ViewShowImg.alpha = 1.0
            self.selectedImageView.image = nil
            self.selectedImageView.load(url: self.saveImg3)
        })
    }
    
    
    @IBAction func backToCardTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            self.ViewShowImg.alpha = 0.0
        })
    }
}
