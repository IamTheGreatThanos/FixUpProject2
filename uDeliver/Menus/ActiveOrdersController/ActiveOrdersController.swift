import UIKit
import Foundation

class ActiveOrdersController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainTableView: UITableView!
    
    var Names = [String]()
    var Prices = [String]()
    var Specialty = [String]()
    var Comments = [String]()
    var Locations = [String]()
    var Lats = [String]()
    var Lngs = [String]()
    var IDs = [String]()
    var Distan = [String]()
    var Durat = [String]()
    var CustomersID = [String]()
    var SpecialistsID = [String]()
    var Avatars = [String]()
    var orderImages = [[String]]()
    var phoneNumbers = [String]()
    
    var role = "0"
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (Names.count)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveOrdersCell", for: indexPath) as! ActiveOrdersTableViewCell
        
        cell.nameLabel.text = Names[indexPath.row]
        cell.priceLabel.text = Prices[indexPath.row] + " тг"
        cell.specialtyLabel.text = Specialty[indexPath.row]
        cell.radiusLabel.text = Distan[indexPath.row]
        cell.commentLabel.text = Comments[indexPath.row]
        cell.locationLabel.text = Locations[indexPath.row]
        cell.timeLabel.text = Durat[indexPath.row]
        
        
        if indexPath.row == self.Names.count-1{
            self.ActivityIndicator.isHidden = true
            self.ActivityIndicator.stopAnimating()
        }
        
        return(cell)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ActivityIndicator.isHidden = false
        self.ActivityIndicator.startAnimating()
        
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "isCourier") == true{
            role = "1"
        }
        if Reachability.isConnectedToNetwork() == true {
            if defaults.string(forKey: "isRegister") == "true"{
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/maps/active/" + role)!
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
                                        let sender = i["sender"] as! NSDictionary
                                        let worker = i["worker"] as! NSDictionary
                                        
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
                                        if defaults.bool(forKey: "isCourier") == true{
                                            self.Names.append(sender["nickname"] as! String)
                                        }
                                        else{
                                            self.Names.append(worker["nickname"] as! String)
                                        }
                                        self.CustomersID.append(String(sender["id"] as! Int))
                                        self.SpecialistsID.append(String(worker["id"] as! Int))
                                        self.Prices.append(i["price"] as! String)
                                        self.Comments.append(i["comment"] as! String)
                                        self.Locations.append(i["a_name"] as! String)
                                        self.Lats.append(i["a_lat"] as! String)
                                        self.Lngs.append(i["a_long"] as! String)
                                        self.IDs.append(String(i["id"] as! Int))
                                        self.Distan.append(i["distance_text"] as! String)
                                        self.Durat.append(i["duration_text"] as! String)
                                        
                                        if self.role == "0"{
                                            self.phoneNumbers.append(worker["phone"] as! String)
                                            if worker["avatar"] != nil{
                                                self.Avatars.append(worker["avatar"] as! String)
                                            }
                                            else{
                                                self.Avatars.append("Nil")
                                            }
                                            self.Specialty.append("Специалист")
                                        }
                                        else{
                                            self.phoneNumbers.append(sender["phone"] as! String)
                                            if sender["avatar"] != nil{
                                                self.Avatars.append(sender["avatar"] as! String)
                                            }
                                            else{
                                                self.Avatars.append("Nil")
                                            }
                                            self.Specialty.append("Заказчик")
                                        }
                                        
                                    }
                                    self.mainTableView.reloadData()
                                    self.ActivityIndicator.isHidden = true
                                    self.ActivityIndicator.stopAnimating()
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
                let alert = UIAlertController(title: "Извините", message: "Вы не зарегистрированы!", preferredStyle: .alert)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
        self.present(viewController, animated: true)
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
        defaults.set(self.Avatars[indexPath.row], forKey: "CurrentAvatar")
        defaults.set(self.phoneNumbers[indexPath.row], forKey: "CurrentPhoneNumber")
        
        defaults.set(self.orderImages[indexPath.row][0], forKey: "orderImg1")
        defaults.set(self.orderImages[indexPath.row][1], forKey: "orderImg2")
        defaults.set(self.orderImages[indexPath.row][2], forKey: "orderImg3")
        
        defaults.set(false, forKey: "isCustomerView")
        defaults.set(true, forKey: "isActiveOrders")
        
        let value = defaults.bool(forKey: "isCourier")
        if value == true{
            defaults.set(self.CustomersID[indexPath.row], forKey: "userInfoID")
        }
        else{
            defaults.set(self.SpecialistsID[indexPath.row], forKey: "userInfoID")
        }
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MapViewController")
        self.navigationController?.pushViewController(viewController, animated: true)
                
    }
    
    
}
