//
//  RequestManager.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/2/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import Foundation

final class RequestManager {
    
    static let sharedInstance = RequestManager()
    private init() { }

    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    
    func getSymptoms(from text: String, completion: @escaping ([SymptomModel])->()) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "http://192.168.0.105:5000") {
            urlComponents.query = "text=\(text)"
            
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) {  [weak self] data, response, error in
                    defer { self?.dataTask = nil }
                    
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        // let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        let symptoms = (try? JSONDecoder().decode([SymptomModel].self, from: data)) ?? []
                        
                        DispatchQueue.main.async {
                            completion(symptoms)
                        }
                    }
            }
            dataTask?.resume()
        }
    }
    
    func getSymptomList(completion: @escaping ([SymptomModel])->()) {
        dataTask?.cancel()
        
        if let urlComponents = URLComponents(string: "http://192.168.0.105:5000/symptoms") {
            
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) {  [weak self] data, response, error in
                    defer { self?.dataTask = nil }
                    
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        // let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        let symptoms = (try? JSONDecoder().decode([SymptomModel].self, from: data)) ?? []
                        
                        DispatchQueue.main.async {
                            completion(symptoms)
                        }
                    }
            }
            dataTask?.resume()
        }
    }
    
    func detectDisease(from symptoms: [SymptomModel], completion: @escaping (DiseaseModel?)->()) {
        dataTask?.cancel()
        
        guard !symptoms.isEmpty else { return }
        let sendingSymtoms = symptoms.map{ $0.label }.joined(separator: ",")
        if var urlComponents = URLComponents(string: "http://192.168.0.105:5001") {
            urlComponents.query = "symptoms=\(sendingSymtoms)"
            
            guard let url = urlComponents.url else { return }
            dataTask = defaultSession.dataTask(with: url) {  [weak self] data, response, error in
                    defer { self?.dataTask = nil }
                    
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        // let json = try? JSONSerialization.jsonObject(with: data, options: [])
                        let symptoms = (try? JSONDecoder().decode(DiseaseModel.self, from: data))
                        
                        DispatchQueue.main.async {
                            completion(symptoms)
                        }
                    }
            }
            dataTask?.resume()
        }
    }
}
