//
//  PetitionsManager.swift
//  Project07
//
//  Created by Edwin Cardenas on 2/1/23.
//

import Foundation

class PetitionsManager {
    
    var delegate: PetitionsManagerDelegate?
    
    var petitionsURL: String?
    
    func fetchPetitions() {
        if let url = petitionsURL {
            performRequest(urlString: url)
        }
    }
    
    func performRequest(urlString: String) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { data, response, error in
                    if error != nil {
                        self?.delegate?.didFailWithError(error: error!)
                        
                        return
                    } else {
                        if let safeData = data {
                            if let petitions = self?.parseJSON(safeData) {
                                self?.delegate?.didUpdatePetitions(self, petitions: petitions)
                            }
                        }
                    }
                }
                
                task.resume()
            }
        }
    }
    
    func parseJSON(_ petitionsData: Data) -> Petitions? {
        let decoder = JSONDecoder()
        
        do {
            let jsonPetitions = try decoder.decode(Petitions.self, from: petitionsData)
            let petitions = jsonPetitions
            
            return petitions
        } catch {
            delegate?.didFailWithError(error: error)
            
            return nil
        }
    }
}
