import UIKit
import Foundation

class SpecialtyController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var currentCellID: Int = 0
    
    
    let Specialty = ["Доставка", "Спецтехника", "Строительство", "Сервис и быт", "Красота",
    "Электроника", "IT и фриланис", "Образование", "Медицина", "Автосервис",
    "Культура и искусство", "Юриспруденция", "Финансы", "Сельское хозяйство",
    "Туризм и спорт", "Другие"]
    
    let Specialty_into = ["Курьер, такси, трезвый водитель, грузчик, перевозка, переезд, канцелярия, пачтальон и т.д",
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        mainTableView.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.93, alpha: 1.0)
    }
    
    
    // Return the number of rows for the table.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Specialty.count
    }

    // Provide a cell object for each row.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       // Fetch a cell of the appropriate type.
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellOfSpecialty", for: indexPath) as! SpecialtyTableViewCell
        
        cell.SpecialtyView.backgroundColor = UIColor.white
        cell.SpecialtyName.textColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 1.0)
        cell.SpecialtyIcon.image = UIImage(named: "Card" + String(indexPath.row) + ".png")
       
       // Configure the cell’s contents.
        cell.SpecialtyName.text = Specialty[indexPath.row]
        cell.SpecialtyInto.text = Specialty_into[indexPath.row]
        cell.backgroundColor = .clear
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentCell = tableView.cellForRow(at: indexPath) as! SpecialtyTableViewCell
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.SpecialtyView.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 1.0)
        })
        UIView.animate(withDuration: 0.5, animations: {
            currentCell.SpecialtyView.backgroundColor = UIColor.white
        })
        
        if Reachability.isConnectedToNetwork() == true {
            let defaults = UserDefaults.standard
            let token = defaults.string(forKey: "Token")
            let url = URL(string: "https://back.fix-up.org/role/add")!
            var request = URLRequest(url: url)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("Token " + token!, forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            let postString = "spec=" + String(indexPath.row+1)
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
                                    if defaults.bool(forKey: "changeByProfile") != nil {
                                        if defaults.bool(forKey: "changeByProfile") == true{
                                            self.navigationController?.popViewController(animated: true)
                                        }
                                        else{
                                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                            let viewController = storyboard.instantiateViewController(withIdentifier :"SWRevealViewController")
                                            self.present(viewController, animated: true)
                                            
                                            defaults.set(true, forKey: "isCourier")
                                        }
                                    }
                                    defaults.set(true, forKey: "isRegisterAsSpecialist")
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
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
