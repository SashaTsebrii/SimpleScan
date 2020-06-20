//
//  EditController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/20/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import PDFKit

class EditController: UIViewController {
    
    // MARK: Variables
    
    var document: Document?
    var pdfDocument: PDFDocument?
    
    // MARK: Prpperties
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(EditCell.self, forCellWithReuseIdentifier: EditCell.identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Set background color
        view.backgroundColor = UIColor.Design.background
        
        // Set title
        title = NSLocalizedString("Edit", comment: "")
        
        // Collection view constraints
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Create right bar button item
        let saveBarButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBarButtonTapped(_:)))
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
                        self.pdfDocument = pdfDocument
                        self.collectionView.reloadData()
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
    
    @objc fileprivate func saveBarButtonTapped(_ sendr: UIBarButtonItem) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
}

extension EditController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let pageCount = pdfDocument?.pageCount {
            return pageCount
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditCell.identifier, for: indexPath) as? EditCell else {
            fatalError("Unexpected cell instead of ListCell")
        }
        
        if let pdfDocument = pdfDocument {
            let page = pdfDocument.page(at: indexPath.row)
            cell.page = page
            cell.pageOfPages = (indexPath.row, pdfDocument.pageCount)
        }
        
        return cell
        
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var optimalWidth: CGFloat = 0
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            // iPhone
            optimalWidth = view.bounds.width - 16
        } else if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad
            optimalWidth = view.bounds.width - 32
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

