//
//  Supreme.swift
//  sBot
//
//  Created by Andrew Solesa on 2017-05-08.
//  Copyright © 2017 KSG. All rights reserved.
//

import Foundation
import Alamofire
import Kanna

// SOURCE BY: ANDREW JUSTIN SOLESA

class Supreme
{
    var viewController: ViewController?
    
    var supremeBot: SupremeBot?
    var supremeInformation = SupremeInformation()
    var supremeWishListItem = SupremeItem()
    
    init(withViewController viewController: ViewController)
    {
        self.viewController = viewController
        
        self.supremeBot = SupremeBot(withSupremeInstance: self)
    }
    
    func start()
    {
        self.supremeBot!.startArtificalIntelligence()
    }
    
    func stop()
    {
        self.viewController!.botButtonFlag = false
        
        self.viewController!.reloadButton.sendActions(for: .touchUpInside)
        
        self.supremeBot!.stopArtificalIntelligence()
    }
    
    class SupremeBot
    {
        weak var supremeInstance: Supreme?
        
        var supremeList: [SupremeItem] = []
        
        var stepFunction: Int = 0
        
        var doOnce: Bool?
        
        var timer: DispatchSourceTimer?
        var timerItemStyle: DispatchSourceTimer?
        
        var countColor = 0
        var countTotalSize = 0
        
        init(withSupremeInstance supremeInstance: Supreme)
        {
            self.supremeInstance = supremeInstance
            
            self.doOnce = false
        }
        
        func generateListPage()
        {
            self.stepFunction = 0
            
            self.supremeInstance!.viewController!.loadSupremeCategory(category: 0)
            
            self.doOnce = true
        }
        
        func generateList()
        {
            var count = 0
            
            var foundItem = false
            
            let browserDelayQ = DispatchQueue(label: "browswerBackgroundQ1", qos: .userInitiated)
            
            browserDelayQ.asyncAfter(deadline: .now() + 1)
            {
                self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                                                                         completionHandler:
                    { (html: Any?, error: Error?) in
                        
                        let htmlText = html as! String
                        
                        if let doc = Kanna.HTML(html: htmlText, encoding: String.Encoding.utf8)
                        {
                            for item in doc.css("div[class^='clearfix']")
                            {
                                let itemText = item.text!
                                
                                let formattedItemText = itemText.replacingOccurrences(of: "new", with: "", options: NSString.CompareOptions.literal, range:nil).lowercased()
                                
                                let wishListItem = self.supremeInstance!.supremeWishListItem.name!.lowercased()
                                
                                if formattedItemText.range(of:wishListItem) != nil
                                {
                                    print("Found item: \(formattedItemText)")
                                    
                                    foundItem = true
                                    
                                    break
                                }
                                
                                count += 1
                            }
                        }
                        
                        if (foundItem)
                        {
                            print("Clicking item")
                            
                            self.clickItem(withItemIndex: count)
                        }
                        else
                        {
                            self.doOnce = false
                        }
                })

            }
        }
        
