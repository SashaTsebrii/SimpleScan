//
//  SettingsController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/4/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit
import MessageUI
import CoreData

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
    
    fileprivate let rateButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(NSLocalizedString("Rate the app", comment: ""), for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(rateButtonTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let deleteButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle(NSLocalizedString("Delete all scans", comment: ""), for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.contentHorizontalAlignment = .left
        button.addTarget(self, action: #selector(deleteButtonTapped(_:)), for: .touchUpInside)
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
        
        contentView.addSubview(rateButton)
        NSLayoutConstraint.activate([
            rateButton.heightAnchor.constraint(equalToConstant: 44),
            rateButton.topAnchor.constraint(equalTo: emailButton.bottomAnchor, constant: 16),
            rateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            rateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.topAnchor.constraint(equalTo: rateButton.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
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
    
    @objc fileprivate func rateButtonTapped(_ sender: UIButton) {
        
        let appleID = "1154366081"
        let url = "https://itunes.apple.com/app/id\(appleID)?action=write-review"
        if let path = URL(string: url) {
                UIApplication.shared.open(path, options: [:], completionHandler: nil)
        }
        
    }
    
    @objc fileprivate func deleteButtonTapped(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: NSLocalizedString("Are you sure?", comment: ""), message: NSLocalizedString("All pdf documents that are in this application will be deleted. Delete all pdf documents?", comment: ""), preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("Delete", comment: ""), style: .destructive) { (_) in
            
            self.deleteAllData()
            
        }
        alertController.addAction(deleteAction)
        
        let settingsAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .default) { (_) in
            
        }
        alertController.addAction(settingsAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // MARK: Helper
    
    fileprivate func sendEmail() {
        
        if MFMailComposeViewController.canSendMail() {
            
            // Get device type
            let deviceType = UIDevice().type
            
            // Get syste version
            let systemVersion = UIDevice.current.systemVersion
            
            // Get app version
            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            // Create and set MFMailComposeViewController
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["sashatsebrii@gmail.com"])
            mail.setMessageBody("<p>Device type: \(deviceType)</p><p>System version: \(systemVersion)</p><p>AppVersion: \(appVersion ?? "")</p>", isHTML: true)
            mail.setSubject("SimpleScan - Report a problem")
            
            present(mail, animated: true)
            
        } else {
            
            print("Error mail")
            
            let alertController = UIAlertController(title: NSLocalizedString("Email error", comment: ""), message: NSLocalizedString("Please make sure you add the email address in the settings.", comment: ""), preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { (_) in
                
            }
            alertController.addAction(okAction)
            
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (_) in
                
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
    
    func deleteAllData() {
        
        // Get reference to AppDelegatesrefer
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }

        // Create a context
        let managedContext = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.kDocument.entityName)
        fetchRequest.predicate = NSPredicate(format: "\(Constants.kDocument.nameString) = %@", "No name")

        do {
            let documents = try managedContext.fetch(fetchRequest)
            for document in documents {
                guard let document = document as? Document else {
                    continue
                }
                managedContext.delete(document)
            }
        } catch {
            print(error)
        }
        
    }
    
}

extension SettingsController: MFMailComposeViewControllerDelegate {
    
    // MARK: MFMailComposeViewControllerDelegate
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
}
