//
//  BaseMovieListController.swift
//  Movies-3rd-Challenge
//
//  Created by Elina Kanzafarova on 07.04.2025.
//

import UIKit

class BaseMovieListController: UIViewController {

    // MARK: - UI
       let tableView: UITableView = {
           let tableView = UITableView()
           tableView.rowHeight = 184
           tableView.separatorStyle = .none
           tableView.showsVerticalScrollIndicator = false
           tableView.translatesAutoresizingMaskIntoConstraints = false
           return tableView
       }()
       
       // MARK: - Properties
       var movies: [Movie] = [] {
           didSet {
               tableView.reloadData()
           }
       }
    
    // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            loadData()
            
            setViews()
            setDelegates()
            setupNavigationBar()
        }
    
    // MARK: - Methods to override
        func loadData() {
            fatalError("Must be overridden")
        }
    
    func handlerMovieSelection(_ selectedMovie: Movie) {
        guard let id = selectedMovie.id else { return }
        
        NetworkService.shared.fetchMovieDetail(id: id) { [weak self] detail in
            guard let detail = detail else { return }
            DispatchQueue.main.async {
                let vc = TempMovieDetailViewController(movie: selectedMovie, detail: detail)
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    // MARK: - Private Properties
    
    let movie1 = Movie(id: 1, name: "Luck", description: "wow", rating: Rating(kp: 3.5), movieLength: 146, poster: nil, votes: Votes(kp: 4), genres: [Genre(name: "Драма"), Genre(name: "Документальный"), Genre(name: "Полнометражный")], year: 1999)
    
    
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
    
    func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.label]
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.backgroundColor = .clear
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func setupConstraints() {
        fatalError("Must be overridden and added in viewWillAppear")
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate

extension BaseMovieListController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError() }
        
        let movie = movies[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(with: movie)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMovie = movies[indexPath.item]
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
