import UIKit

class ViewController: UIViewController {

    //MARK: - Properties

    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var hackPasswordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var isBlack: Bool = false {
        didSet {
            if isBlack {
                self.view.backgroundColor = .black
            } else {
                self.view.backgroundColor = .white
            }
        }
    }

    var password = ""
    var isHackingStart = false
    var isPasswordAccept = false

    //MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTF.placeholder = "Enter your password"
        statusLabel.text = ""
        activityIndicator.isHidden = true
        passwordTF.isSecureTextEntry = true
    }


    //MARK: - Actions

    @IBAction func hackPasswordButton(_ sender: Any) {
        isHackingStart = true
        password = passwordTF.hasText ? (passwordTF.text ?? "") : self.randomPassword()
        DispatchQueue.main.async {
            self.passwordTF.text = self.password
            self.activityIndicator.startAnimating()
            self.hackPasswordButton.isEnabled = false
            self.activityIndicator.isHidden = false
        }
        DispatchQueue.global().async {
            self.bruteForce(passwordToUnlock: self.password)
        }
    }

    @IBAction func stopHack(_ sender: Any) {
        isHackingStart = false
        DispatchQueue.main.async {
            self.statusLabel.text = "Your password \(self.password) is safe"
            self.activityIndicator.isHidden = true
            self.hackPasswordButton.isEnabled = true
            self.activityIndicator.stopAnimating()
            self.passwordTF.text = ""
        }
    }

    @IBAction func onBut(_ sender: Any) {
        isBlack.toggle()
    }

    //MARK: - Methods

    func randomPassword() -> String {
        password.removeAll()
        let randomArray = String().printable
        let length = 3
        for _ in 0 ..< length {
            password.append(randomArray.randomElement()!)
        }
        return password
    }

    func bruteForce(passwordToUnlock: String) {
        let ALLOWED_CHARACTERS:   [String] = String().printable.map { String($0) }
        var password: String = ""


        while password != passwordToUnlock && isHackingStart {
            password = generateBruteForce(password, fromArray: ALLOWED_CHARACTERS)

            DispatchQueue.main.async {
                self.statusLabel.text = "Your password is \(password)"
                self.activityIndicator.startAnimating()
            }
            print(password)
        }
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
        print(password)
    }


    func indexOf(character: Character, _ array: [String]) -> Int {
        return array.firstIndex(of: String(character))!
    }

    func characterAt(index: Int, _ array: [String]) -> Character {
        return index < array.count ? Character(array[index])
        : Character("")
    }

    func generateBruteForce(_ string: String, fromArray array: [String]) -> String {
        var str: String = string

        if str.count <= 0 {
            str.append(characterAt(index: 0, array))
        }
        else {
            str.replace(at: str.count - 1,
                        with: characterAt(index: (indexOf(character: str.last!, array) + 1) % array.count, array))

            if indexOf(character: str.last!, array) == 0 {
                str = String(generateBruteForce(String(str.dropLast()), fromArray: array)) + String(str.last!)
            }
        }

        return str
    }
}

