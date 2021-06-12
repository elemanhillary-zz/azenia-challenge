//
//  CommentViewModel.swift
//  azenia
//
//  Created by MacBook Pro on 6/11/21.
//

import Foundation
import UIKit
import Alamofire

class CommentViewModel {
    var comments = [CommentsResponse]()
    var postId = 0
    
    enum Sections: CaseIterable {
        case comments
    }
    
    func fetchComments(completion:((_ posts: [CommentsResponse]?, _ error: Error?)->())?=nil) {
        CommentsRequest.getComments(success: {[weak self] response in
            if let _response = response as? [CommentsResponse] {
                self?.comments = _response
                DispatchQueue.global(qos: .userInitiated).async {
                    do {
                        let _ = try JSON.saveJson2DicWithFileName(jsonObject: _response.toJSON() as Any, toFilename: "Comments")
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

extension CommentViewModel {
    func makeDataSource(tableView: UITableView) -> UITableViewDiffableDataSource<Sections, CommentsResponse> {
        return UITableViewDiffableDataSource(
            tableView: tableView,
            cellProvider: { (tableView, indexPath, comment) in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ReusableIdentifiers.TableView.commentsTableViewCell, for: indexPath) as? CommentsTableViewCell else {
                return UITableViewCell()
            }

            cell.commentAuthor.text = comment.email
            cell.commentLabel.text = comment.body

            return cell
        })
    }
    
    func update(with comments: [CommentsResponse], animate: Bool = false, dataSource: UITableViewDiffableDataSource<Sections, CommentsResponse>) {
        var snapShot = NSDiffableDataSourceSnapshot<Sections,CommentsResponse>()
        snapShot.appendSections(Sections.allCases)
        snapShot.appendItems(comments, toSection: .comments)
        dataSource.apply(snapShot, animatingDifferences: animate)
    }
}
