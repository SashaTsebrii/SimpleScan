//
//  ListCell.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/4/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import PDFKit

class ListCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static let identifier = "ListCell"
    
    var document: Document? {
        didSet {
            if let document = document {
                
                nameLabel.text = document.nameString
                createDateLabel.text = document.createDateString
                
                if let urlString = document.urlString {
                    
                    let url = URL(string: urlString)
                    
                    previewImageView.image = pdfThumbnail(url: url!)
                    
                }
                
            }
        }
    }
    
    // MARK: Properties
    
    var previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var createDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(createDateLabel)
        NSLayoutConstraint.activate([
            createDateLabel.heightAnchor.constraint(equalToConstant: 16),
            createDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            createDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            createDateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 18),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: createDateLabel.topAnchor)
        ])
        
        contentView.addSubview(previewImageView)
        NSLayoutConstraint.activate([
            previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: nameLabel.topAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Helper
    
    func pdfThumbnail(url: URL, width: CGFloat = 240) -> UIImage? {
        
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let docURL = documentDirectory.appendingPathComponent(document!.idString!)
            if fileManager.fileExists(atPath: docURL.path) {
                if let pdfDocument = PDFDocument(url: docURL) {
                    if let page = pdfDocument.page(at: 0) {
                        let pageSize = page.bounds(for: .mediaBox)
                        let pdfScale = width / pageSize.width
                        
                        // Apply if you're displaying the thumbnail on screen
                        let scale = UIScreen.main.scale * pdfScale
                        let screenSize = CGSize(width: pageSize.width * scale,
                                                height: pageSize.height * scale)
                        
                        return page.thumbnail(of: screenSize, for: .mediaBox)
                    } else {
                        print("Error no page")
                    }
                } else {
                    print("Error no document")
                }
            } else {
                print("Error load file from URL")
            }
            
        }
        
        return nil
        
    }
    
}
