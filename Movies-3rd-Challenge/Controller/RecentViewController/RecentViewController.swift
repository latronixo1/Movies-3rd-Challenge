import UIKit

class RecentViewController: MovieListController {
    
    private var selectedCategoryIndex: Int = 0
    
    private lazy var categoriesContainer:  UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        container.clipsToBounds = false
        container.isUserInteractionEnabled = true
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var categoryCollectionView: UICollectionView = {
        let catLayout = UICollectionViewFlowLayout()
        catLayout.scrollDirection = .horizontal
        catLayout.minimumLineSpacing = 12
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: catLayout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: "CategoryCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData()
        setTitleUpper(navItem: navigationItem, title: "Recent Watch")
        setupCategoryFilter()
        setupConstraints()
    }
    
    override func loadData(category: String = "Все") {
        //movies = TempDataManager.shared.getFavorites()
        movies = [movie1, movie1, movie1, movie1]
        tableView.reloadData()
        categoryCollectionView.reloadData()
    }
    
    private func setupCategoryFilter() {
        //        categoryFilterView.onCategorySelected = { [weak self] category in
        //            self?.filterMovies(by: category)
        //        }
        //        view.addSubview(categoryFilterView)
        //
        //        private func filterMovies(by category: String) {
        //            // Фильтрация списка
        //        }
        
        view.addSubview(categoriesContainer)
        categoriesContainer.addSubview(categoryCollectionView)
        view.bringSubviewToFront(categoriesContainer)
    }
    
    override func setupConstraints() {
        NSLayoutConstraint.activate([
            categoriesContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoriesContainer.heightAnchor.constraint(equalToConstant: 60),
            categoriesContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoriesContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            categoryCollectionView.topAnchor.constraint(equalTo: categoriesContainer.safeAreaLayoutGuide.topAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 40),
            categoryCollectionView.leadingAnchor.constraint(equalTo: categoriesContainer.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: categoriesContainer.trailingAnchor),
            
            tableView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension RecentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.configure(title: categories[indexPath.item])
        cell.isCellSelected = (indexPath.item == selectedCategoryIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.item
        collectionView.reloadData()
        
        let selectedCategory = categories[indexPath.item]
        loadData(category: selectedCategory)
    }
}



extension RecentViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let title = categories[indexPath.item]
        let width = (title as NSString).size(withAttributes: [.font: UIFont.systemFont(ofSize: 14)]).width + 32
        return CGSize(width: width, height: 32)
    }
}
