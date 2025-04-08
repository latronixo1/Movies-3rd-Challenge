//
//  FavoritesViewController.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 01.04.2025.
//

import UIKit

class FavoritesViewController: UIViewController {

    // MARK: - UI
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 184
        return tableView
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleUpper(navItem: navigationItem, title: "Favorites")
        navigationBarAppearanceSettings()
        
        setViews()
        setDelegates()
        setupConstraints()
        
        updateLocalizedText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserverForLocalization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserverForLocalization()
    }
    
    
    // MARK: - Private Properties
    
    private let movie1 = Movie(id: 1, name: "Luck", description: "wow", rating: Rating(kp: 3.5), movieLength: 146, poster: nil, votes: Votes(kp: 4), genres: [Genre(name: "Драма"), Genre(name: "Документальный"), Genre(name: "Полнометражный")], year: 1999)
    
    private lazy var favorites: [Movie] = [movie1, movie1, movie1, movie1, movie1, movie1,]
    
    // MARK: - Set Views
    
    private func setViews() {
        view.backgroundColor = .systemBackground
        
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        view.addSubview(tableView)
    }
    
    // MARK: - Set Delegates
    
    private func setDelegates() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func navigationBarAppearanceSettings() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError() }
        
        let favoriteMovie = favorites[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: favoriteMovie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = favorites[indexPath.item]
        guard let id = selectedMovie.id else { return }
        
        NetworkService.shared.fetchMovieDetail(id: id) { [weak self] detail in
            guard let detail = detail else { return }
            DispatchQueue.main.async {
                let vc = TempMovieDetailViewController(movie: selectedMovie, detail: detail)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
// MARK: - Setup Constraints

extension FavoritesViewController {
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

extension FavoritesViewController {
    private func addObserverForLocalization() {
        NotificationCenter.default.addObserver(forName: LanguageManager.languageDidChangeNotification, object: nil, queue: .main) { [weak self] _ in
            self?.updateLocalizedText()
        }
    }
    
    private func removeObserverForLocalization() {
        NotificationCenter.default.removeObserver(self, name: LanguageManager.languageDidChangeNotification, object: nil)
    }
    
    @objc func updateLocalizedText() {
        setTitleUpper(navItem: navigationItem, title: "Favorites".localized())
    }
}
