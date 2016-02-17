//
//  ArticlesViewController.swift
//  Newscaster
//
//  Created by Owen LaRosa on 1/31/16.
//  Copyright © 2016 Owen LaRosa. All rights reserved.
//

import UIKit
import CoreData

class ArticlesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    
    var feed: Feed!
    var articles = [Article]()
    var insertedIndexPaths = [NSIndexPath]()
    var deletedIndexPaths = [NSIndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
        } catch _ {
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // set the title of the navigation bar
        navigationItem.title = feed.name
        
        if feed.articles.count == 0 {
            // nothing yet, fetch some news stories
            // but first, determine the type
            switch feed.type {
            case "rss" :
                loadRSSArticles()
            case "bing" :
                loadNewsArticles()
            default:
                break
            }
        }
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleTableViewCell")! as! ArticleTableViewCell
        let article = fetchedResultsController.objectAtIndexPath(indexPath) as! Article
        
        cell.headlineLabel.text = article.title
        cell.linkLabel.text = article.link
        // details about source and publication date
        cell.detailTextLabel?.text = ""
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let article = fetchedResultsController.fetchedObjects?[indexPath.row]
            performSegueWithIdentifier("OpenLink", sender: article)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        if let article = sender as? Article {
            let destination = segue.destinationViewController as! LinkViewController
            destination.article = article
        }
    }
    
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let fetchRequest = NSFetchRequest(entityName: "Article")
        // show newest articles at the top
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "feed == %@", self.feed)
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
    
    func loadRSSArticles() {
        NewsClient().getFeedForRSS(feed.url!) {result, error in
            if let returnedArticles = result {
                let mappedArticles: [Article] = returnedArticles.map({
                    let article = Article(newsItem: $0, context: sharedContext)
                    article.feed = self.feed
                    return article
                })
                dispatch_async(dispatch_get_main_queue()) {
                    self.feed.articles.addObjectsFromArray(mappedArticles)
                }
            }
        }
    }
    
    func loadNewsArticles() {
        NewsClient().getFeedForTerm(feed.query!) {result, error in
            if let returnedArticles = result {
                let mappedArticles: [Article] = returnedArticles.map({
                    let article = Article(newsItem: $0, context: sharedContext)
                    article.feed = self.feed
                    return article
                })
                dispatch_async(dispatch_get_main_queue()) {
                    self.feed.articles.addObjectsFromArray(mappedArticles)
                }
            }
        }
    }
    
}
