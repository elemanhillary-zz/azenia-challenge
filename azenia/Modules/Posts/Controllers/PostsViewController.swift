//
//  PostsViewController.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import UIKit

class PostsViewController: UIViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var searchBar: UITextField!
    
    @IBOutlet weak var postsTableView: UITableView!
    
    private var postsViewModel = PostViewModel()
    private lazy var dataSource = postsViewModel.makeDataSource(tableView: self.postsTableView)
    
    private var dispatchQueue = DispatchQueue(label: "equity.azenia.azenia")
    private var dispatchGroup = DispatchGroup()
    
    private var refreshControl = UIRefreshControl()
    private var isSearching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPosts()
        self.configureSearchBar()
        self.dateLabel.text = Date().dateToString
        self.postsTableView.delegate = self
        self.postsTableView.separatorStyle = .none
        self.postsTableView.register(UINib.init(nibName: ReusableIdentifiers.TableView.postTableViewCell, bundle: nil), forCellReuseIdentifier: ReusableIdentifiers.TableView.postTableViewCell)
        if #available(iOS 10.0, *) {
            self.postsTableView.refreshControl = refreshControl
        } else {
            self.postsTableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(self.fetchPosts), for: .valueChanged)
    }
    
//    MARK: - Load Cached
    func loadCache() {
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            if let cache = [UsersResponse].deserialize(from: JSON.readJson2DicWithFileName(fileName: "Users")) {
                let cacheMap = cache.compactMap {$0}
                DispatchQueue.main.async {
                    self.postsViewModel.users = cacheMap
                }
                
            }
            self.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            if let cache = [UsersResponse].deserialize(from: JSON.readJson2DicWithFileName(fileName: "Users")) {
                let cacheMap = cache.compactMap {$0}
                self.postsViewModel.users = cacheMap
            }
            if let cache = [PostsResponse].deserialize(from: JSON.readJson2DicWithFileName(fileName: "Posts")) {
                let cacheMap = cache.compactMap {$0}
                DispatchQueue.main.async {
                    self.postsViewModel.posts = cacheMap
                    self.postsViewModel.update(tableView: self.postsTableView, with: cacheMap, dataSource: self.dataSource)
                    
                    self.postsTableView.textState(show: false)
                }
            }
            self.dispatchGroup.leave()
        }
    }
    
//    MARK: - Fetch Users Before Posts, So we are able to show author's name on post
    @objc func fetchPosts() {
        self.loadCache()
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.postsViewModel.fetchUsers(completion: {[weak self] (response, error) in
                if error == nil {
                    self?.dispatchGroup.leave()
                } else {
                    self?.dispatchGroup.leave()
                }
            })
        }
        dispatchGroup.enter()
        dispatchQueue.async(group: dispatchGroup) {
            self.postsViewModel.fetchPosts(completion: {[weak self] (response, error) in
                if error == nil {
                    self?.postsTableView.textState(show: false)
                    self?.dispatchGroup.leave()
                } else {
                    self?.postsTableView.textState(show: false)
                    self?.postsTableView.textState(show: true)
                    self?.dispatchGroup.leave()
                }
            })
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.postsViewModel.update(tableView: self.postsTableView, with: self.postsViewModel.posts, dataSource: self.dataSource)
            self.postsTableView.refreshControl?.endRefreshing()
        }
//        loadCache()
        self.postsTableView.textState(show: true, message: "Loading Posts...")
    }
    
//    MARK: - Customize TextField
    func configureSearchBar() {
        let searchBarIconView = UIImageView(image: UIImage.init(systemName: "magnifyingglass"))
        searchBarIconView.tintColor = UIColor.systemGray
        self.searchBar.inputAccessoryView = UIView()
        self.searchBar.borderStyle = .none
        self.searchBar.layer.cornerRadius = self.searchBar.bounds.height / 2
        self.searchBar.layer.borderWidth = 0.5
        self.searchBar.layer.borderColor = UIColor.systemGray.cgColor
        self.searchBar.leftView = searchBarIconView
        self.searchBar.rightView = nil
        self.searchBar.delegate = self
        self.searchBar.addTarget(self, action: #selector(self.textViewDidChangeEditing), for: .editingChanged)
        self.searchBar.leftViewMode = .always
        self.searchBar.returnKeyType = .search
        self.searchBar.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.init(name: "Avenir Heavy", size: 14)!])
    }
    
//    MARK: - Navigate to Post Details
    func openPost(post: PostsResponse, authorName: String) {
        let storyboard = UIStoryboard.init(name: "PostDetails", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: "PostDetailsViewController") as? PostDetailsViewController {
            controller.postTitle = post.title ?? ""
            controller.postBody = post.body ?? ""
            controller.postId = post.id ?? 0
            controller.postAuthor = authorName
            DispatchQueue.main.async {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

extension PostsViewController: UITextFieldDelegate {
    @objc func textViewDidChangeEditing() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.searchContent(search:)), object: searchBar)
        self.perform(#selector(searchContent(search:)), with: searchBar, afterDelay: 0.5)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchBar {
            textField.resignFirstResponder()
            return false
        }
        return true
    }
    
    @objc func searchContent(search: UITextField) {
        if (search.hasText) {
            self.isSearching = true
            let filter = self.postsViewModel.posts.filter {
                if ($0.title?.lowercased().contains(search.text!.lowercased()))! || ($0.body?.lowercased().contains(search.text!.lowercased()))! {
                    return true
                }
                return false
            }
            
            self.postsViewModel.searchData = filter
            self.postsViewModel.update(tableView: self.postsTableView, with: filter, dataSource: dataSource)
        } else {
            self.isSearching = false
            self.postsViewModel.update(tableView: self.postsTableView, with: self.postsViewModel.posts, dataSource: dataSource)
        }
    }
}

extension PostsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell else { return }
        DispatchQueue.main.async {
            self.postsTableView.refreshControl?.endRefreshing()
        }
        if self.isSearching {
            self.openPost(post: self.postsViewModel.searchData[indexPath.row], authorName: cell.authorName.text ?? "")
        } else {
            self.openPost(post: self.postsViewModel.posts[indexPath.row], authorName: cell.authorName.text ?? "")
        }
    }
}
