//
//  SettingsController.swift
//  sBot
//
//  Created by Andrew Solesa on 2017-05-10.
//  Copyright © 2017 KSG. All rights reserved.
//

import UIKit

class SettingsController: UIViewController
{
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var telephoneField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var expMonthField: UITextField!
    @IBOutlet weak var expYearField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var itemNameField: UITextField!
    @IBOutlet weak var itemSizeField: UITextField!
    @IBOutlet weak var itemColorField: UITextField!
    
    var settingsDictionary = [String:String]() 
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: UIButton)
    {
        SharingManager.sharedInstance.name = self.nameField.text!
        SharingManager.sharedInstance.email = self.emailField.text!
        SharingManager.sharedInstance.telephone = self.telephoneField.text!
        SharingManager.sharedInstance.address = self.addressField.text!
        SharingManager.sharedInstance.city = self.cityField.text!
        SharingManager.sharedInstance.state = self.stateField.text!
        SharingManager.sharedInstance.zip = self.zipField.text!
        SharingManager.sharedInstance.number = self.numberField.text!
        SharingManager.sharedInstance.expMonth = self.expMonthField.text!
        SharingManager.sharedInstance.expYear = self.expYearField.text!
        SharingManager.sharedInstance.cvv = self.cvvField.text!
        SharingManager.sharedInstance.itemName = self.itemNameField.text!
        SharingManager.sharedInstance.itemSize = self.itemSizeField.text!
        SharingManager.sharedInstance.itemColor = self.itemColorField.text!
        
        self.dismiss(animated: true, completion: nil)
    }
}
