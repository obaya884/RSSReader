//
//  Presenter.swift
//  RSSReader
//
//  Created by 大林拓実 on 2020/11/28.
//

import Foundation

// プレゼンターが持つべきメソッドやプロパティを定義
protocol PresenterInput {
    var numberOfItems: Int{get}
    func item(forRow row: Int) -> Item?
    func didSelectRow(at indexPath: IndexPath)
    func viewDidLoad()
}

// プレゼンターと紐づく相手、つまりビューが持つべきメソッドやプロパティを定義
protocol PresenterOutput: AnyObject {
    func updateItems()
    func transitionToItemPage(itemTitle: String)
}

final class Presenter: PresenterInput {
    
    // モデルから返される記事の情報を保持するItem型の配列
    private(set) var items: [Item] = []
    
    private weak var view: PresenterOutput!
    private var model: ModelInput
    
    init(view: PresenterOutput, model: ModelInput) {
        self.view = view
        self.model = model
    }
    
    // itemsの要素数を保持する変数（コンピューテッドプロパティ）
    var numberOfItems: Int {
        return items.count
    }
    
    // 特定の記事情報（Item型）を返す関数
    func item(forRow row: Int) -> Item? {
        guard row < items.count else {
            return nil
        }
        return items[row]
    }
    
    // TableView内のセルがタップされた時の処理を記述した関数
    func didSelectRow(at indexPath: IndexPath) {
        // 対応する記事情報（Item型）を取得
        guard let item = item(forRow: indexPath.row) else {
            return
        }
        
        // ビューに処理を任せる（画面遷移はプレゼンター内で行えないため）
        view.transitionToItemPage(itemTitle: item.url!)
    }
    
    // 画面初期化時に表示設定以外に必要なデータを用意する関数
    func viewDidLoad() {
        
        // モデルから記事情報の配列を受け取ってビュー内のTableViewを更新する
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
