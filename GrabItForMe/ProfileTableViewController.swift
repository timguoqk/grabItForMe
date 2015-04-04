//
//  ProfileTableViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController, UITextFieldDelegate {
    
    enum PTVCRows: Int {
        case Name = 0, College, HomeAddress, Phone, count
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override init() {
        super.init(style: UITableViewStyle.Plain)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PTVCRows.count.rawValue
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        var textField = UITextField()
        textField.delegate = self
        textField.tag = indexPath.row
//        cell.accessoryView = textField.viewForBaselineLayout()
        if let row = PTVCRows(rawValue: indexPath.row) {
            // set up the cell
            switch (row) {
            case .Name:
                cell.textLabel?.text = "Name"
                break;
            case .College:
                cell.textLabel?.text = "College"
                break;
            case .HomeAddress:
                cell.textLabel?.text = "Home Address"
                break;
            case .Phone:
                cell.textLabel?.text = "Phone"
                break;
            default:
                break;
            }
        }
        return cell
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        var currentUser = PFUser.currentUser()
        if let row = PTVCRows(rawValue: textField.tag) {
            switch (row) {
            case .Name:
                currentUser["name"] = textField.text
                break;
            case .College:
                currentUser["college"] = textField.text
                break;
            case .HomeAddress:
                currentUser["address"] = textField.text
                break;
            case .Phone:
                currentUser["phone"] = textField.text
                break;
            default:
                break;
            }
        }
        currentUser.saveEventually(nil)
    }
    
}
