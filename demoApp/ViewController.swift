import UIKit

class ViewController: UIViewController {
    let tableView: UITableView
    let searchBar: UISearchBar

    var repositories: [RepositoryModel] = [
        .init(id: 1, fullName: "First test demo repo", language: "Eng", stargazersCount: 1),
        .init(id: 2, fullName: "Second test demo repo", language: "Eng", stargazersCount: 2),
        .init(id: 3, fullName: "Third test demo repo", language: "Eng", stargazersCount: 3)
    ]

    init() {
        self.tableView = UITableView(frame: .zero, style: .grouped)
        self.searchBar = UISearchBar(frame: .zero)

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        navigationItem.title = "Repositories"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.accessibilityIdentifier = "navBar"
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.accessibilityIdentifier = "tableView"

        searchBar.searchBarStyle = UISearchBar.Style.default
        searchBar.placeholder = "Search a repo..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false

        navigationItem.titleView = searchBar
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityIdentifier = "searchBar"
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        Task {
            print("Start fetching...")
            do {
                repositories = try await GitHubService.fetchRepositories(query:"test")
            } catch (let error) {
                print(error)
                repositories = []
            }

            DispatchQueue.main.async {[weak self] in
                guard let self = self else {return}
                self.tableView.reloadData()
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell")! as UITableViewCell
        cell.textLabel?.text = repositories[indexPath.row].fullName
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailViewController = DetailViewController(fullName: repositories[indexPath.row].fullName ?? "NO DATA")
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

class TableViewCell: UITableViewCell {}
