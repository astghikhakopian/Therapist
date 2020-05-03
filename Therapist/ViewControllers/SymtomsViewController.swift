//
//  SymtomsViewController.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/2/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import UIKit

protocol SymtomsViewControllerDelegate {
    func gotSelectedSymptoms(symptoms: [SymptomModel])
}

class SymtomsViewController: UIViewController {

    private let cellId = "SymtomTableViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Public for segue
    
    var delegate: SymtomsViewControllerDelegate?
    var selectedSymptoms = [SymptomModel]()
    
    
    // MARK: - Private Properties
    
    private var symotoms = [SymptomModel]()
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RequestManager.sharedInstance.getSymptomList { [weak self] in
            guard let self = self else { return }
            
            self.symotoms = $0
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func closeButtonTouchUp(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func doneButtonTouchUp(_ sender: UIBarButtonItem) {
        delegate?.gotSelectedSymptoms(symptoms: selectedSymptoms)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension SymtomsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return symotoms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId)!
        let symptom = symotoms[indexPath.item]
        
        cell.textLabel?.text = symptom.name
        cell.accessoryType = selectedSymptoms.contains(where: { $0.label == symptom.label }) ? .checkmark : .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if cell.accessoryType == .checkmark {
            guard let index = selectedSymptoms.firstIndex(where: { $0.label == symotoms[indexPath.item].label }) else { return }
            selectedSymptoms.remove(at: index)
                   tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            selectedSymptoms.insert(symotoms[indexPath.item], at: 0)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
