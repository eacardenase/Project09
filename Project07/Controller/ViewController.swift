//
//  ViewController.swift
//  Project07
//
//  Created by Edwin Cardenas on 2/1/23.
//

import UIKit

class ViewController: UITableViewController, PetitionsManagerDelegate {

    var petitionsManager = PetitionsManager()
    var petitions = [Petition]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        petitionsManager.delegate = self
        
        if navigationController?.tabBarItem.tag == 0 {
            petitionsManager.petitionsURL = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            petitionsManager.petitionsURL = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        petitionsManager.fetchPetitions()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let petition = petitions[indexPath.row]
        
        let vc = DetailVC()
        vc.detailItem = petition
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didUpdatePetitions(_ petitionsManager: PetitionsManager?, petitions: Petitions) {
        DispatchQueue.main.async { [weak self] in
            self?.petitions = petitions.results
            self?.tableView.reloadData()
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            [weak self] in
            
            let message = "There was a problem loading the feed; please check your connection and try again. \(error.localizedDescription)"
            
            let ac = UIAlertController(title: "Loading error", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            
            self?.present(ac, animated: true)
        }
    }
}

