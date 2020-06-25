//
//  MarkerController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/25/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class MarkerController: UIViewController {
    
    // MARK: Variables
    
    let fullView: CGFloat = 100
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (name.frame.maxY + UIApplication.shared.statusBarFrame.height)
    }
    
    // MARK: Properties
    
    fileprivate let holdView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 2
        view.layer.masksToBounds = true
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let name: UILabel = {
        let label = UILabel()
        label.text = "Marker"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let redButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .red
        button.layer.borderWidth = 1
//        button.addTarget(self, action: #selector(handleColorChange(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let greenButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .green
        button.layer.borderWidth = 1
//        button.addTarget(self, action: #selector(handleColorChange(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let blueButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.layer.cornerRadius = 16
        button.layer.masksToBounds = true
        button.backgroundColor = .blue
        button.layer.borderWidth = 1
//        button.addTarget(self, action: #selector(handleColorChange(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 10
//        slider.addTarget(self, action: #selector(handleSliderChange(_:)), for: .valueChanged)
        return slider
    }()
    
    
    // MARK: Lifecycle
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(holdView)
        NSLayoutConstraint.activate([
            holdView.widthAnchor.constraint(equalToConstant: 64),
            holdView.heightAnchor.constraint(equalToConstant: 4),
            holdView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            holdView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8)
        ])
        
        let colorsStack = UIStackView(arrangedSubviews: [redButton, greenButton, blueButton])
        colorsStack.spacing = 4
        colorsStack.distribution = .fillEqually
        colorsStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(colorsStack)
        NSLayoutConstraint.activate([
            colorsStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            colorsStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            colorsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
        view.addGestureRecognizer(gesture)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareBackgroundView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 0.6, animations: { [weak self] in
            let frame = self?.view.frame
            let yComponent = self?.partialView
            self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    fileprivate func close(_ sender: AnyObject) {
        
        UIView.animate(withDuration: 0.3, animations: {
            let frame = self.view.frame
            self.view.frame = CGRect(x: 0, y: self.partialView, width: frame.width, height: frame.height)
        })
        
    }
    
    @objc fileprivate func handleColorChange(_ sender: UIButton) {
//        canvasView.setStrokeColor(color: sender.backgroundColor ?? .black)
    }
    
    @objc fileprivate func handleSliderChange(_ sender: UISlider) {
//        canvasView.setStrokeWidth(width: sender.value)
    }
    
    // MARK: Gestures
    
    @objc func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        let y = self.view.frame.minY
        if ( y + translation.y >= fullView) && (y + translation.y <= partialView ) {
            self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
            recognizer.setTranslation(CGPoint.zero, in: self.view)
        }
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                if  velocity.y >= 0 {
                    self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
                }, completion: nil)
        }
    }
    
    // MARK: Helper
    
    func prepareBackgroundView() {
        
        let blurEffect = UIBlurEffect.init(style: .dark)
        let visualEffect = UIVisualEffectView.init(effect: blurEffect)
        let bluredView = UIVisualEffectView.init(effect: blurEffect)
        bluredView.contentView.addSubview(visualEffect)
        
        visualEffect.frame = UIScreen.main.bounds
        bluredView.frame = UIScreen.main.bounds
        
        view.insertSubview(bluredView, at: 0)
        
    }

}
