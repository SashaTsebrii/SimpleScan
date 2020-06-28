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
    
    // MARK: Prpperties
    
    fileprivate let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = true
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let contentView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    fileprivate let canvasView: CanvasView = {
        let canvasView = CanvasView()
        canvasView.backgroundColor = .clear
        canvasView.translatesAutoresizingMaskIntoConstraints = false
        return canvasView
    }()
    
    fileprivate let undoButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "undo"), for: .normal)
        button.addTarget(self, action: #selector(undoButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let clearButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "clear"), for: .normal)
        button.addTarget(self, action: #selector(clearButtonTapped(_:)), for: .touchUpInside)
        button.backgroundColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Set title
        title = NSLocalizedString("Annotation", comment: "")
        
        // Set background color
        view.backgroundColor = UIColor.Design.background
        
        // clearButton
        view.addSubview(clearButton)
        NSLayoutConstraint.activate([
            clearButton.widthAnchor.constraint(equalToConstant: 44),
            clearButton.heightAnchor.constraint(equalTo: clearButton.widthAnchor),
            clearButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            clearButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
        
        // undoButton
        view.addSubview(undoButton)
        NSLayoutConstraint.activate([
            undoButton.widthAnchor.constraint(equalToConstant: 44),
            undoButton.heightAnchor.constraint(equalTo: undoButton.widthAnchor),
            undoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            undoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // scrollView
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.heightAnchor.constraint(equalToConstant: 44),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: clearButton.trailingAnchor, constant: 1),
            scrollView.trailingAnchor.constraint(equalTo: undoButton.leadingAnchor, constant: -1)
        ])
        
        // Content view
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalToConstant: 700),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
        // penButton
        let penButton = UIButton(frame: .zero)
        penButton.setImage(UIImage(named: "pen"), for: .normal)
        penButton.addTarget(self, action: #selector(penButtonTapped(_:)), for: .touchUpInside)
        penButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(penButton)
        NSLayoutConstraint.activate([
            penButton.widthAnchor.constraint(equalToConstant: 44),
            penButton.heightAnchor.constraint(equalTo: penButton.widthAnchor),
            penButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            penButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // markerButton
        let markerButton = UIButton(frame: .zero)
        markerButton.setImage(UIImage(named: "marker"), for: .normal)
        markerButton.addTarget(self, action: #selector(markerButtonTapped(_:)), for: .touchUpInside)
        markerButton.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(markerButton)
        NSLayoutConstraint.activate([
            markerButton.widthAnchor.constraint(equalToConstant: 44),
            markerButton.heightAnchor.constraint(equalTo: markerButton.widthAnchor),
            markerButton.leadingAnchor.constraint(equalTo: penButton.trailingAnchor, constant: 4),
            markerButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        // Pdf view constraints
        view.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: scrollView.bottomAnchor),
            pdfView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Canvas view constraints
        view.addSubview(canvasView)
        NSLayoutConstraint.activate([
            canvasView.topAnchor.constraint(equalTo: pdfView.topAnchor),
            canvasView.leadingAnchor.constraint(equalTo: pdfView.leadingAnchor),
            canvasView.trailingAnchor.constraint(equalTo: pdfView.trailingAnchor),
            canvasView.bottomAnchor.constraint(equalTo: pdfView.bottomAnchor)
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
        /*
        guard let page = pdfView.currentPage else {return}
        // Create a rectangular path
        // Note that in PDF page coordinate space, (0,0) is the bottom left corner of the page
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 100, height: 100))
        let inkAnnotation = PDFAnnotation(bounds: page.bounds(for: pdfView.displayBox), forType: .ink, withProperties: nil)
        inkAnnotation.add(path)
        page.addAnnotation(inkAnnotation)
        */
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func saveBarButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func undoButtonTapped(_ sender: UIButton) {
        canvasView.undo()
    }
    
    @objc func clearButtonTapped(_ sender: UIButton) {
        canvasView.clear()
    }
    
//    @objc fileprivate func handleColorChange(_ sender: UIButton) {
//        canvasView.setStrokeColor(color: sender.backgroundColor ?? .black)
//    }
//    
//    @objc fileprivate func handleSliderChange(_ sender: UISlider) {
//        canvasView.setStrokeWidth(width: sender.value)
//    }
    
    @objc fileprivate func penButtonTapped(_ sender: UIButton) {
        
        // Add the bottom colors view
        setUpPenController()
        
    }
    
    @objc fileprivate func markerButtonTapped(_ sender: UIButton) {
        
        // Add the bottom colors view
        setUpMarkerController()
        
    }
    
    // MARK: Helper
    
    func setUpPenController() {
        
        // Init colorsController
        let penController = PenController()

        // Add bottomSheetVC as a child view
        addChild(penController)
        view.addSubview(penController.view)
        penController.didMove(toParent: self)

        // Adjust colorsController frame and initial position
        let height = view.frame.height
        let width  = view.frame.width
        penController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
        
    }
    
    func setUpMarkerController() {
        
        let markerController =  MarkerController()
        
        addChild(markerController)
        view.addSubview(markerController.view)
        markerController.didMove(toParent: self)

        let height = view.frame.height
        let width  = view.frame.width
        markerController.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
        
    }
    
}
