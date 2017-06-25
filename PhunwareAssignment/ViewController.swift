//
//  ViewController.swift
//  PhunwareAssignment
//
//  Created by Ashish Mishra on 6/22/17.
//  Copyright © 2017 Ashish Mishra. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var eventsCollectionView : UICollectionView!
    
    var eventsFetcher : ServiceCommunicator?
    var eventDetails : [EventInfo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventsFetcher = ServiceCommunicator()
        self.eventsFetcher?.fetchEventInfo(completionHandler: { (events, error) in
            if events != nil {
                
                self.eventDetails = events as! [EventInfo]
                
                DispatchQueue.main.async {
                    self.eventsCollectionView.reloadData()
                }
                
            }
        })
        self.title = "Phun App"
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (eventDetails.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: "EventInfoCell", for: indexPath) as! EventInfoCollectionViewCell
        
        let eventDetail = self.eventDetails[indexPath.item] 
        eventCell.timingLabel.text = eventDetail.eventDate!
        eventCell.eventNameLabel.text = eventDetail.title
        eventCell.placeLabel.text = eventDetail.place! + "," + eventDetail.city!
        eventCell.eventDescriptionLabel.text = eventDetail.eventDescription
        eventCell.backgroundColor = UIColor.lightGray
        
        
        if Reachability.isInternetAvailable() {
            self.retreiveImageData(eventDetail.imageLink, indexPath: indexPath)
        }else {
            eventCell.bgImageView.image =  eventDetail.bgImage
        }
    
        return eventCell
    }
    
    func retreiveImageData(_ posterPath : String?, indexPath: IndexPath) {
        
        if posterPath == nil {
            return
        }
        
        let imgURL: URL = URL(string: posterPath!)!
        
        URLSession.shared.dataTask(with: imgURL, completionHandler: { (data, response, erro) -> Void in
            
            let httpResponse = response as! HTTPURLResponse
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    return
                }
            DispatchQueue.main.async(execute: { () -> Void in
                var visibleIndexpaths = self.eventsCollectionView.indexPathsForVisibleItems
                if visibleIndexpaths.contains(indexPath) {
                    let cell = self.eventsCollectionView.cellForItem(at: indexPath) as! EventInfoCollectionViewCell
                    cell.bgImageView.image = UIImage(data: data)!
                    self.eventDetails[indexPath.row].bgImage = UIImage(data: data)!
                    CoreDataStack.sharedInstance.saveImageToCoreData(data: data, eventInfo: self.eventDetails[indexPath.row])
                }
                
            })
            
        }
        }) .resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "InfoToDetail", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVc = segue.destination as! EventInfoDetailViewController
        let indexPath = sender as! IndexPath
        detailVc.eventInfo = self.eventDetails[indexPath.row]
    }
}


extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let offset = 5
        let availableWidth = view.frame.width
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return CGSize(width: availableWidth, height: 200)

        case .pad:
            var widthPerItem = 0
            if UIDevice.current.orientation == .portrait {
                 widthPerItem = Int(CGFloat(availableWidth/2))-offset

            }else {
                 widthPerItem =  Int(CGFloat(availableWidth/3))-offset

            }
            return CGSize(width: widthPerItem, height: 200)

        case .unspecified:
            return CGSize(width: availableWidth, height: 200)
            
        default :
            return CGSize(width: availableWidth, height: 200)

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        guard let flowLayout = eventsCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
}

