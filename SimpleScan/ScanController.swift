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

class ScanController: UIViewController {
    
    // MARK: Properties
    
    var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
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
            
            // TODO: Remove document path
            
        }
    }
    
    // MARK: Actions
    
    @objc fileprivate func saveBarButtonTapped(_ sender: UIBarButtonItem) {
        
        // TODO: Save document to CoreData maby create delegate to say collectionView in ListController to update data.
        
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: Helper
    
    fileprivate func scan() {
        
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: false)
        
    }
    
    fileprivate func pdf() {
        
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let docURL = documentDirectory.appendingPathComponent(Constants.fileName)
            if fileManager.fileExists(atPath: docURL.path) {
                pdfView.document = PDFDocument(url: docURL)
            } else {
                print("Error load file from URL")
            }
            
        }
        
    }
    
}

extension ScanController: VNDocumentCameraViewControllerDelegate {
    
    // MARK: VNDocumentCameraViewControllerDelegate
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        guard scan.pageCount >= 1 else {
            controller.dismiss(animated: true)
            return
        }
        
        DispatchQueue.main.async {
            
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
            
            // Get the raw data of your PDF document
            let data = pdfDocument.dataRepresentation()
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let documentURL = documentDirectory.appendingPathComponent(Constants.fileName)
            do {
                try data?.write(to: documentURL)
            } catch (let error) {
                print("Error save data to URL: \(error.localizedDescription)")
            }
        }
        
        controller.dismiss(animated: true)
        
        pdf()
        
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Error in CameraViewController: \(error)")
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
}

// MARK: Constants

struct Constants {
    static let fileName = "Last_scanned_document.pdf"
}
