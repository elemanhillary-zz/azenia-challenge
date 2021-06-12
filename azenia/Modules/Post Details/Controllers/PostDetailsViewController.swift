//
//  PostDetailsViewController.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import UIKit

class PostDetailsViewController: UIViewController {
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postCommentsLabel: UILabel!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    private var commentViewModel = CommentViewModel()
    private lazy var dataSource = commentViewModel.makeDataSource(tableView: self.commentsTableView)
    
    var postTitle = String.init()
    var postBody = String.init()
    var postAuthor = String.init()
    var postId = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postTitleLabel.text = self.postTitle
        self.postLabel.text = self.postBody
        self.postAuthorLabel.text = self.postAuthor
        self.commentViewModel.postId = self.postId
        self.commentsTableView.register(UINib.init(nibName: ReusableIdentifiers.TableView.commentsTableViewCell, bundle: nil), forCellReuseIdentifier: ReusableIdentifiers.TableView.commentsTableViewCell)
        self.fetchComments()
    }
    
    func fetcCache() {
        if let cache = [CommentsResponse].deserialize(from: JSON.readJson2DicWithFileName(fileName: "Comments")) {
            let cacheMap = cache.compactMap {$0}
            let _comments = cacheMap.filter {$0.postId! == self.postId}
            self.commentViewModel.comments = _comments
            DispatchQueue.main.async {
                self.commentViewModel.update(with: self.commentViewModel.comments, dataSource: self.dataSource)
            }
        }
    }
    
    func fetchComments() {
        fetcCache()
        self.commentViewModel.fetchComments(completion: {[weak self] (response, error) in
            if error == nil {
                let _comments = response!.filter {$0.postId! == self!.postId}
                self?.commentViewModel.update(with: _comments, dataSource: self!.dataSource)
            } else {
                self?.fetcCache()
            }
        })
    }
    
    @IBAction func exitPostDetails(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
