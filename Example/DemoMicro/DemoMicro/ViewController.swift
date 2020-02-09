//
//  ViewController.swift
//  DemoMicro
//
//  Created by khoa on 09/02/2020.
//  Copyright © 2020 Khoa Pham. All rights reserved.
//

import UIKit
import Micro

class ViewController: UIViewController {
    var collectionView: UICollectionView!
    var dataSource: DataSource!
    let layout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Micro"
        view.backgroundColor = UIColor(red: 197/255.0, green: 211/255.0, blue: 226/255.0, alpha: 1)

        layout.sectionInset = UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor)
        ])

        dataSource = DataSource(collectionView: collectionView)
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Letters",
            style: .plain,
            target: self,
            action: #selector(shuffleLetters)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Numbers",
            style: .plain,
            target: self,
            action: #selector(shuffleNumbers)
        )
    }

    @objc private func shuffleLetters() {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map({ String($0) }).shuffled()
        dataSource.state = forEach(letters) { letter in
            Cell<LetterCell>() { _, cell in
                cell.label.text = letter
            }
            .onSize { context in
                CGSize(
                    width: context.collectionView.frame.size.width / 3 - 20,
                    height: 60
                )
            }
            .onSelect { _ in
                print("select letter \(letter)")
            }
        }
    }

    @objc private func shuffleNumbers() {
        let numbers = Array(0..<100).shuffled()
        dataSource.state = forEach(numbers) { number in
            Cell<NumberCell>() { _, cell in
                cell.label.text = "\(number)"
            }
            .onSize { context in
                CGSize(
                    width: context.collectionView.frame.size.width / 4 - 20,
                    height: 60
                )
            }
            .onSelect { _ in
                print("select number \(number)")
            }
        }
    }
}

class NumberCell: UICollectionViewCell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        layer.cornerRadius = 6
        backgroundColor = UIColor(red: 0, green: 156/255.0, blue: 65/255.0, alpha: 1.0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class LetterCell: UICollectionViewCell {
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .title1)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        layer.cornerRadius = 6
        backgroundColor = UIColor(red: 230/255.0, green: 125/255.0, blue: 34/255.0, alpha: 1.0)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
