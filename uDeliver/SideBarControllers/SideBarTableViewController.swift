import UIKit
import Foundation


class SideBarTableViewController: UITableViewController {
    
    
    @IBOutlet weak var BeCourierOutlet: UISwitch!
    
    @IBOutlet weak var avaImage: UIImageView!
    @IBOutlet weak var RatingLabel: UILabel!
    @IBOutlet weak var SpecialtyLabel: UILabel!
    @IBOutlet weak var NickLabel: UILabel!
    var isRegister = ""
    @IBOutlet weak var dislikeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let defaults = UserDefaults.standard
        let value = defaults.bool(forKey: "isCourier")
        let isRegister = defaults.string(forKey: "isRegister")
        self.automaticallyAdjustsScrollViewInsets = false
        
        if isRegister == "true"{
            if defaults.string(forKey: "MyName") != nil{
                NickLabel.text = defaults.string(forKey: "MyName")
            }
            else{
                NickLabel.text = "Пользователь"
            }
            if defaults.string(forKey: "MySpec") != nil{
                SpecialtyLabel.text = defaults.string(forKey: "MySpec")
            }
            if defaults.string(forKey: "MyLike") != nil{
                RatingLabel.text = defaults.string(forKey: "MyLike")
            }
            if defaults.string(forKey: "MyDislike") != nil{
                dislikeLabel.text = defaults.string(forKey: "MyDislike")
            }
            if defaults.url(forKey: "MyAvatar") != nil{
                avaImage.load(url: defaults.url(forKey: "MyAvatar")!)
            }
        }
        
        if (value == true){
            BeCourierOutlet.setOn(true, animated: false)
        }
        
    }
    
    @IBAction func BeCourier(_ sender: UISwitch) {
        let defaults = UserDefaults.standard
        let isRegisterAsSpecialist = defaults.bool(forKey: "isRegisterAsSpecialist")
        let isRegister = defaults.string(forKey: "isRegister")
        let value = sender.isOn
        if (value == false){
            let defaults = UserDefaults.standard
            defaults.set(false, forKey: "isCourier")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
            self.present(viewController, animated: true)
        }
        else{
            if isRegister == "true"{
                if isRegisterAsSpecialist == true{
                    if defaults.bool(forKey: "isCurrentOrder") == false{
                        defaults.set(true, forKey: "isCourier")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
                        self.present(viewController, animated: true)
                    }
                    else{
                        let alert = UIAlertController(title: "Внимание", message: "Ваш заказ будет отменен, продолжить?", preferredStyle: .alert)
                        
                        alert.addAction(UIAlertAction(title: "Да", style: .default, handler: { action in
                            defaults.set(false,forKey: "isCurrentOrder")
                            defaults.removeObject(forKey: "MyOrder")
                            defaults.set(true, forKey: "isCourier")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
                            self.present(viewController, animated: true)
                        }))
                        alert.addAction(UIAlertAction(title: "Нет", style: .cancel, handler: { action in
                            self.BeCourierOutlet.setOn(false, animated: true)
                        }))
                        
                        self.present(alert, animated: true)
                    }
                    
                }
                else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let viewController = storyboard.instantiateViewController(withIdentifier :"SpecialtyController")
                    self.present(viewController, animated: true)
                }
            }
            else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier :"PhoneController")
                self.present(viewController, animated: true)
            }
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 0) {
            let defaults = UserDefaults.standard
            let value = defaults.bool(forKey: "isCourier")
            
            if defaults.string(forKey: "isRegister") != nil{
                self.isRegister = defaults.string(forKey: "isRegister")!
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = storyboard.instantiateViewController(withIdentifier :"NavigationControllerProfile")
                self.present(viewController, animated: true)
                let defaults = UserDefaults.standard
                defaults.set(false, forKey: "asUserInfo")
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
        
    }
    
    @IBAction func firstSNButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://fix-up.org") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func secondSNButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://fix-up.org") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    @IBAction func thirdSNButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "https://fix-up.org") else {
            return
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func openInstagram(sender: UIButton){
            let instNickname =  "instagram"
            let appURL = URL(string: "https://instagram.com/\(instNickname)")!
            if UIApplication.shared.canOpenURL(appURL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(appURL)
                }
            }
    }
    /*
     @IBAction func openWhatsApp(sender: UIButton){
         let phoneNumber =  "+77005050908" // you need to change this number
         let appURL = URL(string: "https://api.whatsapp.com/send?phone=\(phoneNumber)")!
         if UIApplication.shared.canOpenURL(appURL) {
             if #available(iOS 10.0, *) {
                 UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
             }
             else {
                 UIApplication.shared.openURL(appURL)
             }
         } else {
             let phoneNumber =  "+77005050908" // you need to change this number
             let appURL = URL(string: "https://wa.me/\(phoneNumber)")!
             if UIApplication.shared.canOpenURL(appURL) {
                 if #available(iOS 10.0, *) {
                     UIApplication.shared.open(appURL, options: [:], completionHandler: nil)
                 } else {
                     UIApplication.shared.openURL(appURL)
                 }
             }
         }
     }
     */
    
      @IBAction func openWhatsApp(sender: UIButton){
              var fullMob = "+77005050908"
              fullMob = fullMob.replacingOccurrences(of: " ", with: "")
              fullMob = fullMob.replacingOccurrences(of: "+", with: "")
              fullMob = fullMob.replacingOccurrences(of: "-", with: "")
              let urlWhats = "whatsapp://send?phone=\(fullMob)"
              
              if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                  if let whatsappURL = NSURL(string: urlString) {
                      if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                          UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (Bool) in
                          })
                      }
                  }
              }
          
      }
}
