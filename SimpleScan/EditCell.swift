//
//  EditCell.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/20/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import PDFKit

class EditCell: UICollectionViewCell {
    
    // MARK: Variables
    
    static let identifier = "EditCell"
    
    var page: PDFPage? {
        didSet {
            if let page = page {
                let pdfDocument = PDFDocument()
                pdfDocument.insert(page, at: 0)
                pdfView.document = pdfDocument
            }
        }
    }
    
    var pageOfPages: (current: Int, total: Int)? {
        didSet {
            if let pageOfPages = pageOfPages {
                pageNumberLabel.text = "\(String(pageOfPages.current + 1))/\(String(pageOfPages.total))"
            }
        }
    }
    
    // MARK: Properties
    
    var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.backgroundColor = .clear
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        pdfView.isUserInteractionEnabled = false
        pdfView.displayMode = .singlePage
        pdfView.pageShadowsEnabled = false
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        return pdfView
    }()
    
    fileprivate var pageNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(pageNumberLabel)
        NSLayoutConstraint.activate([
            pageNumberLabel.heightAnchor.constraint(equalToConstant: 18),
            pageNumberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        contentView.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: pageNumberLabel.topAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}
