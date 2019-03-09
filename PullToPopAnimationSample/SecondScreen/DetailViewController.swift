//
//  DetailViewController.swift
//  PinterestLikePullToPop
//
//  Created by Shingo Fukuyama
//

import UIKit

private let cellIdentifier = "cellIdentifier"

class DetailViewController: UIViewController,
    PushPopAnimatable
{
    /// PushPopAnimatable property
    var animationTargetView: UIView? {
        return imageView
    }
    /// PushPopAnimatable property
    var animationTargetFrame: CGRect? {
        let view = imageView
        return view.ext.absoluteFrame
    }

    var pullToPopAnimator: PullToPopAnimator?

    let imageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()

    let table: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.register(
            DetailViewCell.self,
            forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()

    deinit {
        print("\(#file):\(#line) deinited")
    }

    @available(*, unavailable, message: "NSCoding not supported")
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("init(coder:) has not been implemented")
    }

    @available(*, unavailable, message: "NSCoding not supported")
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(image: UIImage) {
        super.init(nibName: nil, bundle: nil)
        self.imageView.image = image
    }

    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        guard let window = UIApplication.shared.keyWindow,
            let navigation = parent as? UINavigationController,
            navigation.viewControllers.count > 1,
            let previous = navigation.viewControllers[
                navigation.viewControllers.count - 2
                ] as? PushPopAnimatableViewController,
            let previousTargetView = previous.animationTargetView,
            let previousTargetFrame = previous.animationTargetFrame
            else {
                return
        }
        // take a snapshot for animation without the target image
        previousTargetView.isHidden = true
        let previousScreenView = window.ext.asImageView()
        previousTargetView.isHidden = false
        pullToPopAnimator = PullToPopAnimator(
            targetView: imageView,
            scrollView: table,
            destinationFrame: previousTargetFrame,
            previousScreenView: previousScreenView,
            delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Second View"
        view.backgroundColor = .white

        view.addSubview(table)
        table.frame = view.bounds
        table.delegate = self
        table.dataSource = self
        let imageWidth = UIScreen.main.bounds.width
        let imageHeight = imageWidth * 0.75
        table.contentInset = UIEdgeInsets(
            top: imageHeight,
            left: 0,
            bottom: 0,
            right: 0)
        table.addSubview(imageView)
        imageView.frame = CGRect(
            x: 0,
            y: -imageHeight,
            width: imageWidth,
            height: imageHeight)
    }
}

extension DetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
}

extension DetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DetailViewCell
        cell.titleLabel.text = UUID().uuidString
        cell.contentView.backgroundColor = UIColor.ext.random.ext.with(alpha: 0.5)
        cell.titleLabel.textColor = UIColor.darkGray
        return cell
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension DetailViewController: PullToPopAnimatable { }
