//
//  IdeasCategory.swift
//  HeaderBlock
//
//  Created by Sergey Desenko on 14.01.2022.
//

import UIKit

struct IdeaCategory {
    let name: String
    let image: Image
}

//misc
struct Image: Codable, Equatable, Hashable {
    
    let url: String
    let size: CGSize
    
    static var empty: Image {
        Image(url: "", size: .zero)
    }
}

extension CGSize: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
}
