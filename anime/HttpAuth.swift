//
//  HttpAuth.swift
//  bbbb
//
//  Created by faith on 2020/6/25.
//  Copyright © 2020 faith. All rights reserved.
//

import Foundation
import Combine

//struct ServerMessage: Decodable {
//   let res, message: String
//}
//
//class HttpAuth: ObservableObject {
//
//    @Published var authenticated = false
//
//    func postAuth(username: String, password: String) {
//        guard let url = URL(string: "http://miniapp.mengchenghui.com/mag/user/v1/User/login") else { return }
//
//        let body: [String: String] = ["username": username, "password": password]
//
//        let finalBody = try! JSONSerialization.data(withJSONObject: body)
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = finalBody
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        print(finalBody)
//        URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let data = data else {
//                print("error")
//                return }
//            let resData = try! JSONDecoder().decode(ServerMessage.self, from: data)
//            print(resData.res)
////            if resData.res == "correct" {
////                DispatchQueue.main.async {
////                    self.authenticated = true
////                }
////            }
//        }.resume()
//    }
//}

let username: String = "clearlove"
let password: String = "zh375052824"

struct LoginData: Codable {
    var account: String
    var password: String
    var country_code: String = "1"
    var needLoadingIndicator: String = "true"
}

//let decoder = JSONDecoder()
//
//do {
//    let login = try decoder.decode([LoginData].self, from: jsonData)
//    print(login)
//} catch {
//    print(error.localizedDescription)
//}

//    let params = {
//
//        "account"; : username,
//        "password": password,
//        "country_code": "1",
//        "needLoadingIndicator": "true"
//
//    }



//        let encoder = JSONEncoder()
//    let loginData = LoginData(account: username, password: password)
//        let data = try encoder.encode(loginData)
//        let parameters = String(data: data, encoding: .utf8)!


//    let loginData:Dictionary<String, Any> = [
//        "password" : password,
//        "country_code": "1",
//        "needLoadingIndicator": "true",
//        "account": username
//    ]
//    if (!JSONSerialization.isValidJSONObject(loginData)) {
//        print("is not a valid json object")
//        return
//    }
//    print(loginData)
//    do {
//        let jsonData = try JSONSerialization.data(withJSONObject: loginData, options: JSONSerialization.WritingOptions.prettyPrinted)
//        print("json: \(String(describing: jsonData))")
//        request.httpBody = jsonData
//    } catch let e {
//        print(e)
//    }

//
//    guard let encoded = try? JSONEncoder().encode(loginData) else {
//        print("Failed to encode order")
//        return
//    }
//
//    request.httpBody = encoded //Data("{'account': 'clearlove', 'password': 'zh375052824', 'country_code': '1', 'needLoadingIndicator': 'true'}".utf8)


//    request.setValue("\(String(describing: jsonData?.count))", forHTTPHeaderField: "Content-Length")
//    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

struct Item: Codable {
    var subject: String
    var title: String
    var dateline: String
    var lastpost: String
    var tid: String
}

struct ItemList: Codable {
    
    let list: [Item]
}


class HttpManager {
    
    static let sessionManager: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20 // seconds
        configuration.timeoutIntervalForResource = 20 // seconds
        return URLSession(configuration: configuration)
    }()
    
    static func sendRequest(request: URLRequest,  callback: @escaping (Bool, Any) -> Void) {
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = HttpManager.sessionManager.dataTask(with: request) { data, response, error in
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                callback(false,error)
                return
            }
            
            // Convert HTTP Response Data to a String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                //                print("Response data string:\n \(dataString)")
                callback(true,dataString)
            }
            semaphore.signal()
        }
        dataTask.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
    }
    
    static func get(url: String, callback: @escaping (Bool, Any) -> Void) {
        let request = URLRequest(url: URL(string: url)!)
        HttpManager.sendRequest(request: request, callback: callback)
    }
}



func doPost() {
    let Url = String(format: "http://miniapp.mengchenghui.com/mag/user/v1/User/login")
    guard let serviceUrl = URL(string: Url) else { return }
    
    var request = URLRequest(url: serviceUrl)
    request.httpBody=Data("account=clearlove&password=zh375052824&country_code=1&needLoadingIndicator=true".utf8)
    request.httpMethod = "POST"
    request.timeoutInterval = 20
    
    HttpManager.sendRequest(request: request) { (status,resp) in
        if status {
            print(resp)
        }
    }

    HttpManager.get(url: "http://miniapp.mengchenghui.com/mag/circle/v1/forum/forumView?p=1&step=20&needLoadingIndicator=false&circle_id=139&fid=41&order=&type=216") { (status,resp) in
        if status {
            func checkKeyWords(item: Item, kw: String) -> Bool{
                return item.title.lowercased().contains(kw) || item.subject.lowercased().contains(kw)
            }
            print(type(of: resp))
            do {
                let items = try JSONDecoder().decode(ItemList.self, from: (resp as! String).data(using: .utf8)!)
//                print(items)
                for index in 0..<items.list.count {
                    let item = items.list[index]
                    if (checkKeyWords(item: item, kw:"ipad") && !checkKeyWords(item: item, kw:"求")) {
                        print(item)
                    }
                    
                }
            } catch(let e) {
                print(e)
            }
            
        }
        
    }
}
//doPost()


