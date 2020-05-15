import UIKit
import Foundation

class CustomerMySpecTableView: UIViewController {
    
    var selectedR = 0
    
    var Specialty = ["Доставка", "Спецтехника", "Строительство", "Сервис и быт", "Красота",
    "Электроника", "IT и фриланис", "Образование", "Медицина", "Автосервис",
    "Культура и искусство", "Юриспруденция", "Финансы", "Сельское хозяйство",
    "Туризм и спорт", "Другие"]
    
    var Specialty_into = ["Курьер, трезвый водитель, грузчик, перевозка, переезд, канцелярия, почтальон и т.д",
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func selectedSpec(ID:Int){
        let defaults = UserDefaults.standard
        defaults.set(Specialty[ID], forKey: "CurrentOrderSpecTitle")
        defaults.set(Specialty_into[ID], forKey: "CurrentOrderSpecDesc")
        
        self.selectedR = ID
        defaults.set(self.selectedR, forKey: "SpecialtyId")
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"OrderController")
        self.navigationController?.pushViewController(viewController,
        animated: true)
    }
    
    
    @IBAction func button1Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 0)
    }
    
    @IBAction func button2Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 1)
    }
    
    @IBAction func button3Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 2)
    }
    
    @IBAction func button4Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 3)
    }
    
    @IBAction func button5Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 4)
    }
    
    @IBAction func button6Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 5)
    }
    
    @IBAction func button7Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 6)
    }
    
    @IBAction func button8Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 7)
    }
    
    @IBAction func button9Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 8)
    }
    
    @IBAction func button10Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 9)
    }
    
    @IBAction func button11Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 10)
    }
    
    @IBAction func button12Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 11)
    }
    
    @IBAction func button13Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 12)
    }
    
    @IBAction func button14Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 13)
    }
    
    @IBAction func button15Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 14)
    }
    
    @IBAction func button16Tapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = UIColor(red: 0.9843, green: 0.2431, blue: 0.2471, alpha: 0.8)
        })
        UIView.animate(withDuration: 0.5, animations: {
            sender.backgroundColor = .none
        })
        selectedSpec(ID: 15)
    }
    
}
