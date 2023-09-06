import UIKit
import SnapKit
import FirebaseFirestore
import Firebase

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var allPosts: [UploadedPost] = []
    var filteredPosts: [UploadedPost] = [] // Filtrelenmiş sonuçları tutmak için dizi
    var categories: [String] = [] // Ürün kategorilerini tutmak için dizi
    
    var viewModel = SearchTableViewModel()
    
    private let searchResultPostsTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(FeedProductViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let categoryTableView: UITableView = {
        let tableView = UITableView()
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "categoryCell")
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .clear // İsteğinize göre renk ayarlayabilirsiniz
        return tableView
    }()
    
    let searchPostTextField: UITextField = {
        let field = UITextField()
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.black.cgColor
        field.backgroundColor = .init(hexString: "fcfcfc")
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.placeholder = "Search post"
        field.leftViewMode = .always
        
        // Search ikonunu eklemek için UIImageView oluşturun ve leftView'e ata
        let searchIconImageView = UIImageView(image: UIImage(named: "search-outline"))
        searchIconImageView.contentMode = .scaleAspectFit
        searchIconImageView.frame = CGRect(x: 10, y: 0, width: 20, height: 20) // İstediğiniz boyutları ayarlayabilirsiniz
        
        // leftView'ın boyutunu düzenlemek için içeren bir UIView oluşturun
        let leftViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        leftViewContainer.addSubview(searchIconImageView)
        field.leftView = leftViewContainer
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        return field
    }()

    let closeKeyboardButton: UIButton = {
        let btn = UIButton()
        btn.isHidden = true
        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        btn.tintColor = .black
        btn.layer.cornerRadius = 13
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        reloadTableViews()
    }
    
    func setupUI() {
        view.backgroundColor = .init(hexString: "#EDF0F3")
        addViews()
        closeKeyboardButton.addTarget(self, action: #selector(dismissKeyboard), for: .touchUpInside)
        searchResultPostsTableView.delegate = self
        searchResultPostsTableView.dataSource = self
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        searchPostTextField.delegate = self
        makeConstraints()
    }
    
    func reloadTableViews() {
        viewModel.fetchAllPosts {
            self.searchResultPostsTableView.reloadData()
            self.categoryTableView.reloadData()
        }
    }
    
    private func addViews() {
        searchPostTextField.addSubview(closeKeyboardButton)
        view.addSubview(searchResultPostsTableView)
        view.addSubview(categoryTableView)
        view.addSubview(searchPostTextField)
    }
    
    @objc func dismissKeyboard() {
        closeKeyboardButton.isHidden = true
        searchPostTextField.text = ""
        searchPostTextField.resignFirstResponder()
    }
    
    func makeConstraints() {
        searchPostTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        categoryTableView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(searchPostTextField.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        
        searchResultPostsTableView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(searchPostTextField.snp.bottom).offset(10)
        }
        
        closeKeyboardButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(3)
            make.width.equalTo(40)
            make.height.equalTo(20)
        }
    }
    
    func searchPostsByCategory(category: String) {
        viewModel.filteredPosts = viewModel.allPosts.filter { $0.category == category }
        // MARK: FIX IT!
        let vc = CategorizedPotsViewController()
        vc.products = viewModel.filteredPosts
        vc.feedPostTableView.reloadData()
        self.present(vc, animated: true)
    }
    
}

extension SearchViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.searchResultPostsTableView {
            return viewModel.numberOfRowInSectionForPosts(in: section)
        } else if tableView == self.categoryTableView {
            return viewModel.numberOfRowInSectionForCategories(in: section)
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.searchResultPostsTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FeedProductViewCell else { return UITableViewCell() }
            viewModel.configureCellForPosts(cell, at: indexPath)
            return cell
            
        } else if tableView == self.categoryTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            viewModel.configureCellForCategories(cell, at: indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.searchResultPostsTableView {
            return 480
        } else if tableView == self.categoryTableView {
            return 50 // İsteğinize göre boyutu ayarlayabilirsiniz
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.searchResultPostsTableView {
            
            let post = viewModel.filteredPosts[indexPath.row]
            let vc = PostViewController()
            vc.post = post
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
        } else if tableView == self.categoryTableView {
            // Ürün kategorisine göre arama yapmak istediğiniz işlemleri burada yapabilirsiniz
            let selectedCategory = viewModel.categories[indexPath.row]
                
            self.viewModel.searchPostsByCategory(category: selectedCategory) {
                let vc = CategorizedPotsViewController()
                // MARK: FIX IT!
                vc.products = self.viewModel.filteredPosts
                vc.feedPostTableView.reloadData()
                self.present(vc, animated: true)
            }
            
        }
    }
}

extension SearchViewController {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let searchText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            viewModel.searchPosts(userEmail: searchText)
            searchResultPostsTableView.reloadData()

        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text, !searchText.isEmpty {
            viewModel.searchPosts(userEmail: searchText)
            searchResultPostsTableView.reloadData()
            categoryTableView.isHidden = true
        } else {
            categoryTableView.isHidden = false
        }
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let searchText = textField.text, !searchText.isEmpty {
            categoryTableView.isHidden = true
        } else {
            categoryTableView.isHidden = false
        }
    }
}
