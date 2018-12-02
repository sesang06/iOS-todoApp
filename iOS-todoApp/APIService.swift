//
//  APIService.swift
//  iOS-todoApp
//
//  Created by 조세상 on 02/12/2018.
//  Copyright © 2018 조세상. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import Alamofire
public enum RequestType : String{
    case GET, POST
}
protocol ApiRequest{
    var method : RequestType { get }
    var path : String { get }
    var parameters : [String : String ]{ get}
    
}
extension ApiRequest {
    func request(with baseURL : URL) -> URLRequest {
        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL compoenents")
            
        }
        components.queryItems = parameters.map{
            URLQueryItem(name: String($0), value: String($1))
        }
        guard let url = components.url else {
            fatalError("Could not get url")
        }
        let request : URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }()
        return request
    }
}
class ApiService {
    let baseURL = URL(string: "http://universities.hipolabs.com/")!
    
    func send<T: Codable>(apiRequest : ApiRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: self.baseURL)
            let task = URLSession.shared.dataTask(with: request) {
                (data, response, error) in
                
                do {
                    let model : T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            return Disposables.create {
                task.cancel()
            }
        }
    }
    /**
       Alamofire 로 짜기
     **/
    func get<T: Codable>(apiRequest: ApiRequest) -> Observable<T> {
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: self.baseURL)
            let dataRequest = Alamofire.request(request).responseData{
                response in
                
                switch response.result {
                case .success(let data) :
                    do {
                        let model : T = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                    } catch let error {
                        observer.onError(error)
                    }
                    case .failure(let error):
                    observer.onError(error)
                    
                }
                observer.onCompleted()
                
                
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    /**
     searchController.searchBar.rx.text.asObservable()
     .map { ($0 ?? "").lowercased() }
     .map { UniversityRequest(name: $0) }
     .flatMap { request -> Observable<[UniversityModel]> in
     return self.apiClient.send(apiRequest: request)
     }
     .bind(to: tableView.rx.items(cellIdentifier: cellIdentifier)) { index, model, cell in
     cell.textLabel?.text = model.name
     }
     .disposed(by: disposeBag)
    **/
}
