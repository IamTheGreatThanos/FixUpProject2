import UIKit
import Foundation


class ListOfSpecialistsController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    var Names = [String]()
    var Prices = [String]()
    var Specialty = [String]()
    var Likes = [String]()
    var Dislikes = [String]()
    var Comments = [String]()
    var Locations = [String]()
    var Lats = [String]()
    var Lngs = [String]()
    var WorkersId = [String]()
    var Avatars = [String]()
    var phoneNumbers = [String]()
    var Distan = [String]()
    var Durat = [String]()
    
    var timer = Timer()
    
    
    @IBOutlet weak var mainTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var loaderText: UILabel!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LOScell", for: indexPath) as! ListOfSpecialistsControllerCell
        
        cell.nameLabel.text = Names[indexPath.row]
        cell.priceLabel.text = Prices[indexPath.row] + " ₸"
        cell.likeLabel.text = Likes[indexPath.row]
        cell.dislikeLabel.text = Dislikes[indexPath.row]
        cell.commentLabel.text = Comments[indexPath.row]
        cell.locationLabel.text = Locations[indexPath.row]
        
        // Configure the cell’s contents.
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        defaults.set(true, forKey: "isValidateTimer")
        activityIndicator.startAnimating()
        
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Отмена", style: UIBarButtonItem.Style.bordered, target: self, action: #selector(ListOfSpecialistsController.back(sender:)))
        let closeButton = UIBarButtonItem(image: UIImage(named: "new_order"), style: UIBarButtonItem.Style.bordered, target: self, action: #selector(ListOfSpecialistsController.closeView(sender:)))
        
        self.navigationItem.leftBarButtonItem = newBackButton
        self.navigationItem.rightBarButtonItem = closeButton
        self.navigationItem.title = "Отклики"
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
//        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkList), userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(checkList), userInfo: nil, repeats: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func checkList(){
//        Names = []
//        Prices = []
//        Specialty = []
//        Likes = []
//        Dislikes = []
//        Comments = []
//        Locations = []
//        Lats = []
//        Lngs = []
//        WorkersId = []
//        Avatars = []
//        phoneNumbers = []
//        Distan = []
//        Durat = []
//        mainTableView.reloadData()
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            if defaults.bool(forKey: "isValidateTimer") != false && defaults.string(forKey: "MyOrder") != nil{
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/maps/get/" + defaults.string(forKey: "MyOrder")!+"/")!
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
                                        let sender = i["worker"] as! NSDictionary
                                        if self.phoneNumbers.contains(sender["phone"] as! String) == false{
                                            self.phoneNumbers.append(sender["phone"] as! String)
                                            self.Names.append(sender["nickname"] as! String)
                                            self.Specialty.append("Customer")
                                            self.Prices.append(String(i["price"] as! String))
                                            self.Likes.append(String(sender["likes"] as! Int))
                                            self.Dislikes.append(String(sender["dislikes"] as! Int))
                                            self.Comments.append(i["comment"] as! String)
                                            self.Locations.append(i["time"] as! String)
                                            self.Lats.append(i["lat"] as! String)
                                            self.Lngs.append(i["lng"] as! String)
                                            self.WorkersId.append(String(sender["id"] as! Int))
                                            self.Distan.append("1")
                                            self.Durat.append("1")
                                            if sender["avatar"] != nil{
                                                self.Avatars.append(sender["avatar"] as! String)
                                            }
                                            else{
                                                self.Avatars.append("Nil")
                                            }
                                        }
                                    }
                                    self.mainTableView.reloadData()
                                    if self.Names.count == 0{
                                        self.activityIndicator.isHidden = false
                                        self.loaderView.isHidden = false
                                        self.loaderText.isHidden = false
                                        self.activityIndicator.startAnimating()
                                    }
                                    else{
                                        self.activityIndicator.isHidden = true
                                        self.loaderView.isHidden = true
                                        self.loaderText.isHidden = true
                                        self.activityIndicator.stopAnimating()
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
                timer.invalidate()
                print("Timer is invalidated! <List Of Spec Controller>")
            }
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func back(sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Внимание", message: "Ваш заказ будет отменен, продолжить?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
            if Reachability.isConnectedToNetwork() == true {
                let defaults = UserDefaults.standard
                let token = defaults.string(forKey: "Token")
                let url = URL(string: "https://back.fix-up.org/maps/cancel/")
                var request = URLRequest(url: url!)
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
                request.httpMethod = "POST"
                let postString = "id=" + defaults.string(forKey: "MyOrder")!
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
                                        defaults.set(false,forKey: "isCurrentOrder")
                                        defaults.removeObject(forKey: "MyOrder")
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
        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
        }))
        
        self.present(alert, animated: true)
    }
    
    
    @objc func closeView(sender: UIBarButtonItem) {
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
        defaults.set(self.Likes[indexPath.row], forKey: "CurrentRating")
        defaults.set(self.Comments[indexPath.row], forKey: "CurrentComment")
        defaults.set(self.Locations[indexPath.row], forKey: "CurrentLocation")
        defaults.set(defaults.string(forKey: "ListOfSpecLat"), forKey: "CurrentLat")
        defaults.set(defaults.string(forKey: "ListOfSpecLng"), forKey: "CurrentLng")
        defaults.set(self.WorkersId[indexPath.row], forKey: "CurrentWorkerId")
        defaults.set(self.Avatars[indexPath.row], forKey: "CurrentAvatar")
        defaults.set(self.phoneNumbers[indexPath.row], forKey: "CurrentPhoneNumber")
        
        defaults.set(self.WorkersId[indexPath.row], forKey: "userInfoID")
        
        defaults.set(true, forKey: "isCustomerView")
        defaults.set(false, forKey: "isActiveOrders")
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"MapViewController")
        self.navigationController?.pushViewController(viewController,
        animated: true)   
    }
}
