

import UIKit
import CoreData

final class AddVC: UIViewController {
    
    @IBOutlet weak private var nameStackView: UIStackView!
    @IBOutlet weak private var nameTF: UITextField!
    
    @IBOutlet weak private var ageStackView: UIStackView!
    @IBOutlet weak private var ageTF: UITextField!
    
    @IBOutlet weak private var surnameStackView: UIStackView!
    @IBOutlet weak private var surnameTF: UITextField!
    
    @IBOutlet weak var chooseTeacherButton: UIButton!
    
    var selectedType: SelectedTypeEnum = .student
    var selectedTeacher: TeacherModel? {
        didSet {
            self.chooseTeacherButton.setTitle("\(selectedTeacher?.name ?? "") \(selectedTeacher?.surname ?? "")", for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    
    private func configureUI() {
        switch selectedType {
        case .student:
            surnameStackView.isHidden = true
            ageStackView.isHidden = false
            chooseTeacherButton.isHidden = false
        case .teacher:
            ageStackView.isHidden = true
            chooseTeacherButton.isHidden = true
            surnameStackView.isHidden = false
        }
    }
    
    private func doValidation() -> Bool {
        switch selectedType {
        case .student:
            return nameTF.text != nil && ageTF.text != nil && selectedTeacher != nil
        case .teacher:
            return nameTF.text != nil && surnameTF.text != nil
        }
    }
    @IBAction func chooseTeacherTapped(_ sender: Any) {
        let listVC = ListVC()
        listVC.selectedType = .teacher
        listVC.allowToSelect = true
        listVC.delegate = self
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let saveData = NSEntityDescription.insertNewObject(forEntityName: selectedType == .student ? "Students":"Teachers", into: context)
        
        guard doValidation() else {
            print("Validation error")
            return
        }
        
        switch selectedType {
        case .student:
            saveData.setValue(nameTF.text, forKey: "name")
            saveData.setValue(ageTF.text, forKey: "age")
            saveData.setValue(UUID(), forKey: "id")
            saveData.setValue("\(selectedTeacher?.name ?? "") \(selectedTeacher?.surname ?? "")", forKey: "teacher")
            saveData.setValue(selectedTeacher?.id, forKey: "teacherId")
        case .teacher:
            saveData.setValue(nameTF.text, forKey: "name")
            saveData.setValue(surnameTF.text, forKey: "surname")
            saveData.setValue(UUID(), forKey: "id")
        }
        
        do {
            try context.save()
            self.navigationController?.popViewController(animated: true)
            print("\(selectedType) succesfully saved.")
        } catch {
            print("Failure")
        }
    }
}

extension AddVC: SelectTeacherProtocol {
    func didTapped(teacher: TeacherModel) {
        self.selectedTeacher = teacher
    }
}
