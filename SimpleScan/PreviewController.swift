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
        
        if let document = document {
            
            if let idString = document.value(forKeyPath: "idString") as? String, let urlString = document.value(forKeyPath: "urlString") as? String {
                            
                let fileManager = FileManager.default
                
                if let url = URL(string: urlString) {
                    
                    let fullUrl = url.appendingPathComponent(idString)
                    if fileManager.fileExists(atPath: fullUrl.path) {
                        pdfView.document = PDFDocument(url: fullUrl)
                    } else {
                        print("Error load file from URL")
                    }
                    
                }
                
            }
            
        }
        
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func shareBarButtonTapped(_ sender: UIBarButtonItem) {
        
        
        
    }
    
}
