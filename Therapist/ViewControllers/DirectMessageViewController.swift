//
//  DirectMessageViewController.swift
//  Therapist
//
//  Created by Astghik Hakopian on 5/2/20.
//  Copyright © 2020 Astghik Hakopian. All rights reserved.
//

import UIKit

class DirectMessageViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var symptomsView: UIStackView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var attachFileButton: UIButton!
    
    @IBOutlet weak var messageView: UIView!
    
    @IBOutlet weak var changingConstraint: NSLayoutConstraint? {
        didSet {
            addKeyboardNotificationObserver()
        }
    }
    
    // MARK: - Public for segues
    
    public var username     = "օգտատեր"
    public let systemname   = "խորհրդատու"
    
    
    // MARK: - Datasource
    
    private var messages = [MessageModel]()
    private var symptoms = [SymptomModel]()
    
    private let detectedSymptomMessageText = "Ձեր հաղորդագրությունից առանձնացվել են հետեւյալ սիմպտոմները՝"
    private let nodetectedSymptomsMessageText = "Ձեր հաղորդագրությունից չենք կարողացել առանձնացնել սիմպտոմները։ Փորձեք նկարագրել այլ բառերով, կամ ընտրեք ցուցակից՝ «+» կոճակին սեղմելով։"
    
    private let newMessageDelay: TimeInterval = 1
    
    // segues
    
    private let toSymtomsViewController = "SymtomsViewController"
    private let toDetectDiseaseViewController = "DetectDiseaseViewController"
    
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view
        tableView.register(UINib(nibName: DirectMessageTableViewCell.outgoingId, bundle: nil), forCellReuseIdentifier: DirectMessageTableViewCell.outgoingId)
        tableView.register(UINib(nibName: DirectMessageTableViewCell.incomingId, bundle: nil), forCellReuseIdentifier: DirectMessageTableViewCell.incomingId)
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        // collection view
        collectionView.register(UINib(nibName: SymptomCollectionViewCell.id, bundle: nil), forCellWithReuseIdentifier: SymptomCollectionViewCell.id)
        
        // set initial content
        let welcomeMessages = [
            "Ողջույն, հարգելի՜ \(username)։ \nԲարի գալուստ համակարգ։ Խնդրում ենք ներկայացնել Ձեր գանգատները։",
            "Ուղարկելուց հետո Դուք կտեսնեք ըստ Ձեր նամակից առանձնացրած սիմպտոմերը։",
            "Նաեւ կորող եք «+» կոճակով ընտրել ձեր առաջարկվող ցուցակից։"
            ].reversed()
        let messages = welcomeMessages.map { MessageModel(username: systemname, message: $0, writer: .system) }
        addMessages(messages: messages)
    }
    
    
    // MARK: - Actions
    
    @IBAction func sendButtounTouchUp() {
        guard let text = messageTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines), !text.isEmpty else { return }
        addMessages(messages: [MessageModel(username: username, message: text, writer: .user)])
        requestForSymptons(text: text)
        messageTextView.text = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case toSymtomsViewController:
            let destinationNC = segue.destination as! UINavigationController
            let destinationVC = destinationNC.viewControllers[0] as! SymtomsViewController
            
            destinationVC.delegate = self
            destinationVC.selectedSymptoms = symptoms
        case toDetectDiseaseViewController:
            let destinationNC = segue.destination as! UINavigationController
            let destinationVC = destinationNC.viewControllers[0] as! DetectDiseaseViewController
            
            destinationVC.symptoms = symptoms
        default: break
        }
    }
    
    
    // MARK: - Public Helpers
    
    public func addMessages(messages: [MessageModel]) {
        guard !messages.isEmpty else { return }
        
        self.messages = messages + self.messages
        let indexPaths = messages.enumerated().map {IndexPath(row: $0.0, section: 0)}
        tableView.insertRows(at: indexPaths, with: .bottom)
        
        symptomsView.isHidden = symptoms.isEmpty
    }
    
    public func addSymptoms(symptoms: [SymptomModel]) {
        guard !symptoms.isEmpty else { return }
    
        var symptoms = symptoms
        symptoms.removeAll { symptom -> Bool in self.symptoms.contains(where: { symptom.label == $0.label }) }
        
        self.symptoms = symptoms + self.symptoms
        let indexPaths = symptoms.enumerated().map {IndexPath(item: $0.0, section: 0)}
        collectionView.insertItems(at: indexPaths)
        
        symptomsView.isHidden = symptoms.isEmpty
    }
    
    public func removeSymptom(at indexPath: IndexPath) {
        symptoms.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
        
        symptomsView.isHidden = symptoms.isEmpty
    }
    
    
    public func requestForSymptons(text: String) {
        RequestManager.sharedInstance.getSymptoms(from: text) { [weak self] symptoms in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + self.newMessageDelay, execute: { [weak self] in
                guard let self = self else { return }
                guard !symptoms.isEmpty else {
                    let nodetectedSymptomsMessage = MessageModel(username: self.systemname, message: self.nodetectedSymptomsMessageText, writer: .system)
                    self.addMessages(messages: [nodetectedSymptomsMessage])
                    return }
                
                // add message
                let detectedSymptomMessage = MessageModel(username: self.systemname, message: self.detectedSymptomMessageText, writer: .system)
                var messages = symptoms.map { MessageModel(username: self.systemname, message: $0.name, writer: .system) }
                messages.append(detectedSymptomMessage)
                
                self.addMessages(messages: messages)
                
                // add symptom
                self.addSymptoms(symptoms: symptoms)
            })
        }
    }
}


// MARK: - UITableViewDelegate, UITableViewDataSource

extension DirectMessageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DirectMessageTableViewCell
        let message = messages[indexPath.row]
        
        switch message.writer {
        case .user:
            guard let existingCell = tableView.dequeueReusableCell(withIdentifier: DirectMessageTableViewCell.outgoingId) as? DirectMessageTableViewCell else {
                return UITableViewCell()
            }
            cell = existingCell
        case .system:
            guard let existingCell = tableView.dequeueReusableCell(withIdentifier: DirectMessageTableViewCell.incomingId) as? DirectMessageTableViewCell else {
                return UITableViewCell()
            }
            cell = existingCell
        }
        
        cell.nameLabel.text = message.username
        cell.messageLabel.text = message.message
        
        cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}


// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension DirectMessageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symptoms.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SymptomCollectionViewCell.id, for: indexPath) as! SymptomCollectionViewCell
        
        cell.nameLabel.text = symptoms[indexPath.item].name.capitalized
        cell.delegate = self
        
        return cell
    }
}


// MARK: - SymptomCollectionViewCellDelegate

extension DirectMessageViewController: SymptomCollectionViewCellDelegate {
    func removeButtonTouchUp(cell: SymptomCollectionViewCell) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        removeSymptom(at: indexPath)
    }
}

// MARK: - SymtomsViewControllerDelegate

extension DirectMessageViewController: SymtomsViewControllerDelegate {
    func gotSelectedSymptoms(symptoms: [SymptomModel]) {
        self.symptoms = symptoms
        collectionView.reloadData()
        symptomsView.isHidden = symptoms.isEmpty
    }
}


// MARK: - KeyboardMovingDelegate

extension DirectMessageViewController: KeyboardMovingDelegate { }
