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
//"A3D35CE7-048E-4749-A9EB-5D651191666B  2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6 "
let identifier = "beacon.identifier"

class SearchViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var ticketButton: UIButton!
    var beaconsFound: [CLBeacon] = [CLBeacon]()
    let locationManager = CLLocationManager()
    var beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
    
    var inQueue:PFObject!
    var queueFound:PFObject!
    
    var lastRecord:PFObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.findBeacon("A3D35CE7-048E-4749-A9EB-5D651191666B") // todo just for test
        
        ticketButton.layer.cornerRadius = ticketButton.frame.size.width / 2;
        ticketButton.clipsToBounds = true;
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
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedAlways {
            locationManager.startMonitoringForRegion(beaconRegion)
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
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        if (beacons.count > 0) {
            //beaconsFound = beacons as! [CLBeacon]
            self.findBeacon((beacons as! [CLBeacon]).first!.proximityUUID.description)
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
                if let queuesAux = queues as? [PFObject] {
                    self.queueFound = queuesAux[0]
                    //send notification
                }
            })
        }
    }
    
    @IBAction func clickCallAgain(sender: AnyObject) {
        //get self.lastRecord and send push
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
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
}