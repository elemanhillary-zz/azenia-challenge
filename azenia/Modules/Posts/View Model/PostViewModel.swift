//
//  PostViewModel.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import UIKit

class PostViewModel {
    var posts = [PostsResponse]()
    var users = [UsersResponse]()
    var searchData = [PostsResponse]()
    
    enum Sections: CaseIterable {
        case posts
    }
    
    func fetchPosts(completion:((_ posts: [PostsResponse]?, _ error: Error?)->())?=nil) {
        PostsRequest.getPosts(success: {[weak self] response in
            if let _response = response as? [PostsResponse] {
                self?.posts = _response
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let _ = try JSON.saveJson2DicWithFileName(jsonObject: _response.toJSON() as Any, toFilename: "Posts")
                    } catch {
                    }
                }
                completion?(_response, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
    
    func fetchUsers(completion:((_ users: [UsersResponse]?, _ error: Error?)->())?=nil) {
        UsersRequest.getUsers(success: {[weak self] response in
            if let _response = response as? [UsersResponse] {
                self?.users = _response
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let _ = try JSON.saveJson2DicWithFileName(jsonObject: _response.toJSON() as Any, toFilename: "Users")
                    } catch {
                    }
                }
                completion?(_response, nil)
            }
        }, failure: { error in
            completion?(nil, error)
        })
    }
}

extension PostViewModel {
    func makeDataSource(tableView: UITableView) -> UITableViewDiffableDataSource<Sections, PostsResponse> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { [weak self] (tableView, indexPath, post) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifiers.TableView.postTableViewCell, for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            
            cell.postTitle.text = post.title ?? ""
            let user = self?.users.filter {$0.id == post.userId}
            cell.authorName.text = "Author: " + (user?.first?.username ?? "")
            cell.authorImage.setTitle(String(user?.first?.username?.first ?? Character(" ")) , for: .normal)
            cell.authorImage.backgroundColor = .random()
                        

            return cell
        })
    }
    
    func update(tableView: UITableView, with _posts: [PostsResponse], animate: Bool = false, dataSource: UITableViewDiffableDataSource<Sections, PostsResponse>) {
        var snapShot = NSDiffableDataSourceSnapshot<Sections,PostsResponse>()
        snapShot.appendSections(Sections.allCases)
        snapShot.appendItems(_posts, toSection: .posts)
        if _posts.count == 0 {
            DispatchQueue.main.async {
                tableView.textState(show: true)
            }
        } else {
            DispatchQueue.main.async {
                tableView.textState(show: false)
            }
        }
        dataSource.apply(snapShot, animatingDifferences: animate)
    }
}
