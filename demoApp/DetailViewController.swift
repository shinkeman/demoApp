import UIKit

class DetailViewController: UIViewController {
    private let fullName: String

    private lazy var titleLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.text = "The title of repository:"
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemGray
        label.accessibilityIdentifier = "staticLabel"

        return label
    }()

    private lazy var fullNameLabel: UILabel = {
        var label = UILabel(frame: .zero)
        label.text = fullName
        label.font = .boldSystemFont(ofSize: 27)
        label.accessibilityIdentifier = "nameLabel"
        
        return label
    }()

    init(fullName: String) {
        self.fullName = fullName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.largeTitleDisplayMode = .never

        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .center

        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(fullNameLabel)

        view.addSubview(stack)

        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
