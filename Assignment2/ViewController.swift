//
//  ViewController.swift
//  Assignment2
//
//  Created by JULIAN BUTLER on 28/04/2017.
//  Copyright © 2017 JULIAN BUTLER. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //call article metadata
        fetchRequest()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func fetchRequest()
    {
        var urlString = "https://newsapi.org/v1/articles?source=engadget&sortBy=top&apiKey=de2091da5b29434c9bace5cfa328c058"
        
        let request = URLRequest(url: URL(string: urlString)!)
        
        let urlSessionDataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            //data - server-returned data.
            //response - (e.g. HTTP headers and status code (like 200 OK))
            //error - indicates why the request was unsuccessful, or nil if request successful
            
            if error != nil
            {
                print ("Error is nil")
                return //cancel the fetch
            }
            
            //create empty articlesArray object
            self.articlesArray = [Article]()
            
            do {
                //json metadata
                let sourceMetadata = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                
                //get data from articles dictionary
                if let dictArticles = sourceMetadata["articles"] as? [[String : AnyObject]]
                {
                    for dictArticle in dictArticles
                    {
                        let article = Article()
                        
                        //parse article details
                        if let author = dictArticle["author"] as? String, let heading = dictArticle["title"] as? String, let description = dictArticle["description"] as? String, let url = dictArticle["url"] as? String, let date = dictArticle["publishedAt"] as? String
                        {
                            //assign the constants that were just defined to an instance of type Article
                            article.author = author
                            article.heading = heading
                            article.descriptionArticle = description
                            article.url = url
                            article.date = date
                        }
                        self.articlesArray?.append(article)
                    }
                }
                
            } catch let error
            {   print(error)    }
            
        }
    }
    
    var articlesArray : [Article]? = []
    
    @IBOutlet weak var outletTableView: UITableView!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let field = outletTableView.dequeueReusableCell(withIdentifier: "fieldArticle", for: indexPath) as! ArticleField
        
        //testing w/ hardcoded value
        field.outletHeading.text = "display heading"
        
        return field
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //check if articlesArray contents are empty or not
        if self.articlesArray?.count != nil
        {
            //populate each row with article details
            return (self.articlesArray?.count)!
        } else
        { return 0 }
    }
}

//requires UIKit. declares NSObject
class Article: NSObject {
    
    var author : String?
    var date : String?
    var heading : String?
    var descriptionArticle : String?
    var url : String?
}

//requires UIKit.
class ArticleField: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var outletAuthor: UILabel!
    @IBOutlet weak var outletHeading: UILabel!
    @IBOutlet weak var outletDescription: UILabel!

    
}
