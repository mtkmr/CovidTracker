//
//  FilterViewController.swift
//  CovidTracker
//
//  Created by Masato Takamura on 2021/07/12.
//

import UIKit

protocol PrefectureFilterViewControllerDelegate: AnyObject {
    func fetchData(from prefecture: String)
}

///検索する県を指定する
final class PrefectureFilterViewController: UIViewController {
    
    //MARK: - Properties
    
    var delegate: PrefectureFilterViewControllerDelegate?
    
    private let prefectures = ["北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県", "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県", "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県", "岐阜県", "静岡県", "愛知県", "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県", "鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県", "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
    
    //MARK: - UI parts
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "prefecturesCell")
        
        return tableView
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "県を選択"
        view.backgroundColor = .systemBackground
        setupViewsLayout()
        setupNavigationController()
    }
}

//MARK: - UITableViewDelegate
extension PrefectureFilterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let prefectureName = prefectures[indexPath.row]
        delegate?.fetchData(from: prefectureName)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: - UITableViewDataSource
extension PrefectureFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prefectures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prefecture = prefectures[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "prefecturesCell", for: indexPath)
        cell.textLabel?.text = prefecture
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        return cell
    }
}

//MARK: - Private extension
private extension PrefectureFilterViewController {
    ///レイアウト
    private func setupViewsLayout() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ]
        )
    }
    
    ///NavigationControllerの設定
    private func setupNavigationController() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapCancelButton(_:)))
    }
    
    @objc
    private func didTapCancelButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}
