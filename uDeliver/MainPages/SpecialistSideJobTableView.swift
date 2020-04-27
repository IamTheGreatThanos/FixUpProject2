import UIKit
import Foundation

class SpecialistSideJobTableView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SSJcell", for: indexPath) as! SpecialistSideJobTableViewCell
        
        cell.nameLabel.text = "John Smith"
        
        // Configure the cell’s contents.
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
