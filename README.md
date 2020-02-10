## Micro

<div align="center">
<img src="Screenshots/demo.gif" height=400>
</div>

For demo, check [DemoMicro](https://github.com/onmyway133/Micro/tree/master/Example/DemoMicro)

Read more

- [How to build SwiftUI style UICollectionView data source in Swift](https://onmyway133.github.io/blog/How-to-build-SwiftUI-style-UICollectionView-data-source-in-Swift/)
- [A better way to update UICollectionView data in Swift with diff framework](https://medium.com/flawless-app-stories/a-better-way-to-update-uicollectionview-data-in-swift-with-diff-framework-924db158db86)

## Description

Most of the time, we want to apply model data to cell with smart diffing.
Micro provides type safe SwiftUI style data source for UICollectionView, with super fast diffing powered by [DeepDiff](https://github.com/onmyway133/DeepDiff).
Just declare a `State` with SwiftUI style `forEach` and Micro will reload with animated diffing

```swift
let dataSource = DataSource(collectionView: collectionView)
dataSource.state = State {
    ForEach(blogs) { blog in
        Cell<BlogCell>() { context, cell in
            cell.nameLabel.text = blog.name
        }
        .onSelect { context in 
            print("cell at index \(context.indexPath.item) is selected")
        }
        .onSize { context in 
            CGSize(
                width: context.collectionView.frame.size.width, 
                height: 40
            )
        }
    }
}
```

The above uses Swift 5.1 function builder syntax, which uses `forEach` method under the hood. You can also do like below with `forEach` method. 

```swift
dataSource.state = forEach(blogs) { blog in
    Cell<BlogCell>() { context, cell in
        cell.nameLabel.text = blog.name
    }
    .onSelect { context in 
        print("cell at index \(context.indexPath.item) is selected")
    }
    .onSize { context in 
        CGSize(
            width: context.collectionView.frame.size.width, 
            height: 40
        )
    }
}
```

Features

- Supports iOS 8+
- Declare in type safe manner with `forEach`
- `context` provides additional information, like `UICollectionView` and `IndexPath`
- Automatic reload with smart diffing whenever `state` is set
- By default, diffing is animated, you can use `dataSource.reload(newState:isAnimated:completion)` to specify animated and completion

## Advanced

### Animate reloading

By default, when you set `state` on `DataSource`, animated diffing is performed. If you want to set animated property and to listen to completion event, you can use `reload` method

```swift
dataSource.reload(
    newState: newState,
    isAnimated: false,
    completion: { finished in
        print("reloade is finished")
    }
)
```

### Complex model with multiple cell types

You can declare different `Cell` in `forEach` with different kinds of cell.

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
        return Cell<LoadingCell>()
    case .ad:
        return Cell<AdCell>()
    }
}
```

## Installation

**Micro** is also available through [Swift Package Manager](https://swift.org/package-manager/)

```swift
.package(url: "https://github.com/onmyway133/Micro", from: "1.2.0")
```

## Author

Khoa Pham, onmyway133@gmail.com

## License

**Micro** is available under the MIT license. See the [LICENSE](https://github.com/onmyway133/Micro/blob/master/LICENSE.md) file for more info.
