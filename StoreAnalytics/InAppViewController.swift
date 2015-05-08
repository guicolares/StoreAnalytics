//
//  InAppViewController.swift
//  StoreAnalytics
//
//  Created by Matheus Frozzi Alberton on 08/05/15.
//  Copyright (c) 2015 Guilherme Leite Colares. All rights reserved.
//

import UIKit
import StoreKit

class InAppViewController: UIViewController, SKProductsRequestDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//
//        let productsRequest = SKProductsRequest(productIdentifiers: [""])
//        productsRequest.delegate = self;
//        productsRequest.start();
        
        var productID:NSSet = NSSet(object: "com.bepid.StoreAnalytics.RemoveAds");
        var productsRequest:SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>);
        productsRequest.delegate = self;
        productsRequest.start();
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println(response.products.count) // [SKProduct]
        
        if (SKPaymentQueue.canMakePayments()) {
//            let product = response.products[0] as! SKProduct
//            var payment = SKPayment(product: product)
//            SKPaymentQueue.defaultQueue().addPayment(payment);
            println("allowed")
        } else {
            println("Not allowed to buy")
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