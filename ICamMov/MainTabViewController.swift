//
//  MainTabViewController.swift
//  TryDemo
//
//  Created by Alex Chan on 14/12/2.
//  Copyright (c) 2014年 sunset. All rights reserved.
//
import UIKit
import Foundation

class MainTabViewController: UITabBarController{
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.addCenterButton();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
////        presentViewController(<#viewControllerToPresent: UIViewController#>, animated: <#Bool#>, completion: <#(() -> Void)?##() -> Void#>)
////        self.performSegueWithIdentifier("takeMovieSegue", sender: self)
//        super.tabBar(tabBar, didSelectItem: item)
//
//    }
    

    
    
    // MARK: Custom functions
    
    @IBAction func unwindToMainTab(segue: UIStoryboardSegue) {
        
    }
    
    func addCenterButton(){
//        var button: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        var button : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRect(x: 0, y: 0, width: self.tabBar.frame.size.height, height: self.tabBar.frame.size.width)
        button.setTitle("SB", forState: UIControlState.Normal)
        button.setImage(UIImage(named: "first"), forState: UIControlState.Normal)
//        button.setBackgroundImage(UIImage(named: "second"), forState: UIControlState.Normal)
        
        button.addTarget(self, action: "prepareTakeMovie:", forControlEvents: UIControlEvents.TouchUpInside)

        button.center = self.tabBar.center
        


        self.view.addSubview(button)
//        self.tabBar.addSubview(button)
//        self.tabBar.items?.append( button )
        
    }
    
    func prepareTakeMovie(sender: AnyObject){
        
        self.performSegueWithIdentifier("takeMovieSegue", sender: self)
        
    }
}