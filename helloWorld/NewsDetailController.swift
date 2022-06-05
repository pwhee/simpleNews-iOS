//
//  NewsDetailController.swift
//  helloWorld
//
//  Created by 박원희 on 2022/06/04.
//  Copyright © 2022 박원희. All rights reserved.
//

import UIKit

class NewsDetailController: UIViewController{
    
    @IBOutlet weak var ImageMain: UIImageView!
    @IBOutlet weak var LabelMain: UILabel!
    
    var imageUrl: String?
    var desc: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let img = imageUrl{
            if let data = try? Data(contentsOf: URL(string: img)!){
                //Main Thread
                DispatchQueue.main.async{
                    self.ImageMain.image = UIImage(data: data)
                }
            }

        }
        
        if let d = desc{
            self.LabelMain.text = d
        }
    }
}
