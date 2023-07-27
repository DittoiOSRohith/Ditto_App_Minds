//
//  BMToken.swift
//  Ditto
//
//  Created by Gokul Ramesh on 20/09/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation
import CommonCrypto

enum CryptoAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    var HMACAlgorithm: CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    var digestLength: Int {
        var result: Int32 = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
enum HMACAlgorithm {
    case MD5, SHA1, SHA224, SHA256, SHA384, SHA512
    func toCCHmacAlgorithm() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .MD5:
            result = kCCHmacAlgMD5
        case .SHA1:
            result = kCCHmacAlgSHA1
        case .SHA224:
            result = kCCHmacAlgSHA224
        case .SHA256:
            result = kCCHmacAlgSHA256
        case .SHA384:
            result = kCCHmacAlgSHA384
        case .SHA512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .MD5:
            result = CC_MD5_DIGEST_LENGTH
        case .SHA1:
            result = CC_SHA1_DIGEST_LENGTH
        case .SHA224:
            result = CC_SHA224_DIGEST_LENGTH
        case .SHA256:
            result = CC_SHA256_DIGEST_LENGTH
        case .SHA384:
            result = CC_SHA384_DIGEST_LENGTH
        case .SHA512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}
extension String {
    func hmac(algorithm: CryptoAlgorithm, key: String) -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = Int(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = algorithm.digestLength
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = Int(key.lengthOfBytes(using: String.Encoding.utf8))
        CCHmac(algorithm.HMACAlgorithm, keyStr!, keyLen, str!, strLen, result)
        let digest = stringFromResult(result: result, length: digestLen)
        result.deallocate()
        return digest
    }
    private func stringFromResult(result: UnsafeMutablePointer<CUnsignedChar>, length: Int) -> String {
        let hash = NSMutableString()
        for len in 0..<length {
            hash.appendFormat("%02x", result[len])
        }
        return String(hash)
    }
    func sha256(data: Data) -> Data {
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        data.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
        }
        return Data(hash)
    }
    func hashSHA256() -> String {
        if let data = self.data(using: String.Encoding.utf8) {
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            data.withUnsafeBytes {
                _ = CC_SHA256($0.baseAddress, CC_LONG(data.count), &hash)
            }
            return hexStringFromData(input: Data(hash) as NSData)
        }
        return FormatsString.emptyString
    }
    func percentEncode() -> String {
        // There are contradicting specifications on whether the plus sign should be percent-encoded.
        // If we want to percent-encode it, we have to remove it from the .urlHostAllowed set.
        // See the note on https://developer.apple.com/documentation/foundation/nsurlcomponents/1407752-queryitems
        var charset = CharacterSet.urlHostAllowed
        charset.remove(charactersIn: "+@")
        return self.safeAddingPercentEncoding(withAllowedCharacters: charset) ?? self
    }
    func safeAddingPercentEncoding(withAllowedCharacters allowedCharacters: CharacterSet) -> String? {
        // using a copy to workaround magic: https://stackoverflow.com/q/44754996/1033581
        let allowedCharacters = CharacterSet(bitmapRepresentation: allowedCharacters.bitmapRepresentation)
        return addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }
    func toggleBase64URLSafe(onVal: Bool) -> String {
        if onVal {
            // Make base64 string safe for passing into URL query params
            let base64url = self.replacingOccurrences(of: "/", with: "_").replacingOccurrences(of: "+", with: "-").replacingOccurrences(of: "=", with: FormatsString.emptyString)
            return base64url
        } else {
            // Return to base64 encoding
            var base64 = self.replacingOccurrences(of: "_", with: "/").replacingOccurrences(of: "-", with: "+")
            // Add any necessary padding with `=`
            if base64.count % 4 != 0 {
                base64.append(String(repeating: "=", count: 4 - base64.count % 4))
            }
            return base64
        }
    }
    func hmacb64(algorithm: HMACAlgorithm, key: String) -> String {
        let cKey = key.cString(using: String.Encoding.utf8)
        let cData = self.cString(using: String.Encoding.utf8)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: algorithm.digestLength())
        CCHmac(algorithm.toCCHmacAlgorithm(), cKey!, strlen(cKey!), cData!, strlen(cData!), result)
        let hmacData: NSData = NSData(bytes: result, length: (Int(algorithm.digestLength())))
        let hmacBase64 = hmacData.base64EncodedString()
        return String(hmacBase64)
    }
    func sha256() -> String {
        if let stringData = self.data(using: String.Encoding.utf8) {
            return hexStringFromData(input: digest(input: stringData as NSData))
        }
        return FormatsString.emptyString
    }
    private func digest(input: NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hash = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hash)
        return NSData(bytes: hash, length: digestLength)
    }
    private  func hexStringFromData(input: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: input.length)
        input.getBytes(&bytes, length: input.length)
        var hexString = FormatsString.emptyString
        for byte in bytes {
            hexString += String(format: "%02x", UInt8(byte))
        }
        return hexString
    }
}

public struct OCAuthToken: Codable {
    public let accessToken: String
    public let expiresIn: Int
    public let tokenType: String
    public let skVal: Int
    init(accessToken: String, expiresIn: Int, tokenType: String, skVal: Int) {
        self.accessToken = accessToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.skVal = skVal
    }
}
public struct OCError: Codable {
    public let error: String
    public let errorDescription: String
}
public struct SoftwareVersionModel: Codable {
    public let version: String
    public let criticalVersion: String
    public let forceVersion: String
    public let body: String
    public let confirmLink: String
    public let confirm: String
    public let cancel: String
    public let versionUpdate: Bool
    public let criticalUpdate: Bool
    public let forceUpdate: Bool
    init(version: String, criticalVersion: String, forceVersion: String, body: String, confirm: String, confirmLink: String, cancel: String, versionUpdate: Bool, criticalUpdate: Bool, forceUpdate: Bool) {
        self.version = version
        self.criticalVersion = criticalVersion
        self.forceVersion = forceVersion
        self.body = body
        self.confirm = confirm
        self.confirmLink = confirmLink
        self.cancel = cancel
        self.versionUpdate = versionUpdate
        self.criticalUpdate = criticalUpdate
        self.forceUpdate = forceUpdate
    }
}
