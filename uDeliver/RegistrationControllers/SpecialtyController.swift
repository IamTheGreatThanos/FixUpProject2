import UIKit
import Foundation

class SpecialtyController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    
    let Specialty = ["Deliver", "Medic", "Electric",]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewWillAppear(animated)
        
        mainTableView.backgroundView = UIImageView(image: UIImage(named: "TableView_BG.jpg"))
    }
    
    @IBAction func nextButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
        self.present(viewController, animated: true)
        
        let defaults = UserDefaults.standard
        defaults.set(false, forKey: "isCourier")
    }
    
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Specialty.count
    }

    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfSpecialty", for: indexPath) as! SpecialtyTableViewCell
       
       // Configure the cell’s contents.
        cell.SpecialtyName.text = Specialty[indexPath.row]
        cell.SpecialtyIcon.image = UIImage(named: Specialty[indexPath.row] + ".png")
           
       return cell
    }
    
}
