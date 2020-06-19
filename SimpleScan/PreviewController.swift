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
        pdfView.backgroundColor = .white
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
        
        // Pdf view constraints
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Create right bar button item
        let shareBarButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareBarButtonTapped(_:)))
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
                        if let firstPage = pdfDocument.page(at: 0) {
                            let firstPageBounds = firstPage.bounds(for: pdfView.displayBox)
                            DispatchQueue.main.async {
                                self.pdfView.go(to: CGRect(x: 0, y: firstPageBounds.height, width: 0, height: 0), on: firstPage)
                            }
                        }
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
                        
                        // Set up activity view controller
                        let activityViewController = UIActivityViewController(activityItems: [pdfData], applicationActivities: nil)
                        
                        // So that iPads won't crash
                        activityViewController.popoverPresentationController?.sourceView = self.view

                        // Exclude some activity types from the list (optional)
                        activityViewController.excludedActivityTypes = []

                        // Present the view controller
                        self.present(activityViewController, animated: true, completion: nil)
                        
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
