//
//  PetitionsManagerDelegate.swift
//  Project07
//
//  Created by Edwin Cardenas on 2/1/23.
//

import Foundation

protocol PetitionsManagerDelegate {
    func didUpdatePetitions(_ petitionsManager: PetitionsManager?, petitions: Petitions) -> Void
    func didFailWithError(error: Error)
}
