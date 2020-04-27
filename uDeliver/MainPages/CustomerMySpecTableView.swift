import UIKit
import Foundation

class CustomerMySpecTableView: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var selectedR = 0
    @IBOutlet weak var mainTableView: UITableView!
    
    var currentCellID: Int = 0
    
    var Specialty = ["Доставка", "Спецтехника", "Строительство", "Сервис и быт", "Красота",
    "Электроника", "IT и фриланис", "Образование", "Медицина", "Автосервис",
    "Культура и искусство", "Юриспруденция", "Финансы", "Сельское хозяйство",
    "Туризм и спорт", "Другие"]
    
    var Specialty_into = ["Курьер, трезвый водитель, грузчик, перевозка, переезд, канцелярия, пачтальон и т.д",
    "Эвакуатор, экскаватор, трактор,квадроцикл, кран, бетономешалкаи т.д.",
    "Строитель, электрик, сантехник, моляр, плотник, кровельщик, каменщик, сварщик, дизайнер и т.д.",
    "Уборщица, дворник, няня, повар, сиделка, швея, обувщик, специалистпо химчистке и т.д.",
    "Парикмахер, визажист, мастер по маникюру, косметолог, эстетист, мастер татуажа и т.д.",
    "Специалисты по ремонту бытовойтехники, электронных и видео приборов и т.д.",
    "Программист, дизайнер, копирайтер, маркетолог, SMM-специалист, веб-мастер, переводчик и т.д.",
    "Преподаватель, педагог, репетитор, воспитатель, логопед, тьютор, автоинструктор и т.д.",
    "Врач, медсестра, иглотерапевт, психолог, мануальный терапевт, массажист, диетолог и т.д.",
    "Моторист, автоэлектрик, дизелист, мастер ходовой части, мастер кузовного ремонта и т.д.",
    "Художник, артист, тамада, танцор, модельер, аниматор, видео оператор, видео монтажер, певец и т.д.",
    "Адвокат, юрист-консультант, нотариус, медиатор, детектив, патентный поверенный и т.д.",
    "Бухгалтер, финансист, экономист, аудитор, ревизор, страховщик, оценщик, риелтор, маклер и т.д.",
    "Садовник, ландшафтный дизайнер, ветеринар, агроном, зоотехник, почвовед, агрохимик и т.д.",
    "Гид, визовый консультант, тренер, кедди, спарринг-партнер и т.д.",
    "Промоутер, расклейщик объявлений, астролог, рекламщик и т.д."]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Specialty.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CMScell", for: indexPath) as! CustomerMySpecTableViewCell
        
        cell.SpecialtyView.backgroundColor = UIColor.white
        cell.SpecialtyName.textColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 1.0)
        cell.SpecialtyInto.textColor = UIColor.darkGray
        cell.SpecialtyIcon.image = UIImage(named: "Card" + String(indexPath.row) + ".png")
        
        
        let defaults = UserDefaults.standard
        defaults.set(currentCellID, forKey: "OrderSpecialtyID")
        
        // Configure the cell’s contents.
        cell.SpecialtyName.text = Specialty[indexPath.row]
        cell.SpecialtyInto.text = Specialty_into[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
    
    
    private func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let defaults = UserDefaults.standard
        let indexPath = tableView.indexPathForSelectedRow
        self.selectedR = Int(indexPath!.row)
        defaults.set(self.selectedR, forKey: "SpecialtyId")
        self.mainTableView.reloadData()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainTableView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! CustomerMySpecTableViewCell
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.SpecialtyView.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 1.0)
        })
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.SpecialtyView.backgroundColor = UIColor.white
        })
        let defaults = UserDefaults.standard
        defaults.set(Specialty[indexPath.row], forKey: "CurrentOrderSpecTitle")
        defaults.set(Specialty_into[indexPath.row], forKey: "CurrentOrderSpecDesc")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"OrderController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
        
    }
}
