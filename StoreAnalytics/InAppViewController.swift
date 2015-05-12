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
    var prod = SKProduct()
    @IBOutlet weak var removeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeButton.enabled = false
        
        if(SKPaymentQueue.canMakePayments()) {
            var productID:NSSet = NSSet(object: "com.bepid.StoreAnalytics.RemoveAds")
            var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            println("IAP not enable")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func removeAds(sender: AnyObject) {
        UserDefaultsManager.removeAdwords = 1

        for product in list {
            var prodID = product.productIdentifier
            if(prodID == "com.bepid.StoreAnalytics.RemoveAds") {
                prod = product
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
        println("buy " + prod.productIdentifier)
        var pay = SKPayment(product: prod)
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
        var purchasedItemIDS = []
        for transaction in queue.transactions {
            var t: SKPaymentTransaction = transaction as! SKPaymentTransaction
            
            let prodID = t.payment.productIdentifier as String
            
            switch prodID {
            case "com.bepid.StoreAnalytics.RemoveAds":
                println("remove ads")
                UserDefaultsManager.removeAdwords = 1
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
                    let prodID = prod.productIdentifier as String

                switch prodID {
                    case "com.bepid.StoreAnalytics.RemoveAds":
                        UserDefaultsManager.removeAdwords = 1
                    default:
                        println("IAP not setup")
                }
                    queue.finishTransaction(trans)
                    break;
                case .Failed:
                    println("error")
                    queue.finishTransaction(trans)
                    break;
                default:
                    println("default")
                    break;
                    
                }
        }
    }
    
    func finishTransaction(trans:SKPaymentTransaction) {
        println("finish")
    }
    func paymentQueue(queue: SKPaymentQueue!, removedTransactions transactions: [AnyObject]!) {
        println("remove trans");
    }

}