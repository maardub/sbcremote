//
//  PopoverFactory
//  PiRemote
//
//  Created by Muhammad Martinez on 4/1/17.
//  Copyright © 2017 JLL Consulting. All rights reserved.
//

import UIKit

// Handles events that occur in certain popovers using NSNotificationCenter
class PopoverViewController: UIViewController {

    static let storyboardName = "DeviceSetup"

    var savedLayoutNames: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Loads appropriate diagram if needed
        if self.title == "Pinout Diagram" {
            _buildContentDiagram()
        }
    }

    // MARK: Local Functions

    @IBAction func onClear(_ sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: Notification.Name.clear, object: nil)
    }

    @IBAction func onDismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSave(_ sender: UIBarButtonItem) {
        let textfield = self.view.subviews.filter({vw in vw is UITextField}).first as! UITextField

        guard !(textfield.text?.isEmpty)! else {
            // Showing error message
            let snackbar = self.view.subviews.filter({vw in vw.restorationIdentifier == "SaveSnackbar" }).first
            let errorLabel = snackbar?.subviews.filter({vw in vw is UILabel}).first as! UILabel
            errorLabel.text = "Please enter a name"
            snackbar?.isHidden = false
            return
        }

        let userInfo = ["text": textfield.text!]
        NotificationCenter.default.post(name: Notification.Name.save, object: self, userInfo: userInfo)
    }

    func _buildContentDiagram() {
        let diagram = UIImage(named: getFilePathToPinDiagram())

        // TODO: Update subviews based on picker value in DeviceSetup
        let imageView = self.view.subviews.filter({vw in vw is UIImageView}).first as! UIImageView

        // Order is important: resizes content after the image has been added to it.
        imageView.image = diagram
        imageView.contentMode = .scaleAspectFit
    }

    func getFilePathToPinDiagram() -> String {
        // Only supports Raspberry Pi 3
        return PiFilePaths.rPi3
    }

    // MARK: Utility Functions

    static func buildPopover(source: AnyObject, content: UIViewController, contentSize: CGSize, sourceRect: CGRect?) -> UIViewController {
        // Display like an alert
        content.modalPresentationStyle = .popover
        content.modalTransitionStyle = .crossDissolve
        content.preferredContentSize = contentSize

        // Modifies the controller which will contain content
        let popover = content.popoverPresentationController!
        popover.delegate = source as? UIPopoverPresentationControllerDelegate
        popover.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)  // Hides arrow
        popover.sourceView = (source as! UIViewController).view

        // Positions in center of parent
        let size = (source as! UIViewController).view.bounds.size
        popover.sourceRect = sourceRect != nil ? sourceRect! : CGRect(origin: CGPoint.zero, size: size)

        return content
    }
}
