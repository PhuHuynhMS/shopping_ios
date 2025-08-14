import UIKit

class ShoppingViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<SectionType, AnyHashable>!
    private var sections: [SectionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupDataSource()
        loadSampleData()
        applySnapshot()
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        // Đăng ký các cell
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identifier)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.identifier)
        collectionView.register(PromotionCell.self, forCellWithReuseIdentifier: PromotionCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) -> NSCollectionLayoutSection? in
            let sectionType = SectionType.allCases[sectionIndex]
            
            switch sectionType {
            case .banner:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(200))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
                
            case .category:
                let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(80), heightDimension: .absolute(100))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
                
            case .product:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(250))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
                
            case .promotion:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(150))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
                return section
            }
        }
        return layout
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<SectionType, AnyHashable>(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            let sectionType = SectionType.allCases[indexPath.section]
            
            switch sectionType {
            case .banner:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as! BannerCell
                if let banner = item as? Banner {
                    cell.configure(with: banner)
                }
                return cell
                
            case .category:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.identifier, for: indexPath) as! CategoryCell
                if let category = item as? Category {
                    cell.configure(with: category)
                }
                return cell
                
            case .product:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.identifier, for: indexPath) as! ProductCell
                if let product = item as? Product {
                    cell.configure(with: product)
                }
                return cell
                
            case .promotion:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCell.identifier, for: indexPath) as! PromotionCell
                if let promotion = item as? Promotion {
                    cell.configure(with: promotion)
                }
                return cell
            }
        }
    }
    
    private func loadSampleData() {
        sections = [
            SectionData(type: .banner, items: [
                Banner(imageUrl: "banner1"),
                Banner(imageUrl: "banner2"),
                Banner(imageUrl: "banner3")
            ]),
            SectionData(type: .category, items: [
                Category(name: "Electronics", iconUrl: "electronics"),
                Category(name: "Fashion", iconUrl: "fashion"),
                Category(name: "Home", iconUrl: "home")
            ]),
            SectionData(type: .product, items: [
                Product(id: "1", name: "Smartphone", price: 699.99, imageUrl: "smartphone"),
                Product(id: "2", name: "Laptop", price: 1299.99, imageUrl: "laptop"),
                Product(id: "3", name: "Headphones", price: 99.99, imageUrl: "headphones")
            ]),
            SectionData(type: .promotion, items: [
                Promotion(title: "Black Friday", description: "Up to 50% off!", imageUrl: "promo1"),
                Promotion(title: "Free Shipping", description: "On orders over $50", imageUrl: "promo2")
            ])
        ]
    }
    
    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<SectionType, AnyHashable>()
        snapshot.appendSections(SectionType.allCases)
        
        for section in sections {
            snapshot.appendItems(section.items, toSection: section.type)
        }
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
