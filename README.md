## Micro

## Description

Most of the time, we want to apply model data to cell with smart diffing.
Micro provides type safe SwiftUI style data source for UICollectionView, with super fast diffing powered by [DeepDiff](https://github.com/onmyway133/DeepDiff).
Just declare a `State` with SwiftUI style `forEach` and Micro will reload with animated diffing

```swift
dataSource.state = forEach(models: blogs) { blog in
    Item<BlogCell>() { context, cell in
        cell.nameLabel.text = blog.name
    }
}
```

Features

- Declare in type safe manner with `forEach`
- `context` provides additional information, like `UICollectionView` and `IndexPath`
- Automatic reload with smart diffing whenever `state` is set
- By default, diffing is animated, you can use `dataSource.reload(newState:isAnimated:completion)` to specify animated and completion

## Advanced

### Complex model with multiple cell types

You can declare different `Item` in `forEach` with different kinds of cell.

```swift
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

dataSource.state = forEach(models: movies) { movie in
    switch movie.kind {
    case .show(let name):
        return Item<MovieCell>() { context, cell in
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
        return Item<LoadingCell>() { _, _ in }
    case .ad:
        return Item<AdCell>() { _, _ in }
    }
}
```

## Installation

**Micro** is also available through [Swift Package Manager](https://swift.org/package-manager/)

```swift
.package(url: "https://github.com/onmyway133/Micro", from: "1.0.0")
```

## Author

Khoa Pham, onmyway133@gmail.com

## License

**Micro** is available under the MIT license. See the [LICENSE](https://github.com/onmyway133/Micro/blob/master/LICENSE.md) file for more info.
