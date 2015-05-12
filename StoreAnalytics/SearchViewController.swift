//
//  SearchViewController.swift
//  StoreAnalytics
//
//  Created by Matheus Frozzi Alberton on 11/05/15.
//  Copyright (c) 2015 Guilherme Leite Colares. All rights reserved.
//

import UIKit
import CoreLocation
import Parse

let uuid = NSUUID(UUIDString: "A3D35CE7-048E-4749-A9EB-5D651191666B")
//"A3D35CE7-048E-4749-A9EB-5D651191666B   18CF87B8-7C9A-4CA9-8CDF-E9D4DA40868E 52414449-5553-4E45-5457-4F524B53434F   4E1E49E6-B573-4996-BE32-91AAEA0084A6"
let identifier = "Radius"

class SearchViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var ticketButton: UIButton!
    @IBOutlet var constY: NSLayoutConstraint!
    
    @IBOutlet var lblSearching: UILabel!
    @IBOutlet var lblDescriptionPlace: UILabel!
    var beaconsFound: [CLBeacon] = [CLBeacon]()
    let locationManager = CLLocationManager()
    var beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
    
    var inQueue:PFObject!
    var queueFound:PFObject!
    var lastRecord:PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        ticketButton.layer.cornerRadius = ticketButton.frame.size.width / 2;
        ticketButton.clipsToBounds = true;
        self.ticketButton.layer.opacity = 0
        self.lblDescriptionPlace.layer.opacity = 0
    }
    
    @IBAction func newTicket(sender: AnyObject) {

        var installation: AnyObject = PFInstallation.currentInstallation()["installationId"]!
        self.inQueue = self.queueFound
        var nextRecordId:Int = self.queueFound["lastRecordCreated"] as! Int + 1
        
        //save record with token
        var record = PFObject(className: "record")
        record["userTokenTemp"] = installation
        record["recordId"] = nextRecordId //pega o prox numero da fila
        record["queue"] = self.queueFound
        record.saveInBackgroundWithBlock{ (success:Bool, error:NSError?) -> Void in
            if success {
                self.queueFound["lastRecordCreated"] = (self.queueFound["lastRecordCreated"] as! Int) + 1
                self.queueFound.saveInBackgroundWithBlock(nil)
                self.performSegueWithIdentifier("newTicket", sender: nextRecordId)
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.beaconRegion.notifyOnEntry = true
        self.beaconRegion.notifyOnExit = true
        self.beaconRegion.notifyEntryStateOnDisplay = true
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
       
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startMonitoringForRegion(beaconRegion)
            locationManager.startRangingBeaconsInRegion(self.beaconRegion) //force ranging to test at BEPID
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        locationManager.stopMonitoringForRegion(beaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if state == CLRegionState.Inside {
            self.locationManager.startRangingBeaconsInRegion(self.beaconRegion)
        }else{
            println("out region")
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        if (beacons.count > 0) {
            self.findBeacon((beacons as! [CLBeacon]).first!.proximityUUID.UUIDString)
        }
    }
    
    func findBeacon(UUID:String ){
        if self.inQueue == nil || self.inQueue["UUID"] as! String != UUID {
            //check if exists
           var query = PFQuery(className: "queue")
            query.whereKey("UUID", equalTo: UUID)
            query.limit = 1
            query.findObjectsInBackgroundWithBlock({(queues , error)  in
                //get only one beacon found ?
                var queuesAux:NSArray? = queues as? [PFObject]
                
                if queuesAux!.count > 0 {
                    
                    
                    var localNotification:UILocalNotification = UILocalNotification()
                    localNotification.alertAction = "Testing notifications on iOS8"
                    localNotification.alertBody = "Entre na fila!"
                    //localNotification.fireDate = NSDate(timeIntervalSinceNow: 30)
                    localNotification.soundName = UILocalNotificationDefaultSoundName
                    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                    
                    
                    
                    self.queueFound = queuesAux?.firstObject as? PFObject
                    
                    UIView.animateWithDuration(0.8,
                        delay: 0.0,
                        options: UIViewAnimationOptions.AllowUserInteraction,
                        animations: {
                            self.constY.constant = 100
                            self.ticketButton.layer.opacity = 1
                            self.lblDescriptionPlace.layer.opacity = 1
                            self.lblSearching.hidden = true
                            
                            self.view.layoutIfNeeded()
                        }, completion: { (finished: Bool) in
                            
                    })
                    self.locationManager.stopRangingBeaconsInRegion(self.beaconRegion)
                }
            })
        }
    }
    
    func getRecordsPending() -> Int{
        return (self.queueFound["lastRecordCreated"] as! Int) - (self.queueFound["lastRecordCalled"] as! Int)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "newTicket"){
            let ticketView: TicketViewController = segue.destinationViewController as! TicketViewController
            ticketView.ticketNumberReceived = sender! as! Int
            ticketView.inQueue = self.inQueue
            ticketView.admin = 0
            
        }
    }
}
