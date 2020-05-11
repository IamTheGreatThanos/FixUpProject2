import UIKit
import Foundation

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mainTableView: UITableView!
    //@IBOutlet weak var avatarImage: UIImageView!
    
    var Names = [String]()
    var Prices = [String]()
    var Specialty = [String]()
    var Comments = [String]()
    var Locations = [String]()
    var Lats = [String]()
    var Lngs = [String]()
    var IDs = [String]()
    var Status = [String]()
    
    var role = "0"

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Names.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Hcell", for: indexPath) as! HistoryControllerTableViewCell
        
        cell.nameLabel.text = Names[indexPath.row]
        cell.priceLabel.text = Prices[indexPath.row] + " ₸"
        cell.specialtyLabel.text = Specialty[indexPath.row]
        cell.commentLabel.text = Comments[indexPath.row]
        cell.locationLabel.text = Locations[indexPath.row]
        cell.statusLabel.text = Status[indexPath.row]
        
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
                let url = URL(string: "https://back.fix-up.org/maps/history/" + role)!
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
                                        self.Names.append(sender["nickname"] as! String)
                                        if defaults.bool(forKey: "isCourier") == true{
                                            self.Specialty.append("Заказчик")
                                        }
                                        else{
                                            self.Specialty.append("Специалист")
                                        }
                                        self.Prices.append(i["price"] as! String)
                                        self.Comments.append(i["comment"] as! String)
                                        self.Locations.append(i["a_name"] as! String)
                                        self.Lats.append(i["a_lat"] as! String)
                                        self.Lngs.append(i["a_long"] as! String)
                                        self.IDs.append(String(i["id"] as! Int))
                                        if i["is_canceled"] as! Bool == true{
                                            self.Status.append("Завершено")
                                        }
                                        else{
                                            self.Status.append("Отменено")
                                        }
                                    }
                                    self.mainTableView.reloadData()
                                    self.ActivityIndicator.isHidden = true
                                    self.ActivityIndicator.stopAnimating()
                                }
                               /* if defaults.url(forKey: "MyAvatar") != nil{
                                                                           self.avatarImage.load(url: defaults.url(forKey: "MyAvatar")!)
                                                                       } */
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
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
        self.present(viewController, animated: true)
    }
}
