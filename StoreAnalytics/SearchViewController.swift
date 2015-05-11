//
//  SearchViewController.swift
//  StoreAnalytics
//
//  Created by Matheus Frozzi Alberton on 11/05/15.
//  Copyright (c) 2015 Guilherme Leite Colares. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var ticketButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        ticketButton.layer.cornerRadius = ticketButton.frame.size.width / 2;
        ticketButton.clipsToBounds = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func newTicket(sender: AnyObject) {
        self.performSegueWithIdentifier("newTicket", sender: sender)
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
