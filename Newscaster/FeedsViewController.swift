//
//  FeedsViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/23/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit
import CoreData

class FeedsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var feeds = [Feed]()
    var insertedIndexPaths = [NSIndexPath]()
    var deletedIndexPaths = [NSIndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        //return root.feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FeedTableViewCell")! as! FeedTableViewCell
        //let feed = root.feeds.objectAtIndex(indexPath.row) as! Feed
        let feed = fetchedResultsController.objectAtIndexPath(indexPath) as! Feed
        
        cell.feedNameLabel.text = feed.name
        cell.feedDescriptionLabel.text = feed.url ?? feed.query
        
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let feed = fetchedResultsController.objectAtIndexPath(indexPath) as! Feed //root.feeds[indexPath.row] as! Feed
            sharedContext.deleteObject(feed)
            saveContext()
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        let object = fetchedResultsController.objectAtIndexPath(sourceIndexPath) //root.feeds.objectAtIndex(sourceIndexPath.row)
        root.feeds.removeObjectAtIndex(sourceIndexPath.row)
        root.feeds.insertObject(object, atIndex: destinationIndexPath.row)
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
        if let feed = sender as? Feed {
            let destination = segue.destinationViewController as! ArticlesViewController
            destination.feed = feed
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
        //fetchRequest.predicate = NSPredicate(format: "root == %@", root)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: sharedContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            insertedIndexPaths.append(newIndexPath!)
        case .Delete:
            deletedIndexPaths.append(indexPath!)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(insertedIndexPaths, withRowAnimation: .Fade)
        tableView.deleteRowsAtIndexPaths(deletedIndexPaths, withRowAnimation: .Fade)
        tableView.endUpdates()
        
        saveContext()
    }

}

