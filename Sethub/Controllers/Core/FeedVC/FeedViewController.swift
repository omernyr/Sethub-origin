import UIKit
import SnapKit
import FirebaseAuth
import SDWebImage
import Firebase

class FeedViewController: UIViewController {
    
    var viewModel = FeedTableViewModel()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.black.cgColor
        label.textColor = .black
        return label
    }()
    
    let feedPostTableView: UITableView = {
        let tv = UITableView()
        tv.showsVerticalScrollIndicator = false
        tv.register(FeedProductViewCell.self, forCellReuseIdentifier: "cell")
        tv.separatorStyle = .none
        tv.backgroundColor = .init(hexString: "#EDF0F3")
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        handleNotAuthenticated()
    }
    
    private func setupUI() {
        feedPostTableView.dataSource = self
        feedPostTableView.delegate = self
        view.backgroundColor = .init(hexString: "#EDF0F3")
        view.addSubview(feedPostTableView)
        makeConstraints()
        reloadTableView()
    }
    
    func reloadTableView() {
        viewModel.parseJSON {
            DispatchQueue.main.async {
                self.feedPostTableView.reloadData()
            }
        }
    }
        
    private func makeConstraints() {
        feedPostTableView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
    
    private func handleNotAuthenticated() {
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                let loginVC = LoginViewController()
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: true)
            } else {
                let email = Auth.auth().currentUser?.email
                
                guard let atIndex = email?.firstIndex(of: "@") else { return }
                
                let domain = email!.suffix(from: email!.index(after: atIndex))
                self.userLabel.text = domain.base
            }
        }
    }
}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FeedProductViewCell else { return UITableViewCell() }
        
        viewModel.configureCell(cell, at: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post = viewModel.products[indexPath.row]
        let vc = PostViewController()
        vc.post = post
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 480
    }

}
