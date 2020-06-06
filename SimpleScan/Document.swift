//
//  Document.swift
//  SimpleScan
//
//  Created by Aleksandr Tsebrii on 6/4/20.
//  Copyright © 2020 Aleksandr Tsebrii. All rights reserved.
//

import Foundation

struct Document {
    
    var id: String
    var name: String?
    var createDate: String
    var url: URL
    
    init(id: String, createDate: String, url: URL) {
        self.id = id
        self.createDate = createDate
        self.url = url
    }
    
}
