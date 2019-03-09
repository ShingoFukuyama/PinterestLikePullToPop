//
//  DetailViewCell.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

class DetailViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = UIColor.yellow
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(titleLabel)
        titleLabel.ext.addEdgeConstraints(left: 20, right: 20)
    }

    @available(*, unavailable, message: "NSCoding not supported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
