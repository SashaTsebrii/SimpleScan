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
    fileprivate var pdfPages: [PDFPage] = []
    
    // MARK: Prpperties
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
//        collectionView.dragDelegate = self
//        collectionView.dropDelegate = self
        collectionView.dragInteractionEnabled = true
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
                        for index in 0...(pdfDocument.pageCount - 1) {
                            if let page = pdfDocument.page(at: index) {
                                pdfPages.append(page)
                            }
                        }
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
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLognPressGesture(_ :)))
        collectionView.addGestureRecognizer(longPressGesture)
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func saveBarButtonTapped(_ sendr: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    
    // MARK: Gesture
    
    @objc fileprivate func handleLognPressGesture(_ sender: UILongPressGestureRecognizer) {
        
        switch sender.state {
        case .began:
            guard let targetIndexPath = collectionView.indexPathForItem(at: sender.location(in: collectionView)) else {
                return
            }
            collectionView.beginInteractiveMovementForItem(at: targetIndexPath)
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(sender.location(in: collectionView))
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
        
    }
    
}

extension EditController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout /*UICollectionViewDragDelegate, UICollectionViewDropDelegate*/ {
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pdfPages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditCell.identifier, for: indexPath) as? EditCell else {
            fatalError("Unexpected cell instead of ListCell")
        }
        
        if pdfPages.count > 0 {
            let page = pdfPages[indexPath.row]
            cell.page = page
            cell.pageOfPages = (indexPath.row, pdfPages.count)
            cell.delegate = self
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
    
    // MARK:  UICollectionViewDragDelegate
    
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = collectionView == collectionView1 ? self.items1[indexPath.row] : self.items2[indexPath.row]
//        let itemProvider = NSItemProvider(object: item as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
//        let item = collectionView == collectionView1 ? self.items1[indexPath.row] : self.items2[indexPath.row]
//        let itemProvider = NSItemProvider(object: item as NSString)
//        let dragItem = UIDragItem(itemProvider: itemProvider)
//        dragItem.localObject = item
//        return [dragItem]
//    }
//
//    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
//        if collectionView == collectionView1 {
//            let previewParameters = UIDragPreviewParameters()
//            previewParameters.visiblePath = UIBezierPath(rect: CGRect(x: 25, y: 25, width: 120, height: 120))
//            return previewParameters
//        }
//        return nil
//    }
    
    // MARK: UICollectionViewDropDelegate
    
//    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
//
//    }
//
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//
//        if let pdfDocument = pdfDocument {
//            if let page = pdfDocument.page(at: sourceIndexPath.row) {
//                pdfDocument.removePage(at: sourceIndexPath.row)
//                pdfDocument.insert(page, at: destinationIndexPath.row)
//            }
//        }
//
//    }
    
}

extension EditController: EditCellDelegate {
    
    func tapDeleteButton(at cell: EditCell) {
        let indexPath = collectionView.indexPath(for: cell)
        print(indexPath ?? "indexPath is nil")
    }
    
}
