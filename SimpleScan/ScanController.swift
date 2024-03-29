//
//  ScanController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/6/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import VisionKit
import PDFKit
import AVFoundation
import CoreData

class ScanController: UIViewController {
    
    // MARK: Properties
    
    fileprivate let pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.backgroundColor = .clear
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.pageShadowsEnabled = false
        pdfView.pageBreakMargins = UIEdgeInsets(top: 16, left: 16, bottom: 0, right: 16)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Set background color
        view.backgroundColor = UIColor.Design.background
        
        // Set title
        title = NSLocalizedString("Preview", comment: "")
        
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Create right bar button item
        let saveBarButton = UIBarButtonItem(title: NSLocalizedString("Save", comment: ""), style: .plain, target: self, action: #selector(saveBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = saveBarButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        scan()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            // Catch press to back bar button
        }
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
        if let pdfDocument = pdfView.document {
            
            // Today date
            let today = Date()
            
            // Create date string
            let createDateFormatter = DateFormatter()
            createDateFormatter.dateFormat = "MMM d, yyyy HH:mm"
            let createDateString = createDateFormatter.string(from: today)
            
            // Id from current date string
            let idFormatter = DateFormatter()
            idFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let idString = idFormatter.string(from: today)
            
            // Get the data of PDF document
            let data = pdfDocument.dataRepresentation()
            
            // Get directory
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentURL = documentDirectory.appendingPathComponent(idString)
            print(documentURL)
            let urlString = documentURL.path
            print(urlString)
            
            // Save document to directory
            do {
                try data?.write(to: documentURL)
            } catch (let error) {
                print("Error save data to URL: \(error.localizedDescription)")
            }
            
            // Get reference to AppDelegatesrefer
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // Create a context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // Create an entity and new document records
            let documentEntity = NSEntityDescription.entity(forEntityName: Constants.kDocument.entityName, in: managedContext)!
            
            // Final add some data to newly created entity for each keys
            let document = NSManagedObject(entity: documentEntity, insertInto: managedContext)
            document.setValue("\(idString)", forKeyPath: Constants.kDocument.idString)
            document.setValue(NSLocalizedString("No name", comment: ""), forKey: Constants.kDocument.nameString)
            document.setValue("\(createDateString)", forKey: Constants.kDocument.createDateString)
            document.setValue("\(urlString)", forKey: Constants.kDocument.urlString)
            
            // After set all the values, save them inside the CoreData
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
            
        }
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    // MARK: Helper
    
    fileprivate func scan() {
        
        if self.traitCollection.userInterfaceStyle == .dark {
            // User interface is dark
            let sharedApp = UIApplication.shared
            sharedApp.delegate?.window??.tintColor = .white
        } else {
            // User interface is light
            UINavigationBar.appearance().tintColor = .black
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.black]
        }
        
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: false)
        
    }
    
}

extension ScanController: VNDocumentCameraViewControllerDelegate {
    
    // MARK: VNDocumentCameraViewControllerDelegate
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        
        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            let sharedApp = UIApplication.shared
            sharedApp.delegate?.window??.tintColor = .black
        } else {
            // User Interface is Light
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        }
        
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        DispatchQueue.main.async {
            
            // Create PDF
            let pdfDocument = PDFDocument()
            
            for i in 0 ..< scan.pageCount {
                // Set image size
                if let image = scan.imageOfPage(at: i).resize(toWidth: 800) {
                    print("Image size is \(image.size.width), \(image.size.height)")
                    // Create a PDF page instance from your image
                    let pdfPage = PDFPage(image: image)
                    // Insert the PDF page into your document
                    pdfDocument.insert(pdfPage!, at: i)
                }
            }
            
            self.pdfView.document = pdfDocument
            
        }
        
        controller.dismiss(animated: true)
        
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Error in CameraViewController: \(error)")
        
        controller.dismiss(animated: true)
        
        navigationController?.popToRootViewController(animated: false)
        
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        
        controller.dismiss(animated: true)
        
        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            let sharedApp = UIApplication.shared
            sharedApp.delegate?.window??.tintColor = .black
        } else {
            // User Interface is Light
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.white]
        }
        
        navigationController?.popToRootViewController(animated: false)
        
    }
    
}
