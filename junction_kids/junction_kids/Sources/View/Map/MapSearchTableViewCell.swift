//
//  MapSearchTableViewCell.swift
//  junction_kids
//
//  Created by 성다연 on 2021/05/22.
//

import UIKit

class MapSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    
    static let CellID = "MapSearchTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindViewModel(text: String) {
        label.text = text
    }
}
