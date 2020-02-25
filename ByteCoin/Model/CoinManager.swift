//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel)

    func didFailWithError(_ error: Error)
    
}

struct CoinManager {

    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "<insert your key here>"
    
    let currencyArray = [
        "AUD",
        "BRL",
        "CAD",
        "CNY",
        "EUR",
        "GBP",
        "HKD",
        "IDR",
        "ILS",
        "INR",
        "JPY",
        "MXN",
        "NOK",
        "NZD",
        "PLN",
        "RON",
        "RUB",
        "SEK",
        "SGD",
        "USD",
        "ZAR"
    ]
    
    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apiKey=\(apiKey)"
        performRequest(with: urlString)
    }
    
    private func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, urlResponse, error) in
                if let error = error {
                    self.delegate?.didFailWithError(error)
                    return
                }
                if let data = data, let coinData = self.parseJson(data) {
                    let coinModel = self.parse(data: coinData)
                    self.delegate?.didUpdateCoin(self, coin: coinModel)
                }
            }
            task.resume()
        }
    }

    private func parseJson(_ coinData: Data) -> CoinData? {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(CoinData.self, from: coinData)
        } catch {
            delegate?.didFailWithError(error)
            return nil
        }
    }

    private func parse(data: CoinData) -> CoinModel {
        return CoinModel(
            currency: data.asset_id_quote,
            rate: data.rate
        )
    }
    
}
