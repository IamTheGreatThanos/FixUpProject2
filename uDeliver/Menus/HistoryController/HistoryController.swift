import UIKit
import Foundation

class HistoryController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let Date = ["26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 ","26 September 2019. 22:54 "]
    let From = ["Abaya 35","Abaya 35","Abaya 35","Abaya 35","Abaya 35","Abaya 35","Abaya 35","Abaya 35","Abaya 35","Abaya 35"]
    let To = ["Satbayeva 4","Satbayeva 4","Satbayeva 4","Satbayeva 4","Satbayeva 4","Satbayeva 4","Satbayeva 4","Satbayeva 4","Satbayeva 4","Satbayeva 4","Satbayeva 4"]
//    let Comment = ["Comment to deliver","Comment to deliver","Comment to deliver","Comment to deliver","Comment to deliver","Comment to deliver","Comment to deliver","Comment to deliver","Comment to deliver","Comment to deliver"]
    let Status = ["Canceled","Canceled","Canceled","Canceled","Canceled","Canceled","Canceled","Canceled","Canceled","Canceled",]
    let DistancePrice = ["$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg","$100 ~800m Kaspi.kz 20kg"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (Status.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HistoryControllerTableViewCell
        
        cell.DateLabel.text = Date[indexPath.row]
        cell.FromLabel.text = From[indexPath.row]
        cell.ToLabel.text = To[indexPath.row]
//        cell.CommentLabel.text = Comment[indexPath.row]
        cell.StatusLabel.text = Status[indexPath.row]
        cell.DistancePriceLabel.text = DistancePrice[indexPath.row]
        
        return(cell)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
        self.present(viewController, animated: true)
    }
}
