//
//  EventInfoCollectionViewCell.swift
//  PhunwareAssignment
//
//  Created by Ashish Mishra on 6/23/17.
//  Copyright © 2017 Ashish Mishra. All rights reserved.
//

import UIKit

class EventInfoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var timingLabel : UILabel!
    @IBOutlet var eventNameLabel : UILabel!
    @IBOutlet var placeLabel : UILabel!
    @IBOutlet var eventDescriptionLabel : UILabel!
    @IBOutlet var bgImageView : UIImageView!
    
    override func prepareForReuse() {
        self.bgImageView.image = nil
    }
}
