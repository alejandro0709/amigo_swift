//
//  RestManager.swift
//  AmiGO
//
//  Created by Alejandro on 19/02/2020.
//  Copyright © 2020 Dspot. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RestManager {
    var requestHttpHeaders = RestEntity()
    var urlQueryParameters = RestEntity()
    var httpBodyParameters = RestEntity()
    
    var httpBody: Data?
    
    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders.value(forKey: "Content-Type") else { return nil }
        
        if contentType.contains("application/json"){
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters.allValues(), options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains("application/x-www-form-urlenconded"){
            let bodyString = httpBodyParameters.allValues().map{ "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))"
            }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.totalItems() > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
                return url
            }
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters.allValues(){
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(item)
            }
            urlComponents.queryItems = queryItems
            guard let updateUrl = urlComponents.url else { return url }
            return updateUrl
        }
        return url
    }
    
    private func prepareRequest(withUrl url: URL, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest{
        var request  = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHttpHeaders.allValues(){
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
    
    func makeRequestWithObservable(toStringURL urlString: String, withHttpMethod httpMethod: HttpMethod) -> Observable<Results>{
        return Observable.from(optional: urlString)
            .map{urlString -> URL in
                return URL(string: urlString)!
        }.map { url -> URLRequest in
            return self.prepareRequest(withUrl:  url, httpBody: self.httpBody, httpMethod: httpMethod)
        }.flatMap { request -> Observable<(response:HTTPURLResponse, data: Data)> in
            return URLSession.shared.rx.response(request: request)
        }.map { (response:HTTPURLResponse, data: Data) -> Results in
            if 200 ..< 300 ~= response.statusCode {
                return Results(withData: data, response: Response(fromURLResponse: response), error: nil)
            }
            else {
                return Results(withError: CustomError.errorOnRequest(code: response.statusCode))
            }
        }
    }
    
    func makeRequest(toURL url:URL, withHttpMethod httpMethod: HttpMethod, completion: @escaping (_ result: Results) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            [weak self] in
            let targetUrl = self?.addURLQueryParameters(toURL: url)
            let httpBody = self?.getHttpBody()
            guard let request = self?.prepareRequest(withUrl: targetUrl!, httpBody: httpBody, httpMethod: httpMethod) else {
                completion(Results(withError: CustomError.failedToCreateRequest))
                return
            }
            
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: request){ (data, response, error) in
                completion(Results(withData: data, response: Response(fromURLResponse: response), error: error))
            }
            task.resume()
        }
    }
    
    public func getData(fromURL url: URL, completion: @escaping (_ data: Data?) -> Void){
        DispatchQueue.global(qos: .userInitiated).async {
            let sessionConfiguration = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfiguration)
            let task = session.dataTask(with: url, completionHandler: {(data, response, error) in
                guard let data  = data else { completion(nil); return }
                completion(data)
            })
            
            task.resume()
        }
    }
    
}

extension RestManager.CustomError: LocalizedError{
    public var localizedDescription: String{
        switch self {
            case .failedToCreateRequest:
                return NSLocalizedString("Unable to create the URLRequest object", comment: "")
        case .errorOnRequest(let code):
            return NSLocalizedString("Error:\(code), request on server failed.", comment: "")
        }
    }
}
