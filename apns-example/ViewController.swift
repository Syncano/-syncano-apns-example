//
//  ViewController.swift
//  apns-example
//
//  Created by Jakub Machoń on 18.04.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

import UIKit
import syncano_ios

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelsContainer: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    private static let showNotificationsSegueName = "showNotifications"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        hideLoader()
    }
    
    override func viewDidAppear(animated: Bool) {
        if(SCUser.currentUser() != nil) {
            self.performSegueWithIdentifier(ViewController.showNotificationsSegueName, sender: self)
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showLoader() {
        activityIndicator.hidden = false
        labelsContainer.hidden = true
    }
    
    func hideLoader() {
        activityIndicator.hidden = true
        labelsContainer.hidden = false
    }
    
    func showError(error: NSError) {
        print(error.description)
        let alert = UIAlertController(title: "Alert", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        SCUser.currentUser().logout()
    }
    
    @IBAction func loginClicked(sender: UIButton) {
        showLoader()
        showLoader()
        SCUser.loginWithUsername(username.text, password: username.text) { [weak self] (error) in
            guard (error == nil) else {
                self?.showError(error)
                self?.hideLoader()
                return
            }
            self?.performSegueWithIdentifier(ViewController.showNotificationsSegueName, sender: self)
        }
    }
    
    @IBAction func registerClicked(sender: UIButton) {
        showLoader()
        SCUser.registerWithUsername(username.text, password: username.text) { [weak self] (error) in
            guard (error == nil) else {
                self?.showError(error)
                self?.hideLoader()
                return
            }
            self?.performSegueWithIdentifier(ViewController.showNotificationsSegueName, sender: self)
        }
    }
}

