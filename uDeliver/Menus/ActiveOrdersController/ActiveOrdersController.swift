import UIKit
import Foundation

class ActiveOrdersController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let Names = ["John Smith","John Smith","John Smith","John Smith",]
    let Transports = ["Transport: Track","Transport: Car","Transport: Bike","Transport: Bike",]
    let Checks = ["Checked Courier","Checked Courier","Checked Courier","Checked Courier",]
    let Ranks = ["4.9(1K)","4.4(3K)","4.0(10K)","5.0(100K)",]
    let Amounts = ["500tg","2500tg","450tg","200tg",]
    let Distances = ["200m","450m","2km","300m",]
    let Times = ["5 min","15 min","45 min","25 min",]
    let Clients = ["You're Client","You're Client","You're Client","You're Client",]
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (Names.count)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActiveOrdersCell", for: indexPath) as! ActiveOrdersTableViewCell
        
        cell.nameLabel.text = Names[indexPath.row]
        cell.transportLabel.text = Transports[indexPath.row]
        cell.checkedCourierLabel.text = Checks[indexPath.row]
        cell.rankLabel.text = Ranks[indexPath.row]
        cell.amountLabel.text = Amounts[indexPath.row]
        cell.distanceLabel.text = Distances[indexPath.row]
        cell.timeLabel.text = Times[indexPath.row]
        cell.clientLabel.text = Clients[indexPath.row]
        
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
