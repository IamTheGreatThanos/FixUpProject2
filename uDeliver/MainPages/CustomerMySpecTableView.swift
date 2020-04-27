import UIKit
import Foundation

class CustomerMySpecTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let Specialty = ["Deliver", "Medic", "Electric",]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Specialty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CMScell", for: indexPath) as! CustomerMySpecTableViewCell
        
        // Configure the cell’s contents.
         cell.SpecialtyName.text = Specialty[indexPath.row]
         cell.SpecialtyIcon.image = UIImage(named: Specialty[indexPath.row] + ".png")
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
