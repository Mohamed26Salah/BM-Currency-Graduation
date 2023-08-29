//
//  Bundle + unitTest.swift
//  BM-Currency-GraduationTests
//
//  Created by Mohamed Salah on 28/08/2023.
//

import Foundation
extension Bundle {
    public class var unitTest: Bundle {
        return Bundle(for: API_Manager_Test.self)
    }
}
