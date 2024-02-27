

import UIKit
import CoreData

protocol SelectTeacherProtocol: AnyObject {
    func didTapped(teacher: TeacherModel)
}

final class ListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedType: SelectedTypeEnum = .student
    var allowToSelect: Bool = false
    
    var studentArray: [StudentModel] = []
    var teacherArray: [TeacherModel] = []
    weak var delegate: SelectTeacherProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addBarButton()
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetch()
    }
}
@objc
private extension ListVC {
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        let infoCellName = String(describing: InfoCell.self)
        let infoCellNib = UINib(nibName: infoCellName, bundle: .main)
        tableView.register(infoCellNib, forCellReuseIdentifier: infoCellName)
    }
    
    func fetch() {
        
        studentArray.removeAll()
        teacherArray.removeAll()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: selectedType.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(fetchRequest)
            switch selectedType {
            case .student:
                fetchResult(result)
            case .teacher:
                fetchResult(result)
            }
        } catch {
            print("Fetch request has failed.")
        }
    }
    
    func fetchResult(_ results: [NSFetchRequestResult]) {
        for result in results as! [NSManagedObject] {
            switch selectedType {
            case .student:
                if let name = result.value(forKey: "name") as? String,
                   let id = result.value(forKey: "id") as? UUID,
                   let age = result.value(forKey: "age") as? String,
                   let teacher = result.value(forKey: "teacher") as? String,
                   let teacherId = result.value(forKey: "teacherId") as? UUID {
                    self.studentArray.append(.init(name: name, age: age, id: id, teacher: teacher, teacherId: teacherId))
                }
            case .teacher:
                if let name = result.value(forKey: "name") as? String,
                   let id = result.value(forKey: "id") as? UUID,
                   let surname = result.value(forKey: "surname") as? String  {
                    self.teacherArray.append(.init(name: name, surname: surname, id: id))
                }
            }
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func addBarButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(addDidTapped))
    }
    
    func addDidTapped() {
        switch selectedType {
        case .student:
            let addVC = AddVC()
            addVC.selectedType = .student
            self.navigationController?.pushViewController(addVC, animated: true)
        case .teacher:
            let addVC = AddVC()
            addVC.selectedType = .teacher
            self.navigationController?.pushViewController(addVC, animated: true)
        }
    }
}

extension ListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedType {
        case .student:
            return studentArray.count
        case .teacher:
            return teacherArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: InfoCell.self), for: indexPath) as? InfoCell {
            switch selectedType {
            case .student:
                cell.configureCell(firstLabel: studentArray[indexPath.row].name, secondLabel: studentArray[indexPath.row].age)
            case .teacher:
                cell.configureCell(firstLabel: teacherArray[indexPath.row].name, secondLabel: teacherArray[indexPath.row].surname)
            }
            return cell
        }

        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if allowToSelect {
            delegate?.didTapped(teacher: teacherArray[indexPath.row])
            self.navigationController?.popViewController(animated: true)
            return
        }
        switch selectedType {
        case .student:
            let detailVC = DetailVC()
            detailVC.model = studentArray[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        case .teacher:
            let detailVC = TeacherDetailVC()
            detailVC.selectedTeacher = teacherArray[indexPath.row]
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

struct StudentModel {
    let name: String?
    let age: String?
    let id: UUID?
    let teacher: String?
    let teacherId: UUID?
    
    init(name: String?, age: String?, id: UUID?, teacher: String?, teacherId: UUID?) {
        self.name = name
        self.age = age
        self.id = id
        self.teacher = teacher
        self.teacherId = teacherId
    }
}

struct TeacherModel {
    let name: String?
    let surname: String?
    let id: UUID?
    
    init(name: String?, surname: String?, id: UUID?) {
        self.name = name
        self.surname = surname
        self.id = id
    }
}
