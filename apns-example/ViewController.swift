//
//  ViewController.swift
//  apns-example
//
//  Created by Jakub Machoń on 18.04.2016.
//  Copyright © 2016 Syncano. All rights reserved.
//

import UIKit
import syncano_ios

let syncanoErrorUserInfoKey = "com.Syncano.response.error"

class ViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var labelsContainer: UIView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    private static let showNotificationsSegueName = "showNotifications"
    
    //MARK: - View states
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
    
    //MARK: - Navigation
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        SCUser.currentUser().logout()
    }
    
    //MARK: - View operations
    func showLoader() {
        activityIndicator.hidden = false
        labelsContainer.hidden = true
    }
    
    func hideLoader() {
        activityIndicator.hidden = true
        labelsContainer.hidden = false
    }
    
    func showError(error: NSError) {
       showErrorString(error.userInfo[syncanoErrorUserInfoKey]?.description ?? error.description)
    }
    
    func showErrorString(string: String) {
        print(string)
        let alert = UIAlertController(title: "Alert", message: string, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - Touches
    @IBAction func loginClicked(sender: UIButton) {
        showLoader()
        login()
    }
    
    @IBAction func registerClicked(sender: UIButton) {
        showLoader()
        registerNewUser()
    }
    
    //MARK: - Syncano communication
    func isRegistrationErrorAlreadyExists(error: NSError) -> Bool {
        guard let errorDictionary = error.userInfo[syncanoErrorUserInfoKey] as? [String:AnyObject] else {
            return false
        }
        let errorMessages = errorDictionary["registration_id"] as? [String]
        if let message = errorMessages?.first
        where message == "APNSDevice with this registration id already exists." {
            return true
        }
        return false
    }
    
    
    func registerDevice() {
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        guard let token = delegate.deviceToken else {
            showErrorString("Cannot obtain device ID from Apple. Please check logs for further details.")
            return
        }
        
        //This adds device to Syncano
        let device = SCDevice(tokenFromData: token)
        device.label = deviceModel()
        device.saveWithCompletionBlock { [weak self] (error) in
            if error != nil && self?.isRegistrationErrorAlreadyExists(error) == false {
                self?.showError(error)
                self?.hideLoader()
                return
            }
            
            self?.performSegueWithIdentifier(ViewController.showNotificationsSegueName, sender: self)
        }
        
    }
    
    func checkAndAlertIfUsernameAndPasswordAreEmpty() -> Bool {
        if (username.text?.characters.count < 1
            || password.text?.characters.count < 1) {
            self.showErrorString("Please provide both username and password first")
            self.hideLoader()
            return true
        }
        return false
    }
    
    func login() {
        guard self.checkAndAlertIfUsernameAndPasswordAreEmpty() == false else {
            return
        }
        SCUser.loginWithUsername(username.text, password: password.text) { [weak self] (error) in
            self?.profileExistsWithError(error)
        }
    }
    
    func registerNewUser() {
        guard self.checkAndAlertIfUsernameAndPasswordAreEmpty() == false else {
            return
        }
        SCUser.registerWithUsername(username.text, password: password.text) { [weak self] (error) in
            self?.profileExistsWithError(error)
        }
    }
    
    func profileExistsWithError(error: NSError?) {
        guard (error == nil) else {
            self.showError(error!)
            self.hideLoader()
            return
        }
        self.registerDevice()
    }
    
    func deviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        
        return NSString(bytes: &systemInfo.machine, length: Int(_SYS_NAMELEN), encoding: NSASCIIStringEncoding)! as String
    }
}

