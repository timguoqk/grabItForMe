//
//  DetailTableViewController.swift
//  GrabItForMe
//
//  Created by He Jiang on 4/4/15.
//  Copyright (c) 2015 ZJG. All rights reserved.
//

import Foundation

import UIKit

class DetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    enum PTVCRows: Int {
        case Name = 0, College, HomeAddress, Phone, Distance, Rating, Reviewer, count
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
        var label = UITextField()
        label.delegate = self
        label.tag = indexPath.row
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
            case .Distance:
                cell.textLabel?.text = "Distance"
                break;
            case .Rating:
                cell.textLabel?.text = "Rating"
                break;
            case .Reviewer:
                cell.textLabel?.text = "Reviewer"
            default:
                break;
            }
        }
        return cell
    }
    
    func userValue(label: UILabel) {
        var currentUser = PFUser.currentUser()
        if let row = PTVCRows(rawValue: label.tag) {
            switch (row) {
            case .Name:
                currentUser["name"] = label.text
                break;
            case .College:
                currentUser["college"] = label.text
                break;
            case .HomeAddress:
                currentUser["address"] = label.text
                break;
            case .Phone:
                currentUser["phone"] = label.text
                break;
            case .Distance:
                currentUser["distance"] = label.text
                break;
            case .Rating:
                currentUser["rating"] = label.text
                break;
            case .Reviewer:
                currentUser["reviewer"] = label.text
            default:
                break;
            }
        }
        currentUser.saveEventually(nil)
    }
    
}
