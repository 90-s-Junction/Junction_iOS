//
//  VideoViewController.swift
//  junction_kids
//
//  Created by 홍정민 on 2021/05/22.
//

import UIKit
import AVFoundation
import AVKit

class VideoViewController: UIViewController {
   
    //Starting a Simulation Btn Event
    @IBAction func playVideo(_ sender: UIButton) {
        getVideoURL()
    }
    
    //Route Info View Elements
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var dayImageView: UIImageView!
    @IBOutlet weak var playVideoBtn: UIButton!
    
    
    //Variable for API
    var startX:Float = 0.0
    var startY:Float = 0.0
    var endX:Float = 0.0
    var endY:Float = 0.0
    var type:Int = 1
    var videoURL:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI(){
        infoView.layer.cornerRadius = 10
        playVideoBtn.layer.cornerRadius = 10
    }
    


    func getVideoURL(){
        VideoService.shared.getVideo(startX: startX, startY: startY,
                                       endX: endX, endY: endY, type: type,
                                       completion: { response in
            if let status = response.response?.statusCode {
                print("\(status)")
                switch status {
                case 200:
                    guard let data = response.data else { return }
                    let decoder = JSONDecoder()
                    let result = try? decoder.decode(VideoResult.self, from: data)
                    guard let url = result?.videoURL else { return }
                    self.videoURL = url
                    self.showVideo()
                    break
                case 401...404:
                    break
                case 500:
                    break
                default:
                    return
                }
            }
        })
    }
    
    func showVideo(){
        guard let url = URL(string: self.videoURL) else {
            return
        }
        
        // Create an AVPlayer, passing it the HTTP Live Streaming URL.
        let player = AVPlayer(url: url)

        // Create a new AVPlayerViewController and pass it a reference to the player.
        let controller = AVPlayerViewController()
        controller.player = player

        // Modally present the player and call the player's play() method when compl ete.
        present(controller, animated: true) {
            player.play()
        }
    }
    

}
