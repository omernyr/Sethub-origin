import UIKit
import SnapKit
import Firebase
import FirebaseDatabase
import FirebaseStorage

class ImageEditViewController: UIViewController {
    
    var selectedImageURL = ""

    // Components
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "emptyUser")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        imageView.backgroundColor = .gray // Placeholder background color
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let usernameLabel: UITextField = {
        let label = UITextField()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let surnameLabel: UITextField = {
        let label = UITextField()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    
    let bioLabel: UITextField = {
        let label = UITextField()
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        return label
    }()
    
    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    // MARK: - GESTURES
    private lazy var pickerImageGestures = UITapGestureRecognizer(target: self, action: #selector(tapGestureImage))
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchUserData()
        setupLogoutButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        fetchUserData()
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        profileImageView.addGestureRecognizer(pickerImageGestures)
        addViews()
        makeConstraints()
    }
    
    public func addViews() {
        view.addSubview(profileImageView)
        view.addSubview(usernameLabel)
        view.addSubview(surnameLabel)
        view.addSubview(bioLabel)
        view.addSubview(saveButton)
    }
    
    private func makeConstraints() {
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.width.height.equalTo(100)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
        }
        
        surnameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameLabel.snp.centerY)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.leading.equalTo(usernameLabel.snp.trailing)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(view).inset(20)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(bioLabel.snp.bottom).offset(30)
            make.width.equalTo(150)
            make.height.equalTo(40)
        }
    }
    
    // MARK: - UI Configuration
    private func fetchUserData() {
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            return
        }

        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserUID)

        userRef.getDocument { [weak self] (document, error) in
            guard let document = document, document.exists, let data = document.data() else {
                print("Kullanıcı verileri alınamadı veya belirtilen kullanıcı bulunamadı.")
                return
            }

            // Firestore'dan alınan verileri çıkarın
            if let name = data["name"] as? String,
               let surname = data["surname"] as? String,
               let bio = data["bio"] as? String,
               let userProfileImageURL = data["userProfileImageURL"] as? String {
                let user = User(name: name, surname: surname, bio: bio, userProfileImageURL: userProfileImageURL)
                self?.updateUI(with: user)
            }

        }
    }
    
    func updateUI(with user: User) {
        // User yapısından gelen verileri kullanarak kullanıcı arayüzünü güncelle
        self.usernameLabel.text = user.name
        self.surnameLabel.text = user.surname
        self.bioLabel.text = user.bio
        self.profileImageView.sd_setImage(with: URL(string: user.userProfileImageURL))
    }
    
    // MARK: - Logout Button Setup
    
    private func setupLogoutButton() {
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }
    
    @objc private func saveButtonTapped() {
        guard let updatedUsername = usernameLabel.text,
              let updatedSurname = surnameLabel.text,
              let updatedBio = bioLabel.text else {
            return
        }
        
        guard let imageData = profileImageView.image?.jpegData(compressionQuality: 0.5) else {
            // Resmi veriye dönüştürme hatası
            return
        }
        
        let base64String = String(data: imageData, encoding: .ascii)
        
        guard let currentUserUID = Auth.auth().currentUser?.uid else {
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserUID)
        
        // Firestore veritabanına güncellenmiş bilgileri kaydedin
        userRef.updateData([
            "name": updatedUsername,
            "surname": updatedSurname,
            "bio": updatedBio,
            "userProfileImageURL": selectedImageURL
        ]) { [weak self] error in
            if let error = error {
                print("Kullanıcı bilgileri güncellenirken hata oluştu: \(error.localizedDescription)")
            } else {
                print("Kullanıcı bilgileri başarıyla güncellendi")
                // Eğer başarılı bir şekilde güncelleme yapılırsa, kullanıcı arayüzünü de güncelleyebilirsiniz.
                let updatedUser = User(name: updatedUsername,
                                       surname: updatedSurname,
                                       bio: updatedBio,
                                       userProfileImageURL: self!.selectedImageURL)
                self?.updateUI(with: updatedUser)
                NotificationCenter.default.post(name: Notification.Name("ProfileDataUpdated"), object: nil)
            }
        }
        
        self.dismiss(animated: true)
    }
    
    @objc func tapGestureImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ImageEditViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                // Veriyi bir URL'ye dönüştürmek için geçici bir dosya oluşturun
                let temporaryDirectoryURL = FileManager.default.temporaryDirectory
                let temporaryFileURL = temporaryDirectoryURL.appendingPathComponent("selectedImage.jpg")
                
                do {
                    try imageData.write(to: temporaryFileURL)
                    print("Fotoğrafın URL'si: \(temporaryFileURL.absoluteString)")
                    selectedImageURL = temporaryFileURL.absoluteString
                    
                } catch {
                    print("Hata: Fotoğraf verisi bir URL'ye dönüştürülemedi.")
                }
                
                // UIImageView'e seçilen fotoğrafı ayarlayın
                profileImageView.image = selectedImage
            }
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
