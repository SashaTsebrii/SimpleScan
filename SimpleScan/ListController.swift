//
//  ListController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/3/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import VisionKit
import PDFKit
import CoreData

class ListController: UIViewController {
    
    // MARK: Variables
    
    var documents: [Document] = []
    
    // MARK: Properties
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ListCell.self, forCellWithReuseIdentifier: ListCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Set title
        title = NSLocalizedString("List", comment: "")
        
        // Set background color
        view.backgroundColor = .white
        
        // Collection view constraints
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Create left bar button item
        let settingsBarButton = UIBarButtonItem(title: NSLocalizedString("Settings", comment: ""), style: .plain, target: self, action: #selector(settingsBarButtonTapped(_:)))
        navigationItem.leftBarButtonItem = settingsBarButton
        
        // Create right bar button item
        let scanBarButton = UIBarButtonItem(title: NSLocalizedString("Scan", comment: ""), style: .plain, target: self, action: #selector(scanBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = scanBarButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Set documents
        retrieveData()
        collectionView.reloadData()
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func settingsBarButtonTapped(_ sendr: UIBarButtonItem) {
        
        let settingsController = SettingsController()
        navigationController?.pushViewController(settingsController, animated: true)
        
    }
    
    @objc fileprivate func scanBarButtonTapped(_ sendr: UIBarButtonItem) {
        
        let scanController = ScanController()
        navigationController?.pushViewController(scanController, animated: true)
        
    }
    
    // MARK: Helper
    
    func craatePreviewController(for index: Int) -> PreviewController {
        
        let previewController = PreviewController()
        
        let document = documents[index]
        previewController.document = document
        
        return previewController
        
    }
    
    func makeContextMenu(for document: Document) -> UIMenu {
        
        let rename = UIAction(title: "Rename Pupper", image: UIImage(systemName: "square.and.pencil")) { action in
            // Show rename UI
        }

        // Here we specify the "destructive" attribute to show that it’s destructive in nature
        let delete = UIAction(title: "Delete Photo", image: UIImage(systemName: "trash"), attributes: .destructive) { action in
            // Delete this photo 😢
        }

        // The "title" will show up as an action for opening this menu
        let edit = UIMenu(title: "Edit...", children: [rename, delete])

        // Create a UIAction for sharing
        let share = UIAction(title: "Share Pupper", image: UIImage(systemName: "square.and.arrow.up")) { action in
            // Show system share sheet
        }

        // Create and return a UIMenu with a actions
        return UIMenu(title: document.nameString!, children: [edit, share])
        
    }
    
    // MARK: CoreData
        
        func retrieveData() {
            
            // Get reference to AppDelegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // Create a context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // Prepare the request of type NSFetchRequest for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.kDocument.entityName)
            
            fetchRequest.predicate = NSPredicate(format: "\(Constants.kDocument.nameString) = %@", "No name")
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "createDateString", ascending: false)]
            
            do {
                documents = try managedContext.fetch(fetchRequest) as! [Document]
            } catch {
                print("Failed")
            }
            
        }
        
    func updateData() {
        
        // Get reference to AppDelegatesrefer
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // Create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: Constants.kDocument.entityName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.kDocument.nameString) = %@", "No name")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "createDateString", ascending: false)]
        do {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue("newName", forKey: "username")
            objectUpdate.setValue("newmail", forKey: "email")
            objectUpdate.setValue("newpassword", forKey: "password")
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
    }
    
    func deleteData(atIndex index: Int) {
        
        // Get reference to AppDelegatesrefer
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // Create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.kDocument.entityName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.kDocument.nameString) = %@", "No name")
        fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "createDateString", ascending: false)]
        
        do {
            let documents = try managedContext.fetch(fetchRequest)
            
            let objectToDelete = documents[index] as! Document
            managedContext.delete(objectToDelete)
            
            do {
                try managedContext.save()
            } catch {
                print(error)
            }
        } catch {
            print(error)
        }
        
    }
    
}

extension ListController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return documents.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCell.identifier, for: indexPath) as? ListCell else {
            fatalError("Unexpected cell instead of ListCell")
        }
        
        let document = documents[indexPath.row]
        cell.document = document
        
        return cell
        
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let previewController = craatePreviewController(for: indexPath.item)
        navigationController?.pushViewController(previewController, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        let cell = collectionView.cellForItem(at: indexPath) as! ListCell
        let image = cell.previewImageView.image
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {
            // Create a preview view controller and return it
            return CellPreviewController(image: image!)
        }, actionProvider: { suggestedActions in
            // "documents" is the array backing the collection view
            return self.makeContextMenu(for: self.documents[indexPath.row])
        })
        
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var optimalWidth: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            optimalWidth = (view.bounds.width - 8 - 16) / 2
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            optimalWidth = (view.bounds.width - 16 - 32) / 2
        }
        
        let itemSize = CGSize(width: optimalWidth, height: optimalWidth)
        
        return itemSize
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        var edgeInsets: UIEdgeInsets = UIEdgeInsets.zero
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            edgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            edgeInsets = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
        
        return edgeInsets
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        var interitemSpacing: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            interitemSpacing = 8
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            interitemSpacing = 16
        }
        
        return interitemSpacing
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        var lineSpacing: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            lineSpacing = 8
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            lineSpacing = 16
        }
        
        return lineSpacing
        
    }
    
}
