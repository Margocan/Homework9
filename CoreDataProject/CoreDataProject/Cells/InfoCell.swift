

import UIKit

final class InfoCell: UITableViewCell {
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var ageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(firstLabel: String?, secondLabel: String?) {
        nameLabel.text = firstLabel ?? ""
        ageLabel.text = secondLabel ?? ""
    }
    
}
