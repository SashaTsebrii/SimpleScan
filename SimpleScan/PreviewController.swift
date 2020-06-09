//
//  PreviewController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/4/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import PDFKit

class PreviewController: UIViewController {
    
    // MARK: Variables
    
    var document: Document?
    
    // MARK: Prpperties
    
    var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.backgroundColor = .white
        
        // Pdf view constraints
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Create right bar button item
        let shareBarButton = UIBarButtonItem(title: NSLocalizedString("Share", comment: ""), style: .plain, target: self, action: #selector(shareBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = shareBarButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = NSLocalizedString("Preview", comment: "")
        
        if let document = document, let idString = document.idString {
            
            let fileManager = FileManager.default
            if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let docURL = documentDirectory.appendingPathComponent(idString)
                if fileManager.fileExists(atPath: docURL.path) {
                    
                    if let pdfDocument = PDFDocument(url: docURL) {
                        pdfView.document = pdfDocument
                    } else {
                        print("Error no document")
                    }
                    
                } else {
                    print("Error load file from URL")
                }
                
            }
            
        } else {
            print("Error no document")
        }
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func shareBarButtonTapped(_ sender: UIBarButtonItem) {
        
        if let document = document, let idString = document.idString {
            
            let fileManager = FileManager.default
            if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                
                let docURL = documentDirectory.appendingPathComponent(idString)
                if fileManager.fileExists(atPath: docURL.path) {
                    
                    if let pdfData = NSData(contentsOf: docURL) {
                        let activityController = UIActivityViewController(activityItems: [document.nameString ?? idString, pdfData], applicationActivities: nil)
                        present(activityController, animated: true, completion: nil)
                    } else {
                        print("Error data from URL")
                    }
                    
                } else {
                    print("Error load file from URL")
                }
                
            }
            
        } else {
            print("Error no document")
        }
        
    }
    
}
