//
//  FetchableImage.swift
//  FetchableImageDemo
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2020 AppCoda. All rights reserved.
//

import Foundation

protocol FetchableImage {
    func localFileURL(for imageURL: String?, isTrailPattern: Bool, patternId: String, options: FetchableImageOptions?) -> URL?
    func fetchImage(from urlString: String?, isTrail: Bool, patternName: String, options: FetchableImageOptions?, completion: @escaping (_ imageData: Data?) -> Void)
    func fetchBatchImages(using urlStrings: [String?], isTrail: Bool, patternName: String, options: FetchableImageOptions?, partialFetchHandler: @escaping (_ imageData: Data?, _ index: Int) -> Void, completion: @escaping () -> Void)
    func deleteImage(using imageURL: String?, options: FetchableImageOptions?) -> Bool
    func deleteBatchImages(using imageURLs: [String?], options: FetchableImageOptions?)
    func deleteBatchImages(using multipleOptions: [FetchableImageOptions])
    func save(image data: Data, options: FetchableImageOptions) -> Bool
}

extension FetchableImage {
    // rescale methods
    func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .libraryDirectory,
                                                 in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        return documentURL.appendingPathComponent(key + ".png")
    }
    func localFileURL(for imageURL: String?, isTrailPattern: Bool, patternId: String, options: FetchableImageOptions? = nil) -> URL? {
        let opt = FetchableImageHelper.getOptions(options)
        let targetDir = opt.storeInCachesDirectory ? FetchableImageHelper.cachesDirectoryURL : FetchableImageHelper.documentsDirectoryURL
        guard let urlString = imageURL else {
            guard let customFileName = opt.customFileName else { return nil }
            return targetDir.appendingPathComponent(customFileName)
        }
        guard let imageName = FetchableImageHelper.getImageName(from: urlString) else { return nil }
        let documentsURL = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        // set the name of the new folder
        var folderURL = documentsURL.appendingPathComponent(FormatsString.emptyString)
        if isTrailPattern {
            folderURL = documentsURL.appendingPathComponent("Trails").appendingPathComponent("\(patternId)")
        } else {
            folderURL = documentsURL.appendingPathComponent("Patterns").appendingPathComponent("\(patternId)")
        }
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
        } catch _ as NSError {
        }
        return folderURL.appendingPathComponent(imageName)
    }
    func fetchImage(from urlString: String?, isTrail: Bool, patternName: String, options: FetchableImageOptions? = nil, completion: @escaping (_ imageData: Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let opt = FetchableImageHelper.getOptions(options)
            let localURL = self.localFileURL(for: urlString, isTrailPattern: isTrail, patternId: patternName, options: options)
            if opt.allowLocalStorage,
               let localURL = localURL,
               FileManager.default.fileExists(atPath: localURL.path) {
                let loadedImageData = FetchableImageHelper.loadLocalImage(from: localURL)
                completion(loadedImageData)
            } else {
                guard let urlString = urlString, let url = URL(string: urlString) else {
                    completion(nil)
                    return
                }
                FetchableImageHelper.downloadImage(from: url) { (imageData) in
                    if opt.allowLocalStorage, let localURL = localURL {
                        try? imageData?.write(to: localURL)
                    }
                    completion(imageData)
                }
            }
        }
    }
    func fetchBatchImages(using urlStrings: [String?], isTrail: Bool, patternName: String, options: FetchableImageOptions?, partialFetchHandler: @escaping (_ imageData: Data?, _ index: Int) -> Void, completion: @escaping () -> Void) {
        performBatchImageFetching(using: urlStrings, isTrailPattern: isTrail, patternID: patternName, currentImageIndex: 0, options: options, partialFetchHandler: {(imageData, index) in
            partialFetchHandler(imageData, index)}) {
            completion()
        }
    }
    private func performBatchImageFetching(using urlStrings: [String?], isTrailPattern: Bool, patternID: String, currentImageIndex: Int, options: FetchableImageOptions?, partialFetchHandler: @escaping (_ imageData: Data?, _ index: Int) -> Void, completion: @escaping () -> Void) {
        guard currentImageIndex < urlStrings.count else {
            completion()
            return
        }
        fetchImage(from: urlStrings[currentImageIndex], isTrail: isTrailPattern, patternName: patternID, options: options) { (imageData) in
            partialFetchHandler(imageData, currentImageIndex)
            self.performBatchImageFetching(using: urlStrings, isTrailPattern: isTrailPattern, patternID: patternID, currentImageIndex: currentImageIndex + 1, options: options, partialFetchHandler: partialFetchHandler) {
                completion()
            }
        }
    }
    func deleteImage(using imageURL: String?, options: FetchableImageOptions? = nil) -> Bool {
        guard let localURL = localFileURL(for: imageURL, isTrailPattern: false, patternId: FormatsString.oneLabel, options: options),
              FileManager.default.fileExists(atPath: localURL.path) else { return false }
        do {
            try FileManager.default.removeItem(at: localURL)
            return true
        } catch {
            return false
        }
    }
    func deleteBatchImages(using imageURLs: [String?], options: FetchableImageOptions? = nil) {
        DispatchQueue.global().async {
            imageURLs.forEach { _ = self.deleteImage(using: $0, options: options) }
        }
    }
    func deleteBatchImages(using multipleOptions: [FetchableImageOptions]) {
        DispatchQueue.global().async {
            multipleOptions.forEach { _ = self.deleteImage(using: nil, options: $0) }
        }
    }
    func save(image data: Data, options: FetchableImageOptions) -> Bool {
        guard let url = localFileURL(for: nil, isTrailPattern: false, patternId: FormatsString.oneLabel, options: options) else { return false }
        do {
            try data.write(to: url)
            return true
        } catch {
            return false
        }
    }
}

struct FetchableImageOptions {
    var storeInCachesDirectory: Bool = true
    var allowLocalStorage: Bool = true
    var customFileName: String?
}

fileprivate struct FetchableImageHelper {
    static var documentsDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
    static var cachesDirectoryURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    static func getOptions(_ options: FetchableImageOptions?) -> FetchableImageOptions {
        return options != nil ? options! : FetchableImageOptions()
    }
    static func getImageName(from urlString: String) -> String? {
        if let url = URL(string: urlString) {
            let withoutExt = url.deletingPathExtension()
            let name = withoutExt.lastPathComponent
            if name.hasSuffix("@3x") {
                return "\(name).png"
            } else {
                return "\(name)@3x.png"
            }
        }
        return FormatsString.emptyString
    }
    static func downloadImage(from url: URL, completion: @escaping (_ imageData: Data?) -> Void) {
        let sessionConfiguration = URLSessionConfiguration.ephemeral
        let session = URLSession(configuration: sessionConfiguration)
        let task = session.dataTask(with: url) { (data, _, _) in
            completion(data)
        }
        task.resume()
    }
    static func loadLocalImage(from url: URL) -> Data? {
        do {
            let imageData = try Data(contentsOf: url)
            return imageData
        } catch {
            return nil
        }
    }
}
