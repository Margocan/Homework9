

import UIKit

final class DetailVC: UIViewController {

    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var ageLabel: UILabel!
    @IBOutlet weak private var teacherLabel: UILabel!
    
    var model: StudentModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func configureUI() {
        guard let model else { return }
        self.nameLabel.text = model.name ?? ""
        self.ageLabel.text = model.age ?? ""
        self.teacherLabel.text = model.teacher ?? ""
    }
}
