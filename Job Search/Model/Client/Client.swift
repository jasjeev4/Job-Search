//
//  Client.swift
//  Job Search
//
//  Created by JASJEEV on 4/22/20.
//  Copyright © 2020 Lorgarithmic Science. All rights reserved.
//

import Foundation
import UIKit

class Client {
    struct Store {
        static var photoURL = ""
    }
    
    enum Endpoints {
        static let logoURL = "https://us-central1-primary-server-168620.cloudfunctions.net/logo?company="
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ResponseType.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
        
        return task
    }
    
    class func loadLogo(company: String, completion: @escaping (String, Error?) -> Void) {
        let myURL = Endpoints.logoURL + company
        let url =  URL(string: myURL)!
        taskForGETRequest(url: url, responseType: CompanyPhoto.self) { response, error in
            if let response = response {
                completion(response.photoURL!, nil)
            } else {
                completion("", error)
            }
        }
    }
    
    class func downloadPhoto(urlString: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image, error)
            }
        }
        task.resume()
    }
    
}

    
