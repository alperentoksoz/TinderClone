//
//  ProfileCell.swift
//  TinderCloneFinal
//
//  Created by Alperen Toksöz on 7.04.2020.
//  Copyright © 2020 Alperen Toksöz. All rights reserved.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "jane2")
        
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
