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
        
        view.backgroundColor = .white
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = NSLocalizedString("List", comment: "")
        
        // Create left bar button item
        let settingsBarButton = UIBarButtonItem(title: NSLocalizedString("Settings", comment: ""), style: .plain, target: self, action: #selector(settingsBarButtonTapped(_:)))
        navigationItem.leftBarButtonItem = settingsBarButton
        
        // Create right bar button item
        let scanBarButton = UIBarButtonItem(title: NSLocalizedString("Scan", comment: ""), style: .plain, target: self, action: #selector(scanBarButtonTapped(_:)))
        navigationItem.rightBarButtonItem = scanBarButton
        
        // Set documents
        documents = [Document(name: "First", createDate: Date(timeIntervalSinceNow: 60), pdfUrl: nil),
                     Document(name: "Second", createDate: Date(timeIntervalSinceNow: 60 * 2), pdfUrl: nil),
                     Document(name: "Third", createDate: Date(timeIntervalSinceNow: 60 * 3), pdfUrl: nil),
                     Document(name: "Fourth", createDate: Date(timeIntervalSinceNow: 60 * 4), pdfUrl: nil),
                     Document(name: "Fifth", createDate: Date(timeIntervalSinceNow: 60 * 5), pdfUrl: nil)]
        collectionView.reloadData()
    
    }
    
    // MARK: Actions
    
    @objc fileprivate func settingsBarButtonTapped(_ sendr: UIBarButtonItem) {
        
        let settingsController = SettingsController()
        navigationController?.pushViewController(settingsController, animated: true)
        
    }
    
    @objc fileprivate func scanBarButtonTapped(_ sendr: UIBarButtonItem) {
        
        let scannerViewController = VNDocumentCameraViewController()
        scannerViewController.delegate = self
        present(scannerViewController, animated: true)
        
    }
    
    // MARK: Helper
    
    func craatePreviewController(for index: Int) -> PreviewController {
        
        let previewController = PreviewController()
        
        let document = documents[index]
        previewController.document = document
        
        return previewController
        
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

extension ListController: VNDocumentCameraViewControllerDelegate {
    
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
            let documentURL = documentDirectory.appendingPathComponent("Name")
            do {
                try data?.write(to: documentURL)
            } catch (let error) {
                print("Error save data to URL: \(error.localizedDescription)")
            }
        }
        
        controller.dismiss(animated: true)
                
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        print("Error in CameraViewController: \(error)")
        controller.dismiss(animated: true)
    }
    
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }
    
}
