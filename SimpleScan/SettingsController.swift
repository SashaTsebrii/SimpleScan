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
    fileprivate let scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.backgroundColor = UIColor.clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    fileprivate let contentView: UIView = {
        let view = UIView(frame: .zero)
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
    
    fileprivate let appVersionLabel: UILabel = {
        let label = UILabel(frame: .zero)
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            label.text = NSLocalizedString("App version: \(String(describing: appVersion))", comment: "")
        }
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        
        contentView.addSubview(appVersionLabel)
        NSLayoutConstraint.activate([
            appVersionLabel.heightAnchor.constraint(equalToConstant: 16),
            appVersionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            appVersionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            appVersionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var navigationBarHeight: CGFloat = 0
        if #available(iOS 11.0, *) {
            navigationBarHeight = self.view.safeAreaInsets.top
        } else {
            navigationBarHeight = self.topLayoutGuide.length
        }
        
        let statusBarHeight = view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0

        let contentHeight = view.bounds.height - navigationBarHeight - statusBarHeight
                
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: contentHeight)
        ])
        
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
            
            let alertController = UIAlertController(title: "Email error", message: "Please make sure you add the email address in the settings.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                
            })
            alertController.addAction(okAction)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)")
                    })
                }
                
            }
            alertController.addAction(settingsAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
        
    }
    
}

extension SettingsController: MFMailComposeViewControllerDelegate {
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
