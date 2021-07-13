//
//  MainViewController.swift
//  CovidTracker
//
//  Created by Masato Takamura on 2021/07/12.
//

import UIKit
import Charts


final class MainViewController: UIViewController {
    //MARK: - Properties
    //県データを格納するプロパティ
    private var prefectures: [Prefecture] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.isHidden = false
                self.tableView.reloadData()
                self.createBarChart()
            }
        }
    }
    //県で検索するか日付で検索するかの状態
    private var scope: APICaller.DataScope = .prefecture("")
    
    //MARK: - UI parts
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        return tableView
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "日本"
        setupViewsLayout()
        setupDefaultNavigationController()
        createFilterButton()
        tableView.isHidden = true
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return prefectures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(prefectures[indexPath.row].date), \(prefectures[indexPath.row].name), \(prefectures[indexPath.row].npatients)人,"
        
        return cell
    }
}
//MARK: - PrefectureFilterViewControllerDelegate
extension MainViewController: PrefectureFilterViewControllerDelegate {
    func fetchData(from prefecture: String) {
        DispatchQueue.main.async {
            self.title = prefecture
        }
        scope = .prefecture(prefecture)
        APICaller.shared.getCovidData(for: scope) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let prefectures):
                self.prefectures = prefectures
            }
        }
    }
}

//MARK: - DateFilterViewControllerDelegate
extension MainViewController: DateFilterViewControllerDelegate {
    func fetchDataFromDate(date: String) {
        scope = .date(date)
        APICaller.shared.getCovidData(for: scope) { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let prefectures):
                self.prefectures = prefectures
                DispatchQueue.main.async {
                    self.title = date
                }
                
            }
        }
    }
}

//MARK: - Private extension
private extension MainViewController {
    
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
    private func setupDefaultNavigationController() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
    }
    
    ///NavigationBarButtonの設定
    private func createFilterButton() {
        //prefecture filter
        let prefectureFilterButtonTitle: String = "県"
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: prefectureFilterButtonTitle,
            style: .done,
            target: self,
            action: #selector(didTapPrefectureFilterButton(_:))
        )
        
        //date filter
        let dateFilterButtonTitle: String = "日付"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: dateFilterButtonTitle,
            style: .done,
            target: self,
            action: #selector(didTapDateFilterButton(_:))
        )
    }
    
    @objc
    private func didTapPrefectureFilterButton(_ sender: UIBarButtonItem) {
        Router.shared.showPrefectureFilter(from: self)
    }
    
    @objc
    private func didTapDateFilterButton(_ sender: UIBarButtonItem) {
        Router.shared.showDateFilter(from: self)
    }
    
    ///Bar Chartを作成する
    private func createBarChart() {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        headerView.clipsToBounds = true
        //setup data
        guard prefectures.count > 1 else { return }
        let recentData = prefectures.prefix(30)
        var entries: [BarChartDataEntry] = []
        for i in 0...recentData.count-1 {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(recentData[i].npatients)!))
        }
        var dataSet: BarChartDataSet
        switch scope {
        case .date(let dateString):
            dataSet = BarChartDataSet(entries: entries, label: "\(dateString) 各都道府県の感染者数")
        case .prefecture(let prefecture):
            dataSet = BarChartDataSet(entries: entries, label: "\(prefecture)の最近30日の感染者数")
        }
        dataSet.colors = ChartColorTemplates.joyful()
        let data = BarChartData(dataSet: dataSet)
        let chart = BarChartView(frame: headerView.frame)
        chart.data = data
        //setup xAxis
        let xAxis = chart.xAxis
        xAxis.enabled = false
        //setup leftAxis
        let leftAxis = chart.leftAxis
        leftAxis.labelPosition = .outsideChart
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.positiveSuffix = " 人"
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        //setup rightAxis
        let rightAxis = chart.rightAxis
        rightAxis.enabled = false
        //animation
        chart.animate(xAxisDuration: 3.0, easingOption: .linear)
        
        headerView.addSubview(chart)
        tableView.tableHeaderView = headerView
    }
}


