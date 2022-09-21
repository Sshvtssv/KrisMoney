//
//  APICaller.swift
//  KrisMoney
//
//  Created by Kristina on 03/09/2022.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    private struct Constansts {
        static let apiKey = "85FBA93B-0C51-4F0C-8C50-3C87D717334D"
        static let assetsEndpoint = "https://rest-sandbox.coinapi.io/v1/assets/"
        
    }
    private init() {}
    
    
    public func getAllCryptoData(
        completion: @escaping (Result<[Crypto], Error>) -> Void
    ) {
        guard let url = URL(string: Constansts.assetsEndpoint + "?apikey=" + Constansts.apiKey)
     else {
        return
    }
    let task = URLSession.shared.dataTask(with: url) {
        data, _, error in
        guard let data = data, error == nil
        else {
            return
        }
        do {
            let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
            
            completion(.success(cryptos.sorted { first, second -> Bool in
                return first.price_usd ?? 0 > second.price_usd ?? 0
            }))
        }
        catch {
            completion(.failure(error))
        }
        
    }
        task.resume()
}
}
