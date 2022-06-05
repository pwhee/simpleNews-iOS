//
//  TableController.swift
//  helloWorld
//
//  Created by 박원희 on 2022/06/01.
//  Copyright © 2022 박원희. All rights reserved.
//

import UIKit

class TableController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var TableViewMain: UITableView!
    @IBOutlet weak var newsCount: UILabel!
    
    var newsData :Array<Dictionary<String, Any>>?
    // 1. api 통신 - urlsession
    // 2. json parsing
    // 3. 테이블 뷰의 데이터 매칭 <- 통보
    // 네트워크 통신은 백그라운드에서 실행 중 / ui를 그리는건 Main
    
    func getNews() {
        let task = URLSession.shared.dataTask(with: URL(string: "https://newsapi.org/v2/top-headlines?country=kr&apiKey=0e21255809ee4c4a9b2c21d04249a66a&pageSize=20&sortBy=popularity")!) { (data, response, error) in
            if let dataJson = data {
                // json parsing
                do {
                    let json = try JSONSerialization.jsonObject(with: dataJson, options: []) as! Dictionary<String, Any>
                    print(json)
                    // Dictionary
                    let articles = json["articles"] as! Array<Dictionary<String, Any>>
//                    totalResults
                    self.newsData = articles
                    
                    
                    
                    DispatchQueue.main.async {
                        self.TableViewMain.reloadData()
                        self.newsCount.text = "count: \(articles.count)"
                    }
                    
                }
                catch{}
            }
        }
        
        task.resume()
    }
    
    // 셀을 반복할 횟수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // data count
        if let news = newsData{
            return news.count
        }else{
            return 0
        }
    }
    
    // 위 numberOfRowsInSection 숫자만큼 반복
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // data value
//        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "TableCellType1")
        let cell = TableViewMain.dequeueReusableCell(withIdentifier: "Type1", for: indexPath) as! Type1
        
        // as? as! - 부모 자식 친자 확인
        let idx = indexPath.row
        if let news = newsData{
            let row = news[idx]
            if let r = row as? Dictionary<String, Any> {
                if let title = r["title"] as? String {
                    cell.LabelText.text = title
                }
            }
        }
//        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
    }
    
    // cell click action
    @available(iOS 13.0, *)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "NewsDetailController") as! NewsDetailController
        
        if let news = newsData {
            let row = news[indexPath.row]
            if let r = row as? Dictionary<String, Any> {
                if let imageUrl = r["urlToImage"] as? String {
                    controller.imageUrl = imageUrl
                }
                if let desc = r["description"] as? String {
                    controller.desc = desc
                    print(desc)
                }
            }
        }
        // 이동하기
//        showDetailViewController(controller, sender: nil)
    }
    
    //2. 세그웨이 : 부모(가나다)-자식(가나다)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = segue.identifier, "NewsDetail" == id {
            if let controller = segue.destination as? NewsDetailController {
                if let news = newsData {
                    if let indexPath = TableViewMain.indexPathForSelectedRow{
                    
                        let row = news[indexPath.row]
                        if let r = row as? Dictionary<String, Any> {
                            if let imageUrl = r["urlToImage"] as? String {
                                controller.imageUrl = imageUrl
                            }
                            if let desc = r["description"] as? String {
                                controller.desc = desc
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    // detail 상세 화면 만들기
    // 값 보내기 2가지
    // 1. tableview delegate / 2. storyboard (segue)
    // 3. 화면 이동 ( 이동하기 전에 값이 미리 셋팅해야 함)
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        TableViewMain.delegate = self
        TableViewMain.dataSource = self
        
        getNews()
    }
}
