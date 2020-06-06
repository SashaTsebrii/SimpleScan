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
        
        // Set documents
        
//        documents = [Document(id: "123", createDate: "123", url: URL(fileURLWithPath: "123")),
//                     Document(id: "123", createDate: "123", url: URL(fileURLWithPath: "123")),
//                     Document(id: "123", createDate: "123", url: URL(fileURLWithPath: "123"))]
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
    
    // MARK: CoreData
    
    
        
        func retrieveData() {
            
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Prepare the request of type NSFetchRequest  for the entity
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Document")
            
            fetchRequest.predicate = NSPredicate(format: "nameString = %@", "No name")
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: "createDateString", ascending: false)]
            
            do {
                let result = try managedContext.fetch(fetchRequest)
                for data in result as! [NSManagedObject] {
                    print(data.value(forKey: "idString") as! String)
                    print(data.value(forKey: "nameString") as! String)
                    print(data.value(forKey: "createDateString") as! String)
                    print(data.value(forKey: "urlString") as! String)
                }
            } catch {
                print("Failed")
            }
            
        }
        
//        func updateData(){
//
//            //As we know that container is set up in the AppDelegates so we need to refer that container.
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//            //We need to create a context from this container
//            let managedContext = appDelegate.persistentContainer.viewContext
//
//            let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Document")
//            fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur1")
//            do
//            {
//                let test = try managedContext.fetch(fetchRequest)
//
//                    let objectUpdate = test[0] as! NSManagedObject
//                    objectUpdate.setValue("newName", forKey: "username")
//                    objectUpdate.setValue("newmail", forKey: "email")
//                    objectUpdate.setValue("newpassword", forKey: "password")
//                    do{
//                        try managedContext.save()
//                    }
//                    catch
//                    {
//                        print(error)
//                    }
//                }
//            catch
//            {
//                print(error)
//            }
//
//        }
        
//         func deleteData(){
//
//            //As we know that container is set up in the AppDelegates so we need to refer that container.
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//            //We need to create a context from this container
//            let managedContext = appDelegate.persistentContainer.viewContext
//
//            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Document")
//            fetchRequest.predicate = NSPredicate(format: "username = %@", "Ankur3")
//
//            do
//            {
//                let test = try managedContext.fetch(fetchRequest)
//
//                let objectToDelete = test[0] as! NSManagedObject
//                managedContext.delete(objectToDelete)
//
//                do{
//                    try managedContext.save()
//                }
//                catch
//                {
//                    print(error)
//                }
//
//            }
//            catch
//            {
//                print(error)
//            }
//        }
    
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
