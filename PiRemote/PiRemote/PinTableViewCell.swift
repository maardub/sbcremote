//
//  PinTableViewCell.swift
//  PiRemote
//
//  Authors: Muhammad Martinez
//  Copyright (c) 2017 JLL Consulting. All rights reserved.
//

import UIKit

class PinTableViewCell: UITableViewCell {

    @IBOutlet weak var pinNameLabel: UILabel!
    @IBOutlet weak var pinView: UIButton!
    @IBOutlet weak var valueSwitch: UISwitch!
    @IBOutlet weak var typeButton: UIButton!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: Local Functions

    @IBAction func onToggleSwitch(_ sender: UISwitch) {
        // Notifying parent view controller to update pin data in layout
        NotificationCenter.default.post(name: Notification.Name.updatePin, object: self, userInfo: [
            "id": String(pinView.tag), "value": String(sender.isOn)])
    }

    @IBAction func onToggleType(_ sender: UIButton) {
        switch sender.titleLabel!.text! {
        case "Control": typeButton.setTitle("Monitor", for: .normal)
        case "Monitor": typeButton.setTitle("Ignore", for: .normal)
        case "Ignore": typeButton.setTitle("Control", for: .normal)
        default: typeButton.setTitle("Ignore", for: .normal)
        }

        // Notifying parent view controller to update pin data in layout
        NotificationCenter.default.post(name: Notification.Name.updatePin, object: self, userInfo: [
            "id": String(pinView.tag), "function": typeButton.titleLabel!.text!])
    }


    func updateStyle(with pin: Pin) {
        pinNameLabel.text = pin.name

        pinView.layer.borderWidth = 4.0
        pinView.layer.cornerRadius = pinView.bounds.size.width / 2
        pinView.setTitle("\(pin.id)", for: UIControlState.normal)
        pinView.tag = pin.id
        pinView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 32.0)

        // Capitalzing first letter of type
        var typeFormatted = String(describing: pin.type)
        typeFormatted = String(typeFormatted.characters.prefix(1)).uppercased() + String(typeFormatted.characters.dropFirst())
        typeButton.setTitle(typeFormatted, for: .normal)

        valueSwitch.isOn = pin.value == 1
        valueSwitch.isEnabled = pin.type == .control

        var bgClr: UIColor
        var borderClr: CGColor
        switch pin.type {
        case .ignore:
            bgClr = Theme.grey300
            borderClr = Theme.grey500.cgColor
        case .monitor:
            bgClr = Theme.cyan300
            borderClr = Theme.cyan500.cgColor
        case .control:
            bgClr = pin.value == 1 ? Theme.lightGreen300 : Theme.amber300
            borderClr = pin.value == 1 ? Theme.lightGreen500.cgColor : Theme.amber500.cgColor
        }

        pinView.backgroundColor = bgClr
        pinView.layer.borderColor = borderClr
        pinView.setTitleColor(Theme.grey900, for: UIControlState.normal)
    }
}
