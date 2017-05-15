//
//  ViewController.swift
//  sBot
//
//  Created by Andrew Solesa on 2017-05-07.
//  Copyright © 2017 KSG. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate
{
    @IBOutlet weak var supremeContainerView: UIView!
    
    var supremeBrowser: WKWebView?
    
    var supremeBot: Supreme?
    
    var blockRedirection: Bool?
    
    @IBOutlet weak var reloadButton: UIButton!
    
    var botButtonFlag: Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        createSupremeBrowser()
        
        //Initialize once
        self.supremeBot = Supreme(withViewController: self)
    }

    func createSupremeBrowser()
    {
        supremeBrowser = WKWebView()
        supremeContainerView.addSubview(supremeBrowser!)
        
        supremeBrowser!.allowsBackForwardNavigationGestures = true
        supremeBrowser!.navigationDelegate = self
        
        let frame = CGRect(x: 0, y: 0, width: supremeContainerView.bounds.width, height: supremeContainerView.bounds.height)
        supremeBrowser!.frame = frame
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        loadSupremeWebsite(link: 0)
    }
    
    func loadSupremeWebsite(link: Int)
    {
        var url: URL?
        
        switch link
        {
            case 0:
                url = URL(string: "http://www.supremenewyork.com/mobile/")!
                break
            
            default:
                break
        }

        let request = URLRequest(url: url!)
        self.supremeBrowser!.load(request)
        
        self.blockRedirection = true
        
    }
    
    func loadSettingsData()
    {
        self.supremeBot!.supremeInformation.name = SharingManager.sharedInstance.name
        self.supremeBot!.supremeInformation.email = SharingManager.sharedInstance.email
        self.supremeBot!.supremeInformation.telephone = SharingManager.sharedInstance.telephone
        self.supremeBot!.supremeInformation.address = SharingManager.sharedInstance.address
        self.supremeBot!.supremeInformation.city = SharingManager.sharedInstance.city
        self.supremeBot!.supremeInformation.state = SharingManager.sharedInstance.state
        self.supremeBot!.supremeInformation.zip = SharingManager.sharedInstance.zip
        
        self.supremeBot!.supremeInformation.number = SharingManager.sharedInstance.number
        self.supremeBot!.supremeInformation.expMonth = SharingManager.sharedInstance.expMonth
        self.supremeBot!.supremeInformation.expYear = SharingManager.sharedInstance.expYear
        self.supremeBot!.supremeInformation.cvv = SharingManager.sharedInstance.cvv
        
        self.supremeBot!.supremeWishListItem.name = SharingManager.sharedInstance.itemName
        self.supremeBot!.supremeWishListItem.color = SharingManager.sharedInstance.itemColor
        self.supremeBot!.supremeWishListItem.size = SharingManager.sharedInstance.itemSize
    }
    
    func loadSupremeCategory(category: Int)
    {
        var url: URL?
        
        switch category
        {
            case 0:
                url = URL(string: "http://www.supremenewyork.com/mobile/?c=1#categories/new")!
                break
            
            default:
                break
        }
        
        let request = URLRequest(url: url!)
        self.supremeBrowser!.load(request)
        
        self.blockRedirection = false
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("Began navigating to url \(String(describing: webView.url))")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("Finished navigating to url \(String(describing: webView.url))")
        
        if (!self.blockRedirection!)
        {
            switch self.supremeBot!.supremeBot!.stepFunction
            {
                case 0:
                    self.supremeBot!.supremeBot!.generateList()
                    break
                
                default:
                    break
            }
        }
        
        self.blockRedirection = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reloadButtonPressed(_ sender: UIButton)
    {
        if (!self.botButtonFlag)
        {
            loadSupremeWebsite(link: 0)
        }
    }
    
    @IBAction func botButtonPressed(_ sender: UIButton)
    {
        loadSettingsData()
        
        if (!self.supremeBot!.supremeInformation.name!.isEmpty || !self.supremeBot!.supremeWishListItem.name!.isEmpty)
        {
            if (!self.botButtonFlag)
            {
                print("Turned on")
                self.supremeBot!.start()
                self.botButtonFlag = true
            }
            else
            {
                print("Turned off")
                self.supremeBot!.stop()
                self.botButtonFlag = false
            }
        }
        else
        {
            let alert = UIAlertController(title: "Error", message: "Please make sure you filled out the settings form!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

