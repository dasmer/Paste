//
//  OptionsViewController.swift
//  Paste
//
//  Created by Dasmer Singh on 1/10/16.
//  Copyright © 2016 Dastronics Inc. All rights reserved.
//

import UIKit
import MessageUI

class OptionsViewController: UITableViewController {

    // MARK: Enums

    private enum Options: Int {
        case Share
        case Rate
        case Feedback

        static var all: [Options] {
            return [.Share, .Rate, .Feedback]
        }

        var title: String {
            switch self {
            case .Share: return "Share with Friends"
            case .Rate: return "Rate on the App Store"
            case .Feedback: return "Send Feedback"
            }
        }

        var subtitle: String {
            switch self {
            case .Share: return "👯"
            case .Rate: return "⭐️"
            case .Feedback: return "📧"
            }
        }

        var analyticsTitle: String {
            switch self {
            case .Share: return "Share"
            case .Rate: return "Rate"
            case .Feedback: return "Feedback"
            }
        }

        var indexPath: NSIndexPath {
            return NSIndexPath(row: self.rawValue, section: 0)
        }
    }


    // MARK: Initializers

    init() {
        super.init(style: .grouped)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: UIViewController

    override func viewDidLoad() {
        title = "Options"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissButtonAction(sender:)))
        tableView.register(TableViewCell.self, forCellReuseIdentifier: TableViewCell.reuseIdentifier)
    }


    // MARK: UITableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Options.all.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath)
        let option = Options(rawValue: indexPath.row)
        cell.textLabel?.text = option?.title
        cell.detailTextLabel?.text = option?.subtitle
        return cell
    }


    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let option = Options(rawValue: indexPath.row) else {
            return
        }

        switch option {
        case .Share: shareAction()
        case .Rate: rateAction()
        case .Feedback: feedbackAction()
        }

        Analytics.sharedInstance.track(eventName: "Options View Cell Selected", properties: ["Type": option.analyticsTitle])
    }


    // MARK: Private Functions

    @objc private func dismissButtonAction(sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }

    private func shareAction() {
        let messageBody = "Download Paste, an app that lets you find emoji faster than ever: bit.ly/usepaste"
        if MFMessageComposeViewController.canSendText() {
            let viewController = MFMessageComposeViewController()
            viewController.messageComposeDelegate = self
            viewController.body = messageBody
            present(viewController, animated: true, completion: nil)
        } else {
            tableView.deselectRow(at: Options.Share.indexPath as IndexPath, animated: true)
            let activityController = UIActivityViewController(activityItems: [messageBody], applicationActivities: nil)
            present(activityController, animated: true, completion: nil)
        }
    }

    private func rateAction() {
        guard let url = URL(string: "https://itunes.apple.com/app/paste-emoji-search/id1070640289") else { return }
        UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)

        tableView.deselectRow(at: Options.Rate.indexPath as IndexPath, animated: false)
    }

    private func feedbackAction() {
        if MFMailComposeViewController.canSendMail() {
            let viewController = MFMailComposeViewController()
            viewController.mailComposeDelegate = self
            viewController.setToRecipients(["usepaste@gmail.com"])
            viewController.setSubject("[Paste Feedback]")
            present(viewController, animated: true, completion: nil)
        } else {
            tableView.deselectRow(at: Options.Feedback.indexPath as IndexPath, animated: true)
            let alertController = UIAlertController(title: "Send Feedback", message: "Email us at usepaste@gmail.com", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }

    private func logMessageUIComposeFinished(composeKind: MessageUIKind, resultKind: MessageUIFinishedResultKind) {
        let properties: [String: String] = [
            "Type": composeKind.rawValue,
            "Result": resultKind.rawValue,
            "Source": "Options View"
        ]
        Analytics.sharedInstance.track(eventName: "MessageUI Compose Finished", properties: properties)
    }
}


extension OptionsViewController: MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {

    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        dismiss(animated: true, completion: nil)

        logMessageUIComposeFinished(composeKind: MessageUIKind.Mail, resultKind: MessageUIFinishedResultKind(messageComposeResult: result))
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)

        logMessageUIComposeFinished(composeKind: MessageUIKind.Mail, resultKind: MessageUIFinishedResultKind(mailComposeResult: result))
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
