//
//  GalleryViewCell.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

class GalleryViewCell: UICollectionViewCell {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.ext.addEdgeConstraints()
    }

    @available(*, unavailable, message: "NSCoding not supported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