        func clickItem(withItemIndex itemIndex: Int)
        {
            var countColorTotal = 0
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementsByClassName(\"clearfix\")[\(itemIndex)].click()", completionHandler: nil)
            
            let wishListColor = self.supremeInstance!.supremeWishListItem.color!
            
            if (!wishListColor.isEmpty)
            {
                let browserDelayQ = DispatchQueue(label: "browswerBackgroundQ2", qos: .userInitiated)
                
                browserDelayQ.asyncAfter(deadline: .now() + 1)
                {
                    self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                                                                             completionHandler:
                        { (html: Any?, error: Error?) in
                            
                            let htmlText = html as! String
                            
                            if let doc = Kanna.HTML(html: htmlText, encoding: String.Encoding.utf8)
                            {
                                for _ in doc.css("div[class^='style-images']")
                                {
                                    countColorTotal += 1
                                }
                                
                                let queue = DispatchQueue(label: "com.domain.app.timer2")
                                self.timerItemStyle = DispatchSource.makeTimerSource(queue: queue)
                                self.timerItemStyle!.scheduleRepeating(deadline: .now(), interval: .seconds(2))
                                self.timerItemStyle!.setEventHandler
                                    { [weak self] in
                                        
                                        if (self!.countColor + 1 > countColorTotal)
                                        {
                                            self!.supremeInstance!.stop()
                                        }
                                        else
                                        {
                                            self!.generateStyle()
                                        }
                                }
                                self.timerItemStyle!.resume()
                            }
                    })
                    
                }
            }
            else
            {
                print("Item Color was empty")
                
                let wishListSize = self.supremeInstance!.supremeWishListItem.size!
                
                if (wishListSize.isEmpty)
                {
                    self.addItemToCartCheckOut()
                }
                else
                {
                    self.setItemSize()
                }
            }
        }
        
        func generateStyle()
        {
            var foundItemColor = false
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementsByClassName(\"style-images\")[\(countColor)].firstElementChild.click()", completionHandler: nil)
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                                                                     completionHandler:
                { (html: Any?, error: Error?) in
                    
                    let htmlText = html as! String
                    
                    if let doc = Kanna.HTML(html: htmlText, encoding: String.Encoding.utf8)
                    {
                        for itemColor in doc.css("p[id^='style-name']")
                        {
                            let itemColor = itemColor.text!
                            
                            let formattedItemColor = itemColor.lowercased()
                            
                            let wishListItemColor = self.supremeInstance!.supremeWishListItem.color!.lowercased()
                            
                            if formattedItemColor.range(of: wishListItemColor) != nil
                            {
                                print("Found color: \(formattedItemColor)")
                                
                                self.stopItemStyle()
                                
                                foundItemColor = true
                                
                                break
                            }
                            
                            self.countColor += 1
                        }
                    }
                    
                     if (foundItemColor)
                     {
                        let browserDelayQ = DispatchQueue(label: "browswerBackgroundQ3", qos: .userInitiated)
                        
                        browserDelayQ.asyncAfter(deadline: .now() + 2)
                        {
                            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                                                                                     completionHandler:
                                { (html: Any?, error: Error?) in
                                    
                                    let htmlText = html as! String
                                    
                                    if let doc = Kanna.HTML(html: htmlText, encoding: String.Encoding.utf8)
                                    {
                                        for _ in doc.css("option[value^='']")
                                        {
                                            self.countTotalSize += 1
                                        }
                                    }
                                    
                                    self.setItemSize()
                            })
                        }
                     }
            })
        }
        
        func setItemSize()
        {
            var countSize = 0
            var foundItemSize = false
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.documentElement.outerHTML.toString()",
                                                                                     completionHandler:
                { (html: Any?, error: Error?) in
                    
                    let htmlText = html as! String
                    
                    if let doc = Kanna.HTML(html: htmlText, encoding: String.Encoding.utf8)
                    {
                        for itemSize in doc.css("option[value^='']")
                        {
                            let itemSizeText = itemSize.text!.lowercased()
                            
                            let wishListItemSize = self.supremeInstance!.supremeWishListItem.size!.lowercased()
                            
                            if itemSizeText.range(of: wishListItemSize) != nil
                            {
                                print("Found size")
                                
                                foundItemSize = true
                                
                                let itemSizeValue = itemSize["value"]
                                
                                self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"size-options\").value = \(itemSizeValue!)", completionHandler: nil)
                                
                                break
                            }
                            
                            countSize += 1
                        }
                    }
                    
                    if (countSize + 1 > self.countTotalSize)
                    {
                        print("STOPPING CAUSE NO SIZE AVAILABLE")
                        self.supremeInstance!.stop()
                    }
                    
                    if (foundItemSize)
                    {
                        let browserDelayQ = DispatchQueue(label: "browswerBackgroundQ4", qos: .userInitiated)
                        
                        browserDelayQ.asyncAfter(deadline: .now() + 2)
                        {
                            self.addItemToCartCheckOut()
                        }
                    }
            })
        }
        
        func addItemToCartCheckOut()
        {
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementsByClassName(\"cart-button\")[0].click()", completionHandler: nil)
            
            let browserDelayQ = DispatchQueue(label: "browswerBackgroundQ5", qos: .userInitiated)
            
            browserDelayQ.asyncAfter(deadline: .now() + 1)
            {
                self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"checkout-now\").click()", completionHandler: nil)
                
                let browserDelayQ = DispatchQueue(label: "browswerBackgroundQ6", qos: .userInitiated)
                
                browserDelayQ.asyncAfter(deadline: .now() + 1)
                {
                    self.pasteInformationCheckOut()
                }
            }
        }
        
        func pasteInformationCheckOut()
        {
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"order_billing_name\").value = \"\(self.supremeInstance!.supremeInformation.name!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"order_email\").value = \"\(self.supremeInstance!.supremeInformation.email!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"order_tel\").value = \"\(self.supremeInstance!.supremeInformation.telephone!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"order_billing_address\").value = \"\(self.supremeInstance!.supremeInformation.address!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"order_billing_zip\").value = \"\(self.supremeInstance!.supremeInformation.zip!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"order_billing_city\").value = \"\(self.supremeInstance!.supremeInformation.city!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"order_billing_state\").value = \"\(self.supremeInstance!.supremeInformation.state!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"credit_card_n\").value = \"\(self.supremeInstance!.supremeInformation.number!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"credit_card_month\").value = \"\(self.supremeInstance!.supremeInformation.expMonth!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"credit_card_year\").value = \"\(self.supremeInstance!.supremeInformation.expYear!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"credit_card_cvv\").value = \"\(self.supremeInstance!.supremeInformation.cvv!)\"", completionHandler: nil)
            
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"order_terms\").click()", completionHandler: nil)
            self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.getElementById(\"submit_button\").click()", completionHandler: nil)
            
                self.supremeInstance!.viewController!.supremeBrowser!.evaluateJavaScript("document.querySelector('.g-recaptcha').remove()", completionHandler: nil)
            
            let browserDelayQ = DispatchQueue(label: "browswerBackgroundQ7", qos: .userInitiated)
            
            browserDelayQ.asyncAfter(deadline: .now() + 2)
            {
                self.stopArtificalIntelligence()
            }
        }
        
        func startArtificalIntelligence()
        {
            let queue = DispatchQueue(label: "com.domain.app.timer")
            self.timer = DispatchSource.makeTimerSource(queue: queue)
            self.timer!.scheduleRepeating(deadline: .now(), interval: .seconds(10))
            self.timer!.setEventHandler
                { [weak self] in
                    if (!self!.doOnce!)
                    {
                        print("Called me")
                        self!.supremeInstance?.viewController!.supremeBrowser!.load(URLRequest(url: URL(string:"about:blank")!))
                        self!.generateListPage()
                    }
                }
            self.timer!.resume()
        }
        
        func stopArtificalIntelligence()
        {
            print("Shutting off")
            
            self.timer?.cancel()
            self.timer = nil
            
            self.timerItemStyle?.cancel()
            self.timerItemStyle = nil
            
            self.supremeInstance!.viewController!.botButtonFlag = false
            self.doOnce = false
            self.countColor = 0
        }
        
        func stopItemStyle()
        {
            self.timerItemStyle!.cancel()
            self.timerItemStyle = nil
            
            self.countColor = 0
        }
        
        deinit
        {
            self.stopArtificalIntelligence()
        }
    }
    
    class SupremeInformation
    {
        var name: String?
        var email: String?
        var telephone: String?
        var address: String?
        var city: String?
        var state: String?
        var zip: String?
        
        var number: String?
        var expMonth: String?
        var expYear: String?
        var cvv: String?
    }
    
    class SupremeItem
    {
        var link: String?
        var name: String?
        var color: String?
        var size: String?
        var sizeList = [String: Int]()
        var sold: Bool?
    }
}
