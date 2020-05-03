//
//  DetectDiseaseViewController.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/2/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import UIKit

class DetectDiseaseViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    // MARK: - Public for segue
    
    var symptoms = [SymptomModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        RequestManager.sharedInstance.detectDisease(from: symptoms) { [weak self] disease in
            guard let self = self, let disease = disease else { return }
            self.nameLabel.text = "\(disease.armenianName)\n(\(disease.englishName))"
            self.descriptionLabel.text = disease
            .description
        }
    }
    
    // MARL: - Action
    
    @IBAction func okButtonTouchUp() {
        dismiss(animated: true, completion: nil)
    }
}
