//
//  ApiServer.swift
//  Companies
//
//  Created by Gustavo Halperin on 5/20/24.
//

import Foundation




actor ApiServer {
    private var urlRequest: URLRequest {
        get throws {
            let urlStr = "https://us-central1-fbconfig-90755.cloudfunctions.net/getAllCompanies"
            guard let url = URL(string: urlStr) else {
                let error = NSError(domain: "",
                                    code: 10000,
                                    userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
                throw error
            }
            return URLRequest(url: url)
        }
        
    }
    func refresh() async throws -> [URLRequest.Company] {
        let urlRequest = try urlRequest
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let urlResponse = response as? HTTPURLResponse else {
            let error = NSError(domain: "",
                                code: 10001,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid URLResponse format"])
            throw error
        }
        guard urlResponse.statusCode == 200 else {
            let error = NSError(domain: "",
                                code: 10002,
                                userInfo: [NSLocalizedDescriptionKey: "Invalid status code: \(urlResponse.statusCode)"])
            throw error
        }
        let companyList =  try JSONDecoder()
            .decode([URLRequest.Company?].self, from: data)
            .compactMap { $0 }
        return companyList
    }
}
