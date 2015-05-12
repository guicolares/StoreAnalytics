//
//  TicketViewController.swift
//  StoreAnalytics
//
//  Created by Matheus Frozzi Alberton on 11/05/15.
//  Copyright (c) 2015 Guilherme Leite Colares. All rights reserved.
//

import UIKit
import Parse

class TicketViewController: UIViewController {

    @IBOutlet weak var ticketCountText: UILabel!
    @IBOutlet weak var ticketNumber: UILabel!
    @IBOutlet weak var tickeatCurrent: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    var ticketNumberReceived : Int = 0
    var lastRecord:PFObject!
    var inQueue:PFObject!
    var admin: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        if(self.admin == 1) {
            self.ticketCountText.text = "Ultima ficha"
            self.nextButton.hidden = false
            self.nextButton.layer.cornerRadius = self.nextButton.frame.size.width / 2;
            self.nextButton.clipsToBounds = true;
            self.getLastTicketCreated()
            NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "getLastTicketCreated", userInfo: nil, repeats: true)
        }else{
            self.ticketNumber.text = "\(ticketNumberReceived)"
        }
        
        self.getCurrentTicket()
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "getCurrentTicket", userInfo: nil, repeats: true)
    }
    
    func getLastTicketCreated(){
        self.inQueue.fetchInBackground()
        self.ticketNumber.text = (self.inQueue["lastRecordCreated"] as! Int).description
    }
    
    func getCurrentTicket(){
        self.inQueue.fetchInBackground()
        self.tickeatCurrent.text = (self.inQueue["lastRecordCalled"] as! Int).description
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callNext(sender: UIButton) {
        var nextRecordCall:Int = (self.inQueue["lastRecordCalled"] as! Int) + 1
        
        var query = PFQuery(className:"record").whereKey("recordId", equalTo: nextRecordCall)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        self.lastRecord = object
                        
                        self.inQueue["lastRecordCalled"] = (self.inQueue["lastRecordCalled"] as! Int) + 1
                        self.inQueue.saveInBackgroundWithBlock(nil)
                        self.getCurrentTicket()
                        //send notification ??
                    }
                }
                println(objects)
            }
        }
    }
}