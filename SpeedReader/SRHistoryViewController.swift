//
//  SRHistoryViewController.swift
//  SpeedReader
//
//  Created by Bright on 7/16/17.
//  Copyright © 2017 Kay Yin. All rights reserved.
//

import Cocoa

class SRHistoryViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    @IBOutlet weak var tableView: NSTableView!
    var articles:[Article] = []

    @IBOutlet var contextMenu: NSMenu!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getAllArticles()
    }
    
    func getAllArticles() {
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                let fetchRequest: NSFetchRequest<Article> = Article.fetchRequest()
                fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastUpdated", ascending: false)]
                articles = try context.fetch(fetchRequest)
            } catch {
                print("Fetch article failed")
            }
        }
        if tableView != nil {
            tableView.reloadData()
            if articles.count > 0 {
                let indexSet = NSIndexSet(index: 0)
                tableView.selectRowIndexes(indexSet as IndexSet, byExtendingSelection: false)
            }
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        if articles.count <= 0 {
            showOnboardingExperience()
        } else {
            hideOnboardingExperience()
        }
        return articles.count
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return SRTableRowView()
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let view = tableView.make(withIdentifier: "HistoryEntryCell", owner: self) as? SRArticleSnippetCellView {
            let article = articles[row]
            if let time = article.lastUpdated {
                view.articleTime.stringValue = time.description
            }
            if let content = article.content {
                view.articleSummary.stringValue = content
            }
            if article.typeOfArticle == 1 {
                view.iconView.image = NSImage.init(named: "openLocal")
            } else if article.typeOfArticle == 2 {
                view.iconView.image = NSImage.init(named: "openWeb")
            } else{
                view.iconView.image = NSImage.init(named: "createNew")
            }
            return view
        }
        return nil
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 75
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let row = tableView.selectedRow
        print(tableView.selectedRow)
        if row == -1 {
            showOnboardingExperience()
            return
        } else {
            hideOnboardingExperience()
            let article = articles[row]
            if let articleVC = (NSApplication.shared().mainWindow?.contentViewController as? SRSplitViewController)?.splitViewItems[1].viewController as? ArticleViewController {
                articleVC.article = article
                articleVC.updateToReflectArticle()
                articleVC.guidanceView.isHidden = true
                articleVC.outerTextScrollView.isHidden = false
            }
            if let preferenceVC = (NSApplication.shared().mainWindow?.contentViewController as? SRSplitViewController)?.splitViewItems[2].viewController as? SRPreferencesViewController {
                preferenceVC.article = article
                preferenceVC.updateToReflectArticle()
            }
        }
    }
    
    @IBAction func delete(_ sender: NSMenuItem) {
        print(tableView.clickedRow)
        if let context = (NSApplication.shared().delegate as? AppDelegate)?.persistentContainer.viewContext {
            context.delete(articles[tableView.clickedRow])
            (NSApplication.shared().delegate as? AppDelegate)?.saveAction(nil)
            getAllArticles()
        }
    }
    
    func showOnboardingExperience() {
        if let articleVC = (NSApplication.shared().mainWindow?.contentViewController as? SRSplitViewController)?.splitViewItems[1].viewController as? ArticleViewController {
            articleVC.article = nil
            articleVC.guidanceView.isHidden = false
            articleVC.outerTextScrollView.isHidden = true
        }
        if let preferenceVC = (NSApplication.shared().mainWindow?.contentViewController as? SRSplitViewController)?.splitViewItems[2].viewController as? SRPreferencesViewController {
            preferenceVC.article = nil
            preferenceVC.tableView.reloadData()
        }
        if let mainWindow = NSApplication.shared().mainWindow?.windowController as? MainWindowController {
            mainWindow.readButton.isEnabled = false
        }
    }
    
    func hideOnboardingExperience() {
        if let mainWindow = NSApplication.shared().mainWindow?.windowController as? MainWindowController {
            mainWindow.readButton.isEnabled = true
        }
    }

    
}
