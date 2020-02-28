//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation

class User :Codable {
    
    var image: String? = nil
    var name: String? = nil
    var location:Location? = nil

    init(_ name: String, _ data: [String: AnyObject]) {
        self.name = name
        if let picture = data["picture"] {
            let imageData = picture as! [String: AnyObject]
            if let data = imageData["data"] {
                let dict = data as! [String: AnyObject]
                self.image = (dict["url"] as! String)
            }
        }
    }
    
    init(_ name:String, _ image:String, _ location: Location?){
        self.name = name
        self.image = image
        self.location = location
    }
    
    init(_ json:[String:Any]){
        if json["name"] != nil{
            self.name = json["name"] as? String
        }
        if json["image"] != nil {
            self.image = json["image"] as? String
        }
        if json["location"] != nil {
            self.location = Location.init(json["location"] as? [String:Any])
        }
    }

    func toJson() -> String {
        let jsonEncoder = JSONEncoder()
        let jsonData = try! jsonEncoder.encode(self)
        return String(data: jsonData, encoding: String.Encoding.utf8)!
    }
        
}
