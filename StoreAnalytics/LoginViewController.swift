//
//  LoginViewController.swift
//  StoreAnalytics
//
//  Created by Matheus Frozzi Alberton on 11/05/15.
//  Copyright (c) 2015 Guilherme Leite Colares. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func loginAction(sender: AnyObject) {
        var query = PFQuery(className: "queue")
        query.whereKey("UUID", equalTo: "A3D35CE7-048E-4749-A9EB-5D651191666B")
        query.findObjectsInBackgroundWithBlock({(queues , error)  in
            //get only one beacon found ?
            if let queuesAux = queues as? [PFObject] {
                self.performSegueWithIdentifier("loginAdmin", sender: queuesAux[0])
            }
        })
        
        
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "loginAdmin") {
            var ticketControl = segue.destinationViewController as! TicketViewController
            ticketControl.admin = 1
            ticketControl.inQueue = sender as! PFObject
            
            
           
        }
    }
}
