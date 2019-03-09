//
//  GalleryViewController.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

private let cellIdentifier = "cellIdentifier"

class GalleryViewController: UIViewController, PushPopAnimatable {
    let collection: UICollectionView = {
        let column: CGFloat = 2
        let space: CGFloat = 2
        let flowLayout = UICollectionViewFlowLayout()
        let sideMagin = space * 2
        let totalInteritemSpace = (space * (column - 1))
        let cellWidth = (UIScreen.main.bounds.width - sideMagin - totalInteritemSpace) / column
        let cellHeight = cellWidth * 0.75
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        flowLayout.minimumLineSpacing = space
        flowLayout.minimumInteritemSpacing = space
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = UIEdgeInsets(
            top: space,
            left: space,
            bottom: space,
            right: space)
        let collectionView = UICollectionView(
            frame: UIScreen.main.bounds,
            collectionViewLayout: flowLayout)
        collectionView.register(GalleryViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()

    /// PushPopAnimatable property
    var animationTargetView: UIView?
    /// PushPopAnimatable property
    var animationTargetFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "First View"
        view.backgroundColor = .white
        view.addSubview(collection)
        collection.frame = view.bounds
        collection.delegate = self
        collection.dataSource = self
    }
}

extension GalleryViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GalleryViewCell
        animationTargetView = cell.imageView
        animationTargetFrame = cell.imageView.ext.absoluteFrame
        let viewController = DetailViewController(image: cell.imageView.image!)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension GalleryViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath) as! GalleryViewCell
        let name = String(format: "cat%02d.jpg", (indexPath.item + 1))
        cell.imageView.image = UIImage(named: name)
        return cell
    }
}
