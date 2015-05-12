import UIKit
import CoreLocation
import Parse

//let uuid = NSUUID(UUIDString: "A3D35CE7-048E-4749-A9EB-5D651191666B")
////"A3D35CE7-048E-4749-A9EB-5D651191666B  2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6 "
//let identifier = "beacon.identifier"

class BeaconViewController: UIViewController, CLLocationManagerDelegate {
    
    var beaconsFound: [CLBeacon] = [CLBeacon]()
    let locationManager = CLLocationManager()
    var beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: identifier)
    
    @IBOutlet var lblMessage: UILabel!
    var inQueue:PFObject!
    var queueFound:PFObject!
    
    @IBOutlet var lblBeaconFound: UILabel!
    
    var lastRecord:PFObject!
    @IBOutlet var lblRecordCall: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.foundBeacon()
        // Do any additional setup after loading the view, typically from a nib.
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
        if self.inQueue != nil && self.inQueue["UUID"] as! String != UUID {
            self.lblBeaconFound.text = UUID
            
            //check if exists
            var query = PFQuery(className: "queue")
            query.whereKey("UUID", equalTo: UUID)
            query.limit = 1
            query.findObjectsInBackgroundWithBlock({(queues , error)  in
                //get only one beacon found ?
                if let queuesAux = queues as? [PFObject] {
                    self.queueFound = queuesAux[0]
                    //send notification
                    
                    var localNotification:UILocalNotification = UILocalNotification()
                    
                    localNotification.alertAction = "Testing notifications on iOS8"
                    
                    localNotification.alertBody = "Entre na fila!"
                    
                    localNotification.fireDate = NSDate(timeIntervalSinceNow: 30)
                    
                    localNotification.soundName = UILocalNotificationDefaultSoundName
                    
                    //   localNotification.applicationIconBadgeNumber =  localNotification.applicationIconBadgeNumber + 1
                    
                    UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                    
                    
                }
            })
        }
        
        
    }
    
    @IBAction func clickEnterQueue(sender: UIBarButtonItem) {
        self.inQueue = self.queueFound
        var queue:PFObject! = self.queueFound
        //generate code
        var nextRecordId:Int = queue["lastRecordCreated"] as! Int + 1
        
        //save record with token
        var record = PFObject(className: "record")
        record["userTokenTemp"] = "2321312321"
        record["recordId"] = nextRecordId
        record["queue"] = queue
        record.saveInBackgroundWithBlock { (success:Bool, error:NSError?) -> Void in
            if success {
                //update queue
                self.inQueue["lastRecordCreated"] = nextRecordId
                self.inQueue.saveInBackgroundWithBlock(nil)
                self.lblMessage.text = "Sua senha: \(nextRecordId)"
            }
        }
    }
    
    
    @IBAction func callNext(sender: UIButton) {
        let nextRecordIdCall:Int = self.queueFound["lastRecordCalled"] as! Int + 1
        //get record
        var record = PFQuery(className: "record")
        record.whereKey("recordId", equalTo: nextRecordIdCall)
        //get by date to ?
        
        
        var records = record.findObjects()
        if records?.count > 0 {
            self.lastRecord = records?.first as! PFObject
            
            
            
            //@todo send push here
            
            //se for o prox manda o push
            
            
            
            //update queue
            self.queueFound["lastRecordCalled"] = nextRecordIdCall
            self.queueFound.saveInBackgroundWithBlock(nil)
            self.lblRecordCall.text = "Senha: \(nextRecordIdCall)"
        }else{
            
            //
            
            
            //send message this record is the last
        }
    }
    
    @IBAction func clickCallAgain(sender: AnyObject) {
        //get self.lastRecord and send push
    }
    
    
    func getRecordsPending() -> Int{
        return (self.queueFound["lastRecordCreated"] as! Int) - (self.queueFound["lastRecordCalled"] as! Int)
    }
    
}

