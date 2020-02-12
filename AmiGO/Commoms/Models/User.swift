//
// Created by Alejandro on 11/02/2020.
// Copyright (c) 2020 Dspot. All rights reserved.
//

import Foundation

class User: Codable {
    var image: String? = nil
    var name: String? = nil

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

    func toDictionary() -> [String: String] {
        var dict = [String: String]()
        dict["name"] = name
        dict["image"] = image
        return dict
    }

}