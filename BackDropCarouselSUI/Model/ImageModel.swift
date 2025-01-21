//
//  ImageModel.swift
//  BackDropCarouselSUI
//
//  Created by Kirill Khomicevich on 21.01.2025.
//

import SwiftUI

struct ImageModel: Identifiable {
    let id: String = UUID().uuidString
    let altText: String
    let image: String
    
    static let imageModels: [ImageModel] = [
        ImageModel(altText: "1", image: "1"),
        ImageModel(altText: "2", image: "2"),
        ImageModel(altText: "3", image: "3"),
        ImageModel(altText: "4", image: "4")
    ]
}
