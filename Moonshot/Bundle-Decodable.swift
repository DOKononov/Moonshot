//
//  Bundle-Decodable.swift
//  Moonshot
//
//  Created by Dmitry Kononov on 2.09.25.
//

import Foundation

extension Bundle {
    func decode<T: Codable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) for bundle")
        }
        
        let decoder = JSONDecoder()
        let formater = DateFormatter()
        formater.dateFormat = "y-MM-dd"
        decoder.dateDecodingStrategy = .formatted(formater)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch DecodingError.keyNotFound(let key, let content) {
            fatalError("Failed to decode \(file) from bundle due missing key \(key.stringValue) - \(content.debugDescription)")
        } catch DecodingError.typeMismatch(_ , let context) {
            fatalError("Failed to decode \(file) from bundle due type missmatch - \(context.debugDescription)")
        } catch DecodingError.valueNotFound(let type, let context) {
            fatalError("Failed to decode \(file) from bundle due value not found \(type) - \(context.debugDescription)")
        } catch DecodingError.dataCorrupted(let context) {
            fatalError("Failed to decode \(file) due data is corrupted - \(context.debugDescription)")
        } catch {
            fatalError("Failed to decode \(file) from bundle - \(error.localizedDescription)")
        }
    }
}
