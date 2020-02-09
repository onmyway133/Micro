import XCTest
import UIKit
import DeepDiff
@testable import Micro

final class MicroTests: XCTestCase {
    func testDrive() {
        struct Movie: DiffAware {
            enum Kind: Equatable {
                case show(String)
                case loading
                case ad
            }

            let diffId = UUID()
            let kind: Kind

            static func compareContent(_ a: Movie, _ b: Movie) -> Bool {
                return a.kind == b.kind
            }
        }

        class MovieCell: UICollectionViewCell {
            let nameLabel: UILabel = .init()
        }

        class LoadingCell: UICollectionViewCell {}

        class AdCell: UICollectionViewCell {}

        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let dataSource = DataSource(collectionView: collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource

        let movies: [Movie] = [
            Movie(kind: .show("Titanic")),
            Movie(kind: .show("Batman")),
            Movie(kind: .loading),
            Movie(kind: .ad)
        ]

        dataSource.state = forEach(movies) { movie in
            switch movie.kind {
            case .show(let name):
                return Cell<MovieCell>() { context, cell in
                    cell.nameLabel.text = name
                }
                .onSelect { _ in

                }
                .onDeselect { _ in

                }
                .onWillDisplay { _, _ in

                }
                .onDidEndDisplay { _, _ in

                }
                .onSize { context in
                    CGSize(width: context.collectionView.frame.size.width, height: 40)
                }
            case .loading:
                return Cell<LoadingCell>() { _, _ in }
            case .ad:
                return Cell<AdCell>() { _, _ in }
            }
        }
    }

    static var allTests = [
        ("testDrive", testDrive),
    ]
}
