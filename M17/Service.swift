//
//  Service.swift
//  M17
//
//  Created by Алена on 03.10.2023.
//

import UIKit

struct Service {
    
    func loadImage(urlString: String) -> UIImage? {
       guard let url = URL(string: urlString),
             let data = try? Data(contentsOf: url)
        else {
           print("Unseccessful loading image..")
           return nil
       }
    return UIImage(data: data)
    }
    
    
    func getImageURL(completion: @escaping(String?, Error?) -> Void) {
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            let someDictionaryFromJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
            let imageUrl = someDictionaryFromJSON?["message"] as? String
            completion(imageUrl, error)
        }
        task.resume()
    }
}
