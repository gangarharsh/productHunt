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
    @IBOutlet weak var searchBar: UISearchBar!
    var viewModel:HomeViewModel!
    var datePicker : UIDatePicker!
    let toolBar = UIToolbar()
    private var txtField: UITextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let indicator: UIActivityIndicatorView = UIActivityIndicatorView(style: .large)


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "POSTS"
        tableviewPosts.delegate = self
        tableviewPosts.dataSource = self
        tableviewPosts.rowHeight = UITableView.automaticDimension
        tableviewPosts.estimatedRowHeight = 40
        tableviewPosts.register(UINib(nibName: "PostsTableViewCell", bundle: nil), forCellReuseIdentifier: "postCell")
        tableviewPosts.isHidden = true
        setUpIndicator()
        setupViewModel()
        viewModel.getPosts()
        setUpDatePicker()
        searchBar.delegate = self
        searchBar.showsCancelButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func setupViewModel(){
        viewModel = HomeViewModel()
        viewModel.postsReceived = { [weak self] in
            print("viewModel.postCount \(self?.viewModel.postCount ?? 0)")
            DispatchQueue.main.async {
                self?.tableviewPosts.isHidden = false
                self?.tableviewPosts.reloadData()
            }
            
        }
        viewModel.errorFetchingPosts = {
            print("Post receive failed")
            
        }
        
        viewModel.showLoader = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.indicator.startAnimating()
            }
        }
        
        viewModel.hideLoader = { [weak self] in
            guard let `self` = self else {
                return
            }
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
        }
        
        viewModel.goToCommentsViewController = { [weak self] commemtsVM in
            guard let `self` = self else {
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let commentsVc = storyboard.instantiateViewController(withIdentifier: "CommentsViewControllerId") as? CommentsViewController
            {commentsVc.viewModel = commemtsVM
                self.navigationController?.pushViewController(commentsVc, animated: true)
            }

        }
    }
    
    
    @IBAction func filterPostForDate(_ sender: Any) {
        self.txtField.becomeFirstResponder()
    }
    
    func setUpIndicator(){
        indicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        indicator.center = view.center
        self.view.addSubview(indicator)
        self.view.bringSubviewToFront(indicator)
    }
    
    func setUpDatePicker(){
        datePicker                       = UIDatePicker()
        datePicker.datePickerMode        = .date
        datePicker.maximumDate           = Date()
        txtField.inputView               = datePicker
        
        let toolBar                      = UIToolbar()
        toolBar.barStyle                 = .default
        toolBar.isTranslucent            = true
        let cancelButton                 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ViewController.cancelDatePickerPressed))
        let space                        = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton                   = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(ViewController.doneDatePickerPressed))
        
        toolBar.isUserInteractionEnabled = true
        toolBar.setItems([cancelButton,space, doneButton], animated: false)
        toolBar.sizeToFit()
        
        txtField.inputAccessoryView = toolBar
        
        self.view.addSubview(txtField)
    }
    
    @objc func doneDatePickerPressed(){
        self.view.endEditing(true)
        viewModel.getPosts(forDate: self.datePicker.date)
    }

    
    @objc func cancelDatePickerPressed(){
        self.view.endEditing(true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.gotToCommentsVc(for: indexPath)
    }
}

extension ViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        viewModel.performSearch(textSearched)
    }
}
