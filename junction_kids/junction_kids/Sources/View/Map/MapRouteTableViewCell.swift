//
//  MapRouteTableViewCell.swift
//  junction_kids
//
//  Created by 성다연 on 2021/05/22.
//

import UIKit

class MapRouteTableViewCell: UITableViewCell {
    @IBOutlet weak var routeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    static let CellID = "MapRouteTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindViewModel(image: String, title: String, subTitle: String) {
        if let i = UIImage(named: image) {
            DispatchQueue.main.async { [weak self] in
                self?.routeImageView.image = i
            }
        }
        titleLabel.text = title
        subTitleLabel.text = subTitle
    }
}
