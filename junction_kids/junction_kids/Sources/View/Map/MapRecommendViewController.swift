//
//  MapRecommendViewController.swift
//  junction_kids
//
//  Created by 성다연 on 2021/05/23.
//

import UIKit
import MapKit
import CoreLocation

class MapRecommendViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    static let ViewID = "MapRecommendViewController"
    
    var mappableItem : MapItem!
    var startText : String = ""
    var endText: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSubViews()
    }
    
    private func setUpSubViews() {
        navigationItem.title = "Find a Route"
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = .black
        
        startLabel.font = UIFont(name: "Volte", size: 16.0)
        endLabel.font = UIFont(name: "Volte", size: 16.0)
        startLabel.text = startText
        endLabel.text = endText
    }
    
    private func nextVC(index: Int) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: VideoViewController.ViewID) as! VideoViewController
        mappableItem.type = index
        nextVC.mapItem = mappableItem
        nextVC.startText = startText
        nextVC.endText = endText
        navigationController?.pushViewController(nextVC, animated: true)
    }
}


extension MapRecommendViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RouteFactory.shared.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MapRouteTableViewCell.CellID) as! MapRouteTableViewCell
        cell.bindViewModel(item: RouteFactory.shared[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nextVC(index: indexPath.row)
    }
}
