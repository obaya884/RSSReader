//
//  Model.swift
//  RSSReader
//
//  Created by 大林拓実 on 2020/11/28.
//

import Foundation

// モデルが持つべきメソッドやプロパティを定義
protocol ModelInput {
    func fetchItem(completion: @escaping ([Item]?)->())
}

final class Model: NSObject, ModelInput {
    
    // xmlの読み取りに必要な定数（要素名）
    private let ITEM_ELEMENT_NAME = "item"
    private let TITLE_ELEMENT_NAME = "title"
    private let LINK_ELEMENT_NAME   = "link"
    
    // 現在対象にしている要素名を保持する変数
    var currentParseElementName: String!
    
    // パース結果を保持するItem型の配列
    var items: [Item] = []

    // RSSフィードから返されるxmlをパースする関数
    // パース結果をクロージャに渡すことで呼び出し側で利用できるようにする
    func fetchItem(completion: @escaping ([Item]?)->()) {
        
        // 対象のRSSフィードのURL
        let url: URL = URL(string:"https://zenn.dev/feed")!
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            let parser: XMLParser? = XMLParser(data: data!)
            parser!.delegate = self
            
            // パース処理の中身はDelegateメソッドが実行する
            parser!.parse()
            
            completion(self.items)
        })
        //タスク開始
        task.resume()
    }
    
}

// XMLパーサでのパース処理を記述したExtension
extension Model: XMLParserDelegate {
    
    //解析_開始時
    func parserDidStartDocument(_ parser: XMLParser) {
        print("xmlパース開始")
    }
    
    //解析_要素の開始時
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        self.currentParseElementName = nil
        if elementName == ITEM_ELEMENT_NAME {
            self.items.append(Item())
        } else {
            currentParseElementName = elementName
        }
        
    }
    
    //解析_要素内の値を取得
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if self.items.count > 0 {
            let lastItem = self.items[self.items.count - 1]
            switch self.currentParseElementName {
            case TITLE_ELEMENT_NAME:
                let tmpString = lastItem.title
                lastItem.title = (tmpString != nil) ? tmpString! + string : string
            case LINK_ELEMENT_NAME:
                lastItem.url = string
            default: break
            }
        }
        
    }
    
    //解析_要素の終了時
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        currentParseElementName = nil
        
    }
    
    //解析_終了時
    func parserDidEndDocument(_ parser: XMLParser) {
        print("パース終了：\(items)")
        for item in items {
            print(item.title!)
            print(item.url!)
        }
    }
    
    //解析_エラー発生時
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("エラー:\(parseError.localizedDescription)")
    }
}
