//
//  SearchViewController
//  Paste
//
//  Created by Dasmer Singh on 12/20/15.
//  Copyright © 2015 Dastronics Inc. All rights reserved.
//

import UIKit
import SVProgressHUD

final class SearchViewController: UIViewController {

    // MARK: - Properties

    private var results: [Emoji] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    private var recents: [Emoji] {
        set {
            RecentEmojiStore.set(newValue)
        }

        get {
            return RecentEmojiStore.get()
        }
    }

    private lazy var searchView: SearchView = {
        let view = SearchView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.placeholder = "Type an emoji name to search"
        view.backgroundColor = .whiteColor()
        view.delegate = self
        return view
    }()

    private lazy var tableViewController: UITableViewController = {
        let viewController = UITableViewController()
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        viewController.tableView.dataSource = self
        viewController.tableView.delegate = self
        return viewController
    }()

    private lazy var fetcher: EmojiFetcher = {
        return EmojiFetcher()
    }()

    private var tableView: UITableView {
        return tableViewController.tableView
    }


    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Emoji Search"
        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = .whiteColor()

        view.addSubview(searchView)

        let separatorView = UIView(frame: .zero)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = .grayColor()
        view.addSubview(separatorView)

        addChildViewController(tableViewController)
        view.addSubview(tableViewController.view)
        tableViewController.didMoveToParentViewController(self)

        let views: [String: AnyObject] = [
            "topLayoutGuide": topLayoutGuide,
            "searchView": searchView,
            "separatorView": separatorView,
            "tableView": tableViewController.view
        ]

        var constraints = [NSLayoutConstraint]()
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchView]|", options: [], metrics: nil, views: views)
                constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: nil, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[topLayoutGuide][searchView(50)][separatorView(1)][tableView]|", options: [], metrics: nil, views: views)
        NSLayoutConstraint.activateConstraints(constraints)

        reset()
        searchView.becomeFirstResponder()
    }


    // MARK: - Private

    func reset() {
        searchView.text = nil
        results = recents
    }

}


extension SearchViewController: SearchViewDelegate {

    func searchView(searchView: SearchView, didChangeText text: String) {
        if (text.characters.count > 0) {
            fetcher.query(text) { [weak self] in
                self?.results = $0
            }
        } else {
            reset()
        }
    }

    func searchViewWillClearText(searchView: SearchView) {
        reset()
    }
}


extension SearchViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "")
        let emoji = self.results[indexPath.row]
        cell.textLabel?.text = emoji.character
        cell.detailTextLabel?.text = emoji.name
        return cell
    }
}


extension SearchViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        guard let cell = tableView.cellForRowAtIndexPath(indexPath),
            text = cell.textLabel?.text else { return }

        UIPasteboard.generalPasteboard().string = text

        SVProgressHUD.showSuccessWithStatus("Copied \(text)")

        let properties = [
            "Emoji Character": text,
            "Search Text": searchView.text ?? ""
        ]
        Analytics.sharedInstance.track("Emoji Selected", properties: properties)

        let newRecents = [self.results[indexPath.row]] + recents
        recents = newRecents
        reset()
    }
}
