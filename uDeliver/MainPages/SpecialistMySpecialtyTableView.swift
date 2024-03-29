import UIKit
import Foundation
import CoreLocation

class SpecialistMySpecialtyTableView: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    var Names = [String]()
    var Prices = [String]()
    var Specialty = [String]()
    var Radius = [String]()
    var Comments = [String]()
    var Locations = [String]()
    var Lats = [String]()
    var Lngs = [String]()
    var IDs = [String]()
    var Distan = [String]()
    var Durat = [String]()
    var CustomersID = [String]()
    var Avatars = [String]()
    var orderImages = [[String]]()
    var phoneNumbers = [String]()
    var Avas = [UIImage]()
    
    var Last_IDs = [String]()
    
    
    var timer = Timer()
    var orderTimer = Timer()
    var locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    
    var lat = 0.0
    var long = 0.0
    
    var isFinish = 0
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SMScell", for: indexPath) as! SpecialistMySpecialtyTableViewCell
        
        if indexPath.row < Names.count{
            cell.nameLabel.text = Names[indexPath.row]
            cell.priceLabel.text = Prices[indexPath.row] + " ₸"
            cell.radiusLabel.text = Distan[indexPath.row]
            cell.commentLabel.text = Comments[indexPath.row]
            cell.locationLabel.text = Locations[indexPath.row]
            cell.timeLabel.text = Durat[indexPath.row]
            if indexPath.row < Avas.count {
                cell.avaIcon.image = Avas[indexPath.row]
            }
            
            if Last_IDs.contains(IDs[indexPath.row]) == false && Last_IDs.count != 0{
                cell.designableView.backgroundColor = UIColor(red: 1, green: 0.9373, blue: 0.698, alpha: 1.0)
            }
            else{
                cell.designableView.backgroundColor = UIColor.white
            }
        }
        
        
        if indexPath.row == self.Names.count-1{
            self.ActivityIndicator.isHidden = true
            self.ActivityIndicator.stopAnimating()
            self.mainTableView.isHidden = false
        }
        
        
        // Configure the cell’s contents.
        return cell
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
//        let location = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        
        self.lat = locValue.latitude
        self.long = locValue.longitude
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: Notification.Name("RefreshMS"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Last_IDs = IDs
        Names = []
        Prices = []
        Specialty = []
        Radius = []
        Comments = []
        Locations = []
        Lats = []
        Lngs = []
        IDs = []
        Distan = []
        Durat = []
        CustomersID = []
        orderImages = [[String]]()
        phoneNumbers = []
        Avas = []
        
        self.ActivityIndicator.isHidden = false
        self.ActivityIndicator.startAnimating()
        
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        
        let defaults = UserDefaults.standard
        let value = defaults.bool(forKey: "isCourier")
        

        if Reachability.isConnectedToNetwork() == true {

            let isRegister = defaults.string(forKey: "isRegister")
            let myLat = defaults.string(forKey: "MyLat")
            let myLong = defaults.string(forKey: "MyLong")
            if isRegister == "true" && myLat != nil && myLong != nil{
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/users/change/city/")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                let postString = "lat=" + myLat! + "&lng=" + myLong!
                request.httpBody = postString.data(using: .utf8)
                //Get response
                let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                    do{
                        if response != nil{
                            if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                                let status = json["status"] as! String
                                DispatchQueue.main.async {
                                    if status == "ok"{
                                        print("OK! <Change City>")
                                    }
                                }
                            }
                            else{
                                print("Error <Change City>")
                            }
                        }
                        else{
                            print("Error <Change City>")
                        }
                    }
                    catch{
                        print("Error <Change City>")
                    }
                })
                task.resume()
            }
            
            if (value == true){
                let defaults = UserDefaults.standard
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/maps/order/")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                request.httpMethod = "GET"
                //Get response
                let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                    do{
                        if response != nil{
                            if (try JSONSerialization.jsonObject(with: data!, options: []) as? [NSDictionary]) != nil {
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [NSDictionary]
                                DispatchQueue.main.async {
                                    for i in json{
                                        let sender = i["sender"] as! NSDictionary
                                        let orderImgs = i["order_img"] as! [NSDictionary]
                                        var arr = [String]()
                                        if orderImgs.count == 0{
                                            arr.append("nil")
                                            arr.append("nil")
                                            arr.append("nil")
                                        }
                                        if orderImgs.count == 1{
                                            for i in orderImgs{
                                                arr.append(i["image"] as! String)
                                            }
                                            arr.append("nil")
                                            arr.append("nil")
                                        }
                                        else if orderImgs.count == 2{
                                            for i in orderImgs{
                                                arr.append(i["image"] as! String)
                                            }
                                            arr.append("nil")
                                        }
                                        else{
                                            for i in orderImgs{
                                                arr.append(i["image"] as! String)
                                            }
                                        }
                                        
                                        self.orderImages.append(arr)
                                        
                                        self.Names.append(sender["nickname"] as! String)
                                        self.CustomersID.append(String(sender["id"] as! Int))
                                        self.Specialty.append("Customer")
                                        self.Prices.append(i["price"] as! String)
                                        self.Comments.append(i["comment"] as! String)
                                        self.Locations.append(i["a_name"] as! String)
                                        self.Lats.append(i["a_lat"] as! String)
                                        self.Lngs.append(i["a_long"] as! String)
                                        self.IDs.append(String(i["id"] as! Int))
                                        self.Distan.append(i["distance_text"] as! String)
                                        self.Durat.append(i["duration_text"] as! String)
                                        self.phoneNumbers.append(sender["phone"] as! String)
                                        let urlAva = sender["avatar"] as! String
                                        let loadUrlAva = URL(string: "https://back.fix-up.org/" + urlAva)!
                                        
                                        if let data = try? Data(contentsOf: loadUrlAva) {
                                            if let image = UIImage(data: data) {
                                                self.Avas.append(image)
                                            }
                                            else{
                                                self.Avas.append(UIImage(named: "profile-ava.png")!)
                                            }
                                        }
                                        else{
                                            self.Avas.append(UIImage(named: "profile-ava.png")!)
                                        }
                                        
                                        if sender["avatar"] != nil{
                                            self.Avatars.append(sender["avatar"] as! String)
                                        }
                                        else{
                                            self.Avatars.append("Nil")
                                        }
                                    }
                                    self.mainTableView.reloadData()
                                    self.ActivityIndicator.isHidden = true
                                    self.ActivityIndicator.stopAnimating()
                                    self.mainTableView.isHidden = false
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
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        if (value == true){
            self.timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.sendLoc), userInfo: nil, repeats: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        orderTimer.invalidate()
    }
    
    @objc func getOrders(){
        Last_IDs = IDs
        Names = []
        Prices = []
        Specialty = []
        Radius = []
        Comments = []
        Locations = []
        Lats = []
        Lngs = []
        IDs = []
        Distan = []
        Durat = []
        CustomersID = []
        orderImages = [[String]]()
        phoneNumbers = []
        

        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            let value = defaults.bool(forKey: "isCourier")
            if (value == true){
                let defaults = UserDefaults.standard
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/maps/order/")!
                var request = URLRequest(url: url)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                request.httpMethod = "GET"
                //Get response
                let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
                    do{
                        if response != nil{
                            if (try JSONSerialization.jsonObject(with: data!, options: []) as? [NSDictionary]) != nil {
                                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [NSDictionary]
                                DispatchQueue.main.async {
                                    for i in json{
                                        let sender = i["sender"] as! NSDictionary
                                        let orderImgs = i["order_img"] as! [NSDictionary]
                                        var arr = [String]()
                                        if orderImgs.count == 0{
                                            arr.append("nil")
                                            arr.append("nil")
                                            arr.append("nil")
                                        }
                                        if orderImgs.count == 1{
                                            for i in orderImgs{
                                                arr.append(i["image"] as! String)
                                            }
                                            arr.append("nil")
                                            arr.append("nil")
                                        }
                                        else if orderImgs.count == 2{
                                            for i in orderImgs{
                                                arr.append(i["image"] as! String)
                                            }
                                            arr.append("nil")
                                        }
                                        else{
                                            for i in orderImgs{
                                                arr.append(i["image"] as! String)
                                            }
                                        }
                                        
                                        self.orderImages.append(arr)
                                        
                                        self.Names.append(sender["nickname"] as! String)
                                        self.CustomersID.append(String(sender["id"] as! Int))
                                        self.Specialty.append("Customer")
                                        self.Prices.append(i["price"] as! String)
                                        self.Comments.append(i["comment"] as! String)
                                        self.Locations.append(i["a_name"] as! String)
                                        self.Lats.append(i["a_lat"] as! String)
                                        self.Lngs.append(i["a_long"] as! String)
                                        self.IDs.append(String(i["id"] as! Int))
                                        self.Distan.append(i["distance_text"] as! String)
                                        self.Durat.append(i["duration_text"] as! String)
                                        self.phoneNumbers.append(sender["phone"] as! String)
                                        
                                        if sender["avatar"] != nil{
                                            self.Avatars.append(sender["avatar"] as! String)
                                        }
                                        else{
                                            self.Avatars.append("Nil")
                                        }
                                    }
                                    self.mainTableView.reloadData()
                                    self.ActivityIndicator.isHidden = true
                                    self.ActivityIndicator.stopAnimating()
                                    self.mainTableView.isHidden = false
                                    self.isFinish = 0

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
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func sendLoc(){
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "Token")
        let url = URL(string: "https://back.fix-up.org/maps/send_point")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        let postString = "lat=" + String(self.lat) + "&lng=" + String(self.long)
        request.httpBody = postString.data(using: .utf8)
        //Get response
        let task = URLSession.shared.dataTask(with: request, completionHandler:{(data, response, error) in
            do{
                if response != nil{
                    if (try JSONSerialization.jsonObject(with: data!, options: []) as? [String:AnyObject]) != nil{
                        let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String : AnyObject]
                        let status = json["status"] as! String
                        DispatchQueue.main.async {
                            if status == "created"{
                                print("OK <Send Location>")
                            }
                        }
                    }
                }
                else{
                    print("Error <Change City>")
                }
            }
            catch{
                print("Error <Change City>")
            }
        })
        task.resume()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let defaults = UserDefaults.standard
        defaults.set(String(indexPath.row), forKey: "CurrentID")
        defaults.set(self.Names[indexPath.row], forKey: "CurrentName")
        defaults.set(self.Prices[indexPath.row], forKey: "CurrentPrice")
        defaults.set(self.Specialty[indexPath.row], forKey: "CurrentSpecialty")
        defaults.set(self.Distan[indexPath.row], forKey: "CurrentRadius")
        defaults.set(self.Comments[indexPath.row], forKey: "CurrentComment")
        defaults.set(self.Locations[indexPath.row], forKey: "CurrentLocation")
        defaults.set(self.Lats[indexPath.row], forKey: "CurrentLat")
        defaults.set(self.Lngs[indexPath.row], forKey: "CurrentLng")
        defaults.set(self.IDs[indexPath.row], forKey: "CurrentOrderID")
        defaults.set(self.CustomersID[indexPath.row], forKey: "userInfoID")
        defaults.set(self.Avatars[indexPath.row], forKey: "CurrentAvatar")
        defaults.set(self.phoneNumbers[indexPath.row], forKey: "CurrentPhoneNumber")
        
        defaults.set(self.orderImages[indexPath.row][0], forKey: "orderImg1")
        defaults.set(self.orderImages[indexPath.row][1], forKey: "orderImg2")
        defaults.set(self.orderImages[indexPath.row][2], forKey: "orderImg3")
        
        defaults.set(false, forKey: "isCustomerView")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MapViewController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
                
    }
    
     @objc func refresh (notification: NSNotification){
        if isFinish == 0 {
            isFinish = 1
            self.mainTableView.isHidden = true
            self.ActivityIndicator.isHidden = false
            self.ActivityIndicator.startAnimating()
            getOrders()
        }
    }
}
