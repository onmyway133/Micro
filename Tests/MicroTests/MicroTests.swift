import XCTest
import UIKit
import DeepDiff
@testable import Micro

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


struct Blog: DiffAware {
    let diffId = UUID()
    let name: String

    static func compareContent(_ a: Blog, _ b: Blog) -> Bool {
        return a.name == b.name
    }
}

class BlogCell: UICollectionViewCell {
    let nameLabel: UILabel = .init()
}

final class MicroTests: XCTestCase {
    var layout: UICollectionViewFlowLayout!
    var collectionView: UICollectionView!
    var dataSource: DataSource!

    func beforeEachTest() {
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        dataSource = DataSource(collectionView: collectionView)

        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
    }

    func testDrive() {
        beforeEachTest()

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

    func testFunctionBuilder() {
        beforeEachTest()

        let blogs: [Blog] = [
            Blog(name: "iOS"),
            Blog(name: "Android"),
        ]

        dataSource.state = State {
            ForEach(blogs) { blog in
                Cell<BlogCell>() { context, cell in
                    cell.nameLabel.text = blog.name
                }
            }
        }
    }

    func testSubclass() {
        class CustomDataSource: DataSource {
            override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let blog = state.models[indexPath.item] as? Blog
                print(blog)
            }
        }
    }

    static var allTests = [
        ("testDrive", testDrive),
    ]
}
