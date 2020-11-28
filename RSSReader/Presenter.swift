//
//  Presenter.swift
//  RSSReader
//
//  Created by 大林拓実 on 2020/11/28.
//

import Foundation

protocol PresenterInput {
    var numberOfItems: Int{get}
    func item(forRow row: Int) -> Item?
    func didSelectRow(at indexPath: IndexPath)
    func viewDidLoad()
}

protocol PresenterOutput: AnyObject {
    func updateItems()
    func transitionToItemPage(itemTitle: String)
}

final class Presenter: PresenterInput {
    
    private(set) var items: [Item] = []
    
    private weak var view: PresenterOutput!
    private var model: ModelInput
    
    init(view: PresenterOutput, model: ModelInput) {
        self.view = view
        self.model = model
    }
    
    var numberOfItems: Int {
        return items.count
    }
    
    func item(forRow row: Int) -> Item? {
        guard row < items.count else {
            return nil
        }
        return items[row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard let item = item(forRow: indexPath.row) else {
            return
        }
        view.transitionToItemPage(itemTitle: item.url!)
    }
    
    func viewDidLoad() {
        model.fetchItem(completion: {[unowned self] returnItems in
            if let items = returnItems {
                self.items = items
            }
            DispatchQueue.main.async {
                self.view.updateItems()
            }
        })
    }

}
