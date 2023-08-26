//
//  ConvertModel.swift
//  BM-Currency-Graduation
//
//  Created by Mohamed Salah on 26/08/2023.
//

import Foundation

import Foundation
import OptionallyDecodable

// MARK: - DecodeScene
struct ConvertModel: Codable {
    var result: Double
    var timeLastUpdateUTC: String

    enum CodingKeys: String, CodingKey {
        case result = "result"
        case timeLastUpdateUTC = "time_last_update_utc"
    }
}
