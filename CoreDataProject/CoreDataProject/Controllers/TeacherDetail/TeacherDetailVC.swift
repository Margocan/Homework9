

import UIKit
import CoreData

final class TeacherDetailVC: UIViewController {
    
    @IBOutlet weak private var surnameLabel: UILabel!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    
    var selectedTeacher: TeacherModel?
    var studentArray: [StudentModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureUI()
        fetch()
    }
    
    func configureUI() {
        guard let selectedTeacher else { return }
        surnameLabel.text = selectedTeacher.surname
        nameLabel.text = selectedTeacher.name
    }
}

private extension TeacherDetailVC {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let infoCellName = String(describing: InfoCell.self)
        let infoCellNib = UINib(nibName: infoCellName, bundle: .main)
        tableView.register(infoCellNib, forCellReuseIdentifier: infoCellName)
    }
    
    func fetch() {
        studentArray.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Students")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            for result in results as! [NSManagedObject] {
                if let name = result.value(forKey: "name") as? String,
                   let id = result.value(forKey: "id") as? UUID,
                   let age = result.value(forKey: "age") as? String,
                   let teacher = result.value(forKey: "teacher") as? String,
                   let teacherId = result.value(forKey: "teacherId") as? UUID {
                    if teacherId == selectedTeacher?.id {
                        self.studentArray.append(.init(name: name, age: age, id: id, teacher: teacher, teacherId: teacherId))
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } catch {
            print("Fetch request has failed.")
        }
    }
}

extension TeacherDetailVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoCell.self), for: indexPath) as? InfoCell {
            cell.configureCell(firstLabel: studentArray[indexPath.row].name, secondLabel: studentArray[indexPath.row].age)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailVC()
        detailVC.model = studentArray[indexPath.row]
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
