//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    
    private var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        currencyPicker.dataSource = self
        currencyPicker.delegate = self
        
        let gbpIndex = coinManager.currencyArray.firstIndex(of: "GBP")!
        currencyPicker.selectRow(gbpIndex, inComponent: 0, animated: true)
        pickerView(currencyPicker, didSelectRow: gbpIndex, inComponent: 0)
    }
    
}

// MARK: - CoinManagerDelegate
extension ViewController: CoinManagerDelegate {
    
    func didUpdateCoin(_ coinManager: CoinManager, coin: CoinModel) {
        DispatchQueue.main.async {
            self.currencyLabel.text = coin.currency
            self.priceLabel.text = String(format: "%.2f", coin.rate)
        }
    }

    func didFailWithError(_ error: Error) {
         print("CoinManager fail with \(error)")
    }
    
}

// MARK: - UIPickerViewDelegate
extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let currency = coinManager.currencyArray[row]
        
        coinManager.getCoinPrice(for: currency)
        currencyLabel.text = currency
        priceLabel.text = "..."
    }
    
}

// MARK: - UIPickerViewDataSource
extension ViewController: UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
}


