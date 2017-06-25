//
//  EventInfoDetailViewController.swift
//  PhunwareAssignment
//
//  Created by Ashish Mishra on 6/24/17.
//  Copyright © 2017 Ashish Mishra. All rights reserved.
//

import UIKit

class EventInfoDetailViewController: UIViewController {
    
    @IBOutlet var detailImageView : UIImageView!
    @IBOutlet var timestampLabel : UILabel!
    @IBOutlet var titleLabel : UILabel!
    @IBOutlet var describtionLabel : UITextView!

    var eventInfo : EventInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.bookmarks, target: self, action: #selector(EventInfoDetailViewController.share))
        
        self.detailImageView.image = self.eventInfo?.bgImage
        self.timestampLabel.text = self.eventInfo?.eventDate
        self.titleLabel.text = self.eventInfo?.title
        self.describtionLabel.text = self.eventInfo?.eventDescription

    }
    
    func share(sender : UIBarButtonItem) {
        self.displayShareSheet(shareContent: (self.eventInfo?.eventDescription)!, sender: sender)
    }
    
    func displayShareSheet(shareContent:String, sender : UIBarButtonItem) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            activityViewController.modalPresentationStyle = .popover
            
            let popover: UIPopoverPresentationController = activityViewController.popoverPresentationController!
            popover.barButtonItem = sender
            present(activityViewController, animated: true, completion: {})

            
        }else {
            present(activityViewController, animated: true, completion: {})

        }
    }
}
