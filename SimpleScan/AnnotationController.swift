//
//  AnnotationController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/22/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import PDFKit

class AnnotationController: UIViewController {
    
    // MARK: Variables
    
    var document: Document?
    
    fileprivate let canvas = Canvas()
    
    // MARK: Prpperties
    
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
        
        // Set title
        title = NSLocalizedString("Annotation", comment: "")
        
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
        
        // Create save bar button item
        let saveButton = UIButton(frame: .zero)
        saveButton.tintColor = .white
        saveButton.setImage(UIImage(named: "save"), for: .normal)
        saveButton.addTarget(self, action: #selector(saveBarButtonTapped(_:)), for: .touchUpInside)
        let saveBarButton = UIBarButtonItem(customView: saveButton)
        navigationItem.rightBarButtonItem = saveBarButton
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        guard let page = pdfView.currentPage else {return}
        // Create a rectangular path
        // Note that in PDF page coordinate space, (0,0) is the bottom left corner of the page
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
        let inkAnnotation = PDFAnnotation(bounds: page.bounds(for: pdfView.displayBox), forType: .ink, withProperties: nil)
        inkAnnotation.add(path)
        page.addAnnotation(inkAnnotation)
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func saveBarButtonTapped(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}
