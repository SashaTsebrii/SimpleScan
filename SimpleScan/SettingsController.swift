//
//  SettingsController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/4/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import MessageUI

class SettingsController: UIViewController {
    
    // MARK: Variables
    
    var contentSize = CGSize.zero {
        didSet {
            
            var topSpace: CGFloat = 0
            
            if #available(iOS 11.0, *) {
                topSpace = self.view.safeAreaInsets.top
            } else {
                topSpace = self.topLayoutGuide.length
            }
            
            let size = CGSize(width: view.frame.width, height: view.frame.height - topSpace)
            
            contentSize = size
            
        }
    }
    
    // MARK: Properties
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = .white
        scrollView.contentSize = contentSize
        scrollView.autoresizingMask = .flexibleHeight
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.bounces = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.frame.size = contentSize
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(NSLocalizedString("Report a problem", comment: ""), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        // Set title
        title = NSLocalizedString("Settings", comment: "")
        
        // Set background color
        view.backgroundColor = .white
        
        // Set scrollView
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        contentView.addSubview(emailButton)
        NSLayoutConstraint.activate([
            emailButton.heightAnchor.constraint(equalToConstant: 44),
            emailButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            emailButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

       // Set title
       title = NSLocalizedString("Settings", comment: "")
        
    }
    
}
