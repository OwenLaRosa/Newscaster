//
//  FeedsViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/23/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit
import CoreData
//import iAd

class FeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var feeds = [Feed]()
    var insertedIndexPaths = [NSIndexPath]()
    var deletedIndexPaths = [NSIndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //canDisplayBannerAds = true
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedTableViewCell")! as! FeedTableViewCell
        
        cell.feed = fetchedResultsController.objectAtIndexPath(indexPath) as! Feed
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let feed = fetchedResultsController.objectAtIndexPath(indexPath) as! Feed
            sharedContext.deleteObject(feed)
            saveContext()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let sourceFeed = (tableView.cellForRowAtIndexPath(sourceIndexPath) as! FeedTableViewCell).feed
        let numberOfObjects = fetchedResultsController.fetchedObjects?.count ?? 0
        // equal to the count since feeds are displayed in descending order by index
        var nextIndex = numberOfObjects
        for i in fetchedResultsController.fetchedObjects as! [Feed] {
            i.index = nextIndex
            if i == sourceFeed {
                i.index = numberOfObjects - destinationIndexPath.row
                continue
            }
            if numberOfObjects - destinationIndexPath.row == nextIndex {
                nextIndex--
                i.index = nextIndex
            }
            nextIndex--
        }
        saveContext()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //let feed = fetchedResultsController.objectAtIndexPath(indexPath)
        if let feed = fetchedResultsController.objectAtIndexPath(indexPath) as? Feed {
            performSegueWithIdentifier("ShowArticles", sender: feed)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if segue.identifier == "ShowArticles" {
            if let feed = sender as? Feed {
                let destination = segue.destinationViewController as! ArticlesViewController
                destination.feed = feed
            }
        } else if segue.identifier == "AddSource" {
            let destination = segue.destinationViewController as! AddSourceViewController
            // first object should contain the highest index
            if let index = (fetchedResultsController.fetchedObjects?.first as? Feed)?.index {
                // 1 more than the highest index
                (destination.index = index + 1)
            }
            // if there aren't any objects, the default index of 0 will be used
        }
    }
    
    @IBAction func editTapped(sender: UIBarButtonItem) {
        if tableView.editing {
            sender.title = "Edit"
        } else {
            sender.title = "Done"
        }
        tableView.setEditing(!tableView.editing, animated: true)
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Feed")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "index", ascending: false)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        /*switch type {
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
        case .Delete:
            deletedIndexPaths.append(indexPath!)
        default:
            return
        }*/
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        /*tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Fade)
        tableView.deleteRowsAtIndexPaths(deletedIndexPaths, withRowAnimation: .Fade)
        tableView.endUpdates()
        
        saveContext()*/
    }

}

