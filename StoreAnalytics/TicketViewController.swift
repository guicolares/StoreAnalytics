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
    var queueFound:PFObject!
    var admin: Int! 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      //  let teste: (AnyObject) = (self.queueFound["lastRecordCalled"]!)
  
 //       self.tickeatCurrent.text = "\(teste)"
        
        getCurrent()
        println(self.queueFound)
        
        
        if(self.admin == 1) {
            self.ticketCountText.text = "Ultima ficha"
            self.nextButton.hidden = false
            self.nextButton.layer.cornerRadius = self.nextButton.frame.size.width / 2;
            self.nextButton.clipsToBounds = true;
        }
        
        else{
            self.ticketNumber.text = "\(ticketNumberReceived)"
        }
    }

    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func callNext(sender: UIButton) {
        
        //ticketcurrent + 1
        //atualiza queue
        
        
        var query = PFQuery(className:"queue")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                
                println("Successfully retrieved \(objects!.count) queue.")
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        self.queueFound = object
                        
                        self.queueFound["lastRecordCalled"] = (self.queueFound["lastRecordCalled"] as! Int) + 1
                        let teste = (self.queueFound["lastRecordCalled"]!)
                        self.tickeatCurrent.text = "\(teste)"
                        self.queueFound.saveInBackgroundWithBlock(nil)
                        
                        
                    }
                }
            }

        /*
                        
        
        
        
        
        let nextRecordIdCall:Int = (self.queueFound["lastRecordCalled"] as! Int) + 1
        //get record
        var record = PFQuery(className: "record")
        record.whereKey("recordId", equalTo: nextRecordIdCall)
        //get by date to ?
        var records = record.findObjects()
        if records?.count > 0 {
            self.lastRecord = records?.first as! PFObject
            //@todo send push here

            //update queue
            self.queueFound["lastRecordCalled"] = nextRecordIdCall
            self.queueFound.saveInBackgroundWithBlock(nil)
            //            self.lblRecordCall.text = "Senha: \(nextRecordIdCall)"
        }else{
            //send message this record is the last
        }
        */
        }
    }
    
    
    func getCurrent(){
        var query = PFQuery(className:"queue")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                
              //  println("Successfully retrieved \(objects!.count) queue.")
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        self.queueFound = object
                      //  println(self.queueFound)
                    }
                }
            }
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
    }}