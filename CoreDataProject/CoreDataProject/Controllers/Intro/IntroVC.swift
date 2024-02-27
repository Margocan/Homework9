
enum SelectedTypeEnum: String, CaseIterable{
    case student = "Students"
    case teacher = "Teachers"
}

import UIKit

final class IntroVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func studentsDidTapped(_ sender: Any) {
        let listVC = ListVC()
        listVC.selectedType = .student
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
    @IBAction func teachersDidTapped(_ sender: Any) {
        let listVC = ListVC()
        listVC.selectedType = .teacher
        self.navigationController?.pushViewController(listVC, animated: true)
    }
    
}
