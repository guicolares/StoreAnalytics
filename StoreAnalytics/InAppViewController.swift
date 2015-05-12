//
//  InAppViewController.swift
//  StoreAnalytics
//
//  Created by Matheus Frozzi Alberton on 08/05/15.
//  Copyright (c) 2015 Guilherme Leite Colares. All rights reserved.
//

import UIKit
import StoreKit

class InAppViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {

    var list = [SKProduct]()
    var p = SKProduct()
    @IBOutlet weak var removeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeButton.enabled = false
//
//        let productsRequest = SKProductsRequest(productIdentifiers: [""])
//        productsRequest.delegate = self;
//        productsRequest.start();
        
        if(SKPaymentQueue.canMakePayments()) {
            println("IAP is enabled, loading")
            var productID:NSSet = NSSet(object: "com.bepid.StoreAnalytics.RemoveAds")
            var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            println("please enable IAPS")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func removeAds(sender: AnyObject) {
        println("button remove")
        for product in list {
            var prodID = product.productIdentifier
            if(prodID == "com.bepid.StoreAnalytics.RemoveAds") {
                p = product
                buyProduct()
                break;
            }
        }
    }

    @IBAction func restorePurchase(sender: AnyObject) {
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
    }
    
    func buyProduct() {
        println("buy " + p.productIdentifier)
        var pay = SKPayment(product: p)
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        SKPaymentQueue.defaultQueue().addPayment(pay as SKPayment)
    }
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println("product request")
        var myProduct = response.products
        
        for product in myProduct {
            println("product added")
            println(product.productIdentifier)
            println(product.localizedTitle)
            println(product.localizedDescription)
            println(product.price)
            
            list.append(product as! SKProduct)
        }
        
        removeButton.enabled = true
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(queue: SKPaymentQueue!) {
        println("transactions restored")
        
        var purchasedItemIDS = []
        for transaction in queue.transactions {
            var t: SKPaymentTransaction = transaction as! SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.bepid.StoreAnalytics.RemoveAds":
                println("remove ads")
//                self.performSegueWithIdentifier("teste", sender: nil)
            default:
                println("IAP not setup")
            }
        }
    }
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        println("add paymnet")
        
        for transaction:AnyObject in transactions {
            var trans = transaction as! SKPaymentTransaction
            println(trans.error)
            
            switch trans.transactionState {
                
            case .Purchased:
                println("buy, ok unlock iap here")
                println(p.productIdentifier)
                
                let prodID = p.productIdentifier as String
                switch prodID {
                case "com.bepid.StoreAnalytics.RemoveAds":
                    println("remove ads")
//                    self.performSegueWithIdentifier("teste", sender: nil)
                default:
                    println("IAP not setup")
                }
                
                queue.finishTransaction(trans)
                break;
            case .Failed:
                println("buy error")
                queue.finishTransaction(trans)
                break;
            default:
                println("default")
                break;
                
            }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction) {
        println("finish trans")
    }
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) {
        println("remove trans");
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