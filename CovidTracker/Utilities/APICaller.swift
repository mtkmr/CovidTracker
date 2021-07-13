//
//  APICaller.swift
//  CovidTracker
//
//  Created by Masato Takamura on 2021/07/12.
//

import Foundation

///APIからデータを取得するシングルトン
final class APICaller {
    static let shared = APICaller()
    private init() {}
    
    ///検索条件
    enum DataScope {
        case date(String)
        case prefecture(String)
    }
    
    ///データを取得する
    func getCovidData(for scope: DataScope,
                      completion: @escaping (Result<[Prefecture], Error>) -> Void) {
        var urlString: String
        switch scope {
        case .date(let dateString):
            urlString = "https://opendata.corona.go.jp/api/Covid19JapanAll?date=\(dateString)"
        case .prefecture(let prefectureString):
            guard let prefectureEncoded = prefectureString.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) else { return }
            urlString = "https://opendata.corona.go.jp/api/Covid19JapanAll?dataName=\(prefectureEncoded)"
        }
        
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard
                let data = data, error == nil
            else {
                return
            }
            do {
                let result = try JSONDecoder().decode(PrefectureListResponse.self, from: data)
                let prefectures = result.itemList
                completion(.success(prefectures))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

