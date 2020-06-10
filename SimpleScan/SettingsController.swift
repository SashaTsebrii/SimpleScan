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
    
    // MARK: Properties
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let emailButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(NSLocalizedString("Report a problem", comment: ""), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(emailButtonTapped(_:)), for: .touchUpInside)
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
        
        // Scroll view
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        // Content view
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 1000),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
        ])
        
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
        
    }
    
    // MARK: Actions
    
    @objc fileprivate func emailButtonTapped(_ sender: UIButton) {
        
        sendEmail()
        
    }
    
    // MARK: Helper
    
    fileprivate func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sashatsebrii@gmail.com"])
            
            let deviceType = UIDevice().type
            print(deviceType)
            
            let systemVersion = UIDevice.current.systemVersion
            print(systemVersion)
            
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            mail.setMessageBody("<p>Device type: \(deviceType) \nSystem version: \(systemVersion) \nAppVersion: \(String(describing: appVersion))</p>", isHTML: true)
            
            present(mail, animated: true)
            
        } else {
            
            print("Error mail")
            
            let alert = UIAlertController(title: "No scan", message: "You must scan before making a PDF.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                
            })
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        }
        
    }
    
    
    
}

extension SettingsController: MFMailComposeViewControllerDelegate {
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
