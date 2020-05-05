import UIKit
import Foundation
import AVFoundation

class PortfolioController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var mainTableView: UITableView!
    var PortfolioImages = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() == true {
            getPortfolioImages()
        }
        else{
            let alert = UIAlertController(title: "Извините", message: "Ошибка соединения с интернетом...", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        activityIndicator.startAnimating()
    }
    
    
    func getPortfolioImages(){
        PortfolioImages = [UIImage]()
        let defaults = UserDefaults.standard
        let asUserInfo = defaults.bool(forKey: "asUserInfo")
        
        if asUserInfo == true{
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
                            let profileImgs = json["profile"] as! [NSDictionary]
                            DispatchQueue.main.async {
                                for i in profileImgs{
                                    let dataDecoded:NSData = NSData(base64Encoded: i["image_base64"] as! String, options: NSData.Base64DecodingOptions(rawValue: 0))!
                                    let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
                                    self.PortfolioImages.append(decodedimage)
                                }
                                print("OK <Portfolio controller>")
                                self.mainTableView.reloadData()
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
    
    
    //MARK: - Table View Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as! MainTableViewCell
        cell.collectionView.reloadData()
        
        return cell
    }
    
    
    //MARK: - Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PortfolioImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InsideCollectionViewCell", for: indexPath) as! InsideCollectionViewCell
        
        cell.imageView.image =  self.PortfolioImages[indexPath.row]
        
        if indexPath.row + 1 >= PortfolioImages.count{
            activityIndicator.stopAnimating()
            activityIndicator.alpha = 0.0
            alphaView.alpha = 0.0
        }
        
//        let screenSize: CGRect = UIScreen.main.bounds
//        cell.imageView.frame = CGRect(x: 0, y: 0, width: screenSize.width * 0.33, height: screenSize.width * 0.33)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.addImageViewWithImage(image: self.PortfolioImages[indexPath.row])
    }
    
    @objc func removeImage() {
        let window = UIApplication.shared.keyWindow!
        let imageView = (window.viewWithTag(100)! as! UIImageView)
        imageView.removeFromSuperview()
    }
    
    func addImageViewWithImage(image: UIImage) {
        let window = UIApplication.shared.keyWindow!

        let imageView = UIImageView(frame: window.frame)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.black
        imageView.image = image
        imageView.isUserInteractionEnabled = true
        imageView.tag = 100
        
        let dismissTap = UITapGestureRecognizer(target: self, action: #selector(self.removeImage))
        dismissTap.numberOfTapsRequired = 1
        imageView.addGestureRecognizer(dismissTap)
        
        window.addSubview(imageView)
    }
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
//    {
//            // In this function is the code you must implement to your code project if you want to change size of Collection view
//        let width  = (UIScreen.main.bounds.width-20)/3
//            return CGSize(width: width, height: width)
//    }
    
}
