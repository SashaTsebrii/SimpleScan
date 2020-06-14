//
//  CellPreviewController.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/15/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import UIKit

class CellPreviewController: UIViewController {
    
    private let imageView = UIImageView()

    override func loadView() {
        view = imageView
    }

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)

        // Set up our image view and display the pupper
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.image = image

        // By setting the preferredContentSize to the image size, the preview will have the same aspect ratio as the image
        preferredContentSize = image.size
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
