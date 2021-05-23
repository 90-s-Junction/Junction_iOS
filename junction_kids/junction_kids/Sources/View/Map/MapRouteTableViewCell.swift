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
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dayImageView: UIImageView!
    
    static let CellID = "MapRouteTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindViewModel(item: Route) {
        DispatchQueue.main.async { [weak self] in
            self?.routeImageView.image = UIImage(named: item.type.image())
            self?.dayImageView.image = UIImage(named: item.dayNight.image())
        }
        titleLabel.text = item.type.name()
        typeLabel.text = item.carType
        timeLabel.text = "\(item.time)min"
        distanceLabel.text = "\(item.distance)km"
    }
}
