//
//  PlayerService.swift
//  junction_kids
//
//  Created by 홍정민 on 2021/05/22.
//


import Alamofire

struct VideoService : APIManager {
    static let shared = VideoService()
    let header: HTTPHeaders =  ["Content-Type" : "application/json"]
    let videoURL = url("/getVideo")
    typealias completeRequest = (AFDataResponse<Any>) -> ()
    
    
    func getVideo(startX: Float, startY: Float,
                    endX: Float, endY: Float,
                    type: Int, completion: @escaping(completeRequest)){
        
        let body: [String:Any] = [
            "startX": startX,
            "startY": startY,
            "endX": endX,
            "endY": endY,
            "type": type
        ]
        
        AF.request(videoURL, method: .post, parameters: body, encoding:JSONEncoding.default, headers: header).responseJSON(completionHandler: {
            response in
            switch response.result {
            case .success:
                completion(response)
            case .failure(let err):
                print("video request error err : \(err)")
                break
            }
        })
        
    }
}
