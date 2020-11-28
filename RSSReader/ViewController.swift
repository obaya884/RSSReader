//
//  ViewController.swift
//  RSSReader
//
//  Created by 大林拓実 on 2020/11/28.
//

import UIKit
import SafariServices

final class ViewController: UIViewController{
    
    private var presenter: PresenterInput!
    func inject (presenter: PresenterInput) {
        self.presenter = presenter
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        let item = presenter.item(forRow: indexPath.row)
        cell.textLabel?.text = item?.title
        
        return cell
    }
    
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ViewController: PresenterOutput {
    func updateItems() {
        tableView.reloadData()
    }
    
    func transitionToItemPage(itemTitle: String) {
        let safariVC = SFSafariViewController(url: NSURL(string: itemTitle)! as URL)
        present(safariVC, animated: true, completion: nil)
    }
    
}

