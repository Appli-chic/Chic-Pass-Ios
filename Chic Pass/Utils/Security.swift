//
//  Security.swift
//  Chic Pass
//
//  Created by Applichic on 12/5/20.
//

import CryptoSwift

enum SecurityError: Error {
    case DecryptError
}

class Security {
    public static let signature = "~ChicPass/signature"
    private static let saltString = "Xx2VzeJRr7R5sloGZQoPcNdhC803e97o"
    private static let ivString = "RMZ#K<u'tjq26Y-i"
    
    private static let iv = Array(ivString.utf8)
    private static var aesKey: Array<UInt8>? = nil
    private static let salt: Array<UInt8> = Array(saltString.utf8)
    
    static func encryptData(key: String, data: String) throws -> String {
        let secret: Array<UInt8> = Array(key.utf8)
        let aes = try getAESInstance(secret: secret, reloadAes: false)

        /* Encrypt Data */
        let inputData = data.data(using: .utf8)
        let encryptedBytes = try aes.encrypt(inputData!.bytes)
        let encryptedData = Data(encryptedBytes)
        
        return encryptedData.base64EncodedString()
    }
    
    static func decryptData(key: String, data: String, reloadAes: Bool) throws -> String {
        let secret: Array<UInt8> = Array(key.utf8)
        let aes = try getAESInstance(secret: secret, reloadAes: reloadAes)
        
        let inputData = Data.init(base64Encoded: data)!
        let decryptedBytes = try aes.decrypt(inputData.bytes)
        let decryptedData = Data(decryptedBytes)
        
        let result = String(data: decryptedData, encoding: .utf8)
        
        if result != nil {
            return result!
        }
        
        throw SecurityError.DecryptError
    }
    
    private static func getAESInstance(secret: Array<UInt8>, reloadAes: Bool) throws -> AES {
        if aesKey == nil || reloadAes {
            aesKey = try PKCS5.PBKDF2(
                password: secret,
                salt: salt,
                iterations: 4096,
                keyLength: 32, /* AES-256 */
                variant: .sha256
            ).calculate()
        }

        return try AES(key: aesKey!, blockMode: CBC(iv: iv), padding: .pkcs7)
    }
}
