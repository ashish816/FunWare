//
//  ServiceCommunicator.swift
//  PhunwareAssignment
//
//  Created by Ashish Mishra on 6/22/17.
//  Copyright © 2017 Ashish Mishra. All rights reserved.
//

import UIKit
import CoreData


class ServiceCommunicator: NSObject {
    
    func fetchEventInfo(completionHandler : @escaping ([Any]?, Error?) -> ()){
        
        if !Reachability.isInternetAvailable() {
            CoreDataStack.sharedInstance.fetchResultsFromCoreData(completionHandler: completionHandler)
        }else {
    
        let urlString:String = "https://raw.githubusercontent.com/phunware-services/dev-interview-homework/master/feed.json"
        
        let url = URL(string: urlString)
        let request = URLRequest(url: url!);
        URLSession.shared.dataTask(with: request, completionHandler: { (data , response, error) -> Void in
            guard data != nil else {
                completionHandler(nil, error)
                return
            }
            
            let results = self.parseResults(data!)
            
            DispatchQueue.global(qos: .background).async {
                CoreDataStack.sharedInstance.saveInCoreDataWithEvents(events: results!)
            }
            completionHandler(results,nil)
            
        }) .resume()
        }
    }
    

    
    func parseResults(_ requestData : Data) -> [EventInfo]? {
        do {
            let jsonResult = try JSONSerialization.jsonObject(with: requestData, options: .allowFragments)
    
            guard let results: NSArray = jsonResult as? NSArray else {
                return nil
            }
            var events  = [EventInfo]()
            for  Obj in results {
                let eventDetail = EventInfo();
                let eventInfo = Obj as? Dictionary<String, Any>;
                eventDetail.eventId = eventInfo!["id"] as? Int;
                eventDetail.eventDescription = eventInfo!["description"] as? String;
                eventDetail.title = eventInfo!["title"] as? String;
                if eventInfo!["date"] != nil {
                let dateFormatter = DateFormatter()
                eventDetail.eventDate = dateFormatter.eventDateFromDate(dateString: eventInfo!["date"] as! String)
                }
                eventDetail.imageLink = eventInfo!["image"] as? String;
                eventDetail.city = eventInfo!["locationline1"] as? String;
                eventDetail.place = eventInfo!["locationline2"] as? String; 
                
                events.append(eventDetail);
            }
            
            return events
        }
        catch {
            return nil
        }
    }

}

extension DateFormatter {
    
    func eventDateFromDate(dateString : String)-> String {
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
        self.timeZone = NSTimeZone(name: "GMT")! as TimeZone
        let date = self.date(from: dateString)
        
        self.timeZone = NSTimeZone.local
        self.dateFormat = "MMM d, yyyy - h:mm a"
        return self.string(from:date!)
    }
}
