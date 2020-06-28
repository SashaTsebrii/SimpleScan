//
//  EditCell.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/20/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import PDFKit

protocol EditCellDelegate {
    func tapDeleteButton(at cell: EditCell)
}

class EditCell: UICollectionViewCell {
    
    // MARK: Variables
    
    var delegate: EditCellDelegate?
    
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
                
                if pageOfPages.current + 1 != pageOfPages.total {
                    drawDashLine(start: CGPoint(x: contentView.bounds.minX, y: contentView.bounds.maxX), end: CGPoint(x: contentView.bounds.maxX, y: contentView.bounds.maxY), view: contentView)
                }
            }
        }
    }
    
    // MARK: Properties
    
    fileprivate let pdfView: PDFView = {
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
    
    fileprivate let pageNumberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .gray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let moveImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "move")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate let deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: "delete"), for: .normal)
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .clear
        
        contentView.addSubview(pageNumberLabel)
        NSLayoutConstraint.activate([
            pageNumberLabel.heightAnchor.constraint(equalToConstant: 18),
            pageNumberLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            pageNumberLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
        
        contentView.addSubview(pdfView)
        NSLayoutConstraint.activate([
            pdfView.topAnchor.constraint(equalTo: contentView.topAnchor),
            pdfView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            pdfView.bottomAnchor.constraint(equalTo: pageNumberLabel.topAnchor, constant: -4)
        ])
        
        contentView.addSubview(moveImageView)
        NSLayoutConstraint.activate([
            moveImageView.widthAnchor.constraint(equalToConstant: 32),
            moveImageView.heightAnchor.constraint(equalTo: moveImageView.widthAnchor),
            moveImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            moveImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
        
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 32),
            deleteButton.heightAnchor.constraint(equalTo: deleteButton.widthAnchor),
            deleteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {

        guard isUserInteractionEnabled else { return nil }
        guard !isHidden else { return nil }
        guard alpha >= 0.01 else { return nil }
        guard self.point(inside: point, with: event) else { return nil }
        
        if deleteButton.point(inside: convert(point, to: deleteButton), with: event) {
            return deleteButton
        }
        
        return super.hitTest(point, with: event)
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func deleteButtonTapped(_ sender: UIButton) {
        delegate?.tapDeleteButton(at: self)
    }
    
    // MARK: Helper
    
    func drawDashLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 1
        // 5 is the length of dash & 5 is length of the gap
        shapeLayer.lineDashPattern = [5, 5]

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
        
    }
    
}
