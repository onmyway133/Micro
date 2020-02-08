struct Micro {
    var text = "Hello, World!"
}

import UIKit
import DeepDiff

func testDrive() {
    struct Person: DiffAware {
        let diffId = UUID()
        let name: String

        static func compareContent(_ a: Person, _ b: Person) -> Bool {
            return a.name == b.name
        }
    }

    class PersonCell: UICollectionViewCell {
        let nameLabel: UILabel = .init()
    }

    let collectionView = UICollectionView()
    let dataSource = DataSource()
    collectionView.dataSource = dataSource
    collectionView.delegate = dataSource

    let persons: [Person] = [
        Person(name: "a"),
        Person(name: "b")
    ]

    dataSource.state = forEach(models: persons) { person in
        Item<PersonCell>() { cell in
            cell.nameLabel.text = person.name
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
    }
}
