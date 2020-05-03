//
//  ViewController.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/1/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var changingConstraint: NSLayoutConstraint? {
        didSet {
            addKeyboardNotificationObserver()
        }
    }
    
    // MARK: - Private Constants
    
    private let toDirectMessageViewController = "DirectMessageViewController"
    
    
    // MARK: - Lifecycle Methods
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toDirectMessageViewController:
            let destinationVC = segue.destination as! DirectMessageViewController
            if let name = nameTextField.text, !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                destinationVC.username = name
            }
        default: break
        }
    }
}

// MARK: - UITextFieldDelegate

extension WelcomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


// MARK: - KeyboardMovingDelegate

extension WelcomeViewController: KeyboardMovingDelegate { }
