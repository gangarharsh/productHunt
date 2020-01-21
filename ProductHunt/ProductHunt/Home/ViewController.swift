//
//  ViewController.swift
//  ProductHunt
//
//  Created by Harsh Gangar on 20/01/20.
//  Copyright © 2020 Harsh Gangar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableviewPosts: UITableView!
    
    var viewModel:HomeViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        self.title = "POSTS"
        tableviewPosts.delegate = self
        tableviewPosts.dataSource = self
        tableviewPosts.rowHeight = UITableView.automaticDimension
        tableviewPosts.estimatedRowHeight = 40
        tableviewPosts.register(UINib(nibName: "PostsTableViewCell", bundle: nil), forCellReuseIdentifier: "postCell")


    }
    
    
    func setupViewModel(){
        viewModel = HomeViewModel()
        viewModel.getPosts()
        viewModel.postsReceived = { [weak self] in
            print("Post received")
            print("viewModel.postCount \(self?.viewModel.postCount ?? 0)")
            DispatchQueue.main.async {
                self?.tableviewPosts.reloadData()
            }
            
        }
        viewModel.errorFetchingPosts = { [weak self] in
            print("Post receive failed")
            
        }
    }
    


}


extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.postCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:PostsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "postCell")! as! PostsTableViewCell
        
        if(cell == nil)
        {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "postCell") as! PostsTableViewCell
        }
        
        let postVm = viewModel.arrayDataSource[indexPath.row]
        cell.labelCreative.text = "\(postVm.tagline)"
        cell.postTitle.text = "\(postVm.name)"
        if let url = URL(string: postVm.imageURL){
            cell.imageView?.downloadImage(from: url)
        }
        return cell
    }
    
}
