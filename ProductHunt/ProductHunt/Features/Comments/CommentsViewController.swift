//
//  CommentsViewController.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 26/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController {

    var viewModel:CommentsViewModel?
    @IBOutlet weak var tableVoewComments:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewModelObservers()
        viewModel?.getComments()
        tableVoewComments.delegate = self
        tableVoewComments.dataSource = self
        tableVoewComments.estimatedRowHeight = 50
        tableVoewComments.rowHeight = UITableView.automaticDimension
    }
    
    func setUpViewModelObservers(){
        viewModel?.commentsReceived = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.tableVoewComments.reloadData()
            }
        }
    }

}

extension CommentsViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel?.commentsCount ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cellId")
        if let commentVm = self.viewModel?.arrayDataSource[indexPath.row]{
            cell.textLabel?.text = commentVm.body
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = "-By \(commentVm.user)"
        }
        return cell
    }
    
}
