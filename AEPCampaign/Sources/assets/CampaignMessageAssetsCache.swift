///*
// Copyright 2021 Adobe. All rights reserved.
// This file is licensed to you under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License. You may obtain a copy
// of the License at http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software distributed under
// the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR REPRESENTATIONS
// OF ANY KIND, either express or implied. See the License for the specific language
// governing permissions and limitations under the License.
// */
//
import Foundation
import AEPServices

/// A Type that downloads and caches the Assets(images) associated with a Fullscreen IAM.
struct CampaignMessageAssetsCache {

    private let LOG_PREFIX = "CampaignMessageAssetsCache"
    let fileManager = FileManager.default

    func downloadAssetsForMessage(from urls: [String], messageId: String) {
        var assetsToRetain: [URL] = []
        for urlString in urls {
            guard let url = URL(string: urlString) else {
                continue
            }
            assetsToRetain.append(url)
        }
        let assetToRetainAlphaNumeric = assetsToRetain.map { url in
            url.absoluteString.alphanumeric
        }
        clearCachedAssetsForMessagesNotInList(filesToRetain: assetToRetainAlphaNumeric, pathRelativeToCacheDir: "\(CampaignConstants.Campaign.MESSAGE_CACHE_FOLDER)/\(messageId)")
        downloadAssets(urls: assetsToRetain, messageId: messageId)
    }

    private func downloadAssets(urls: [URL], messageId: String) {
        let networking = ServiceProvider.shared.networkService
        for url in urls {
            let networkRequest = NetworkRequest(url: url, httpMethod: .get)
            networking.connectAsync(networkRequest: networkRequest) { httpConnection in
                guard let data = httpConnection.data else {
                    return
                }
                cacheAssetData(data, forKey: url, messageId: messageId)
            }
        }
    }

    private func cacheAssetData(_ data: Data, forKey url: URL, messageId: String) {
        guard let path = createDirectoryIfNeeded(messageId: messageId) else {
            Log.debug(label: LOG_PREFIX, "Unable to cache Asset for URL: (\(url). Unable to create cache directory.")
            return
        }
        let cachedAssetPathString = "\(path)/\(url.absoluteString.alphanumeric)"
        guard let cachedAssetPath = URL(string: cachedAssetPathString) else {
            Log.debug(label: LOG_PREFIX, "Unable to cache Asset for URL: (\(url). Unable to create cache file Path.")
            return
        }

        do {
            try data.write(to: cachedAssetPath)
            Log.trace(label: LOG_PREFIX, "Successfully cached file from URL: (\(url)")
        } catch {
            Log.debug(label: LOG_PREFIX, "Unable to cache Asset for URL: (\(url). Unable to write data to file Path.")
        }
    }

    func clearCachedAssetsForMessagesNotInList(filesToRetain: [String], pathRelativeToCacheDir: String) {
        let fileManager = FileManager.default
        guard var cacheDir = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return
        }
        cacheDir.appendPathComponent(pathRelativeToCacheDir)
        guard let cachedFiles = try? fileManager.contentsOfDirectory(atPath: cacheDir.absoluteString) else {
            return
        }
        let assetsToDelete = cachedFiles.filter { cachedFile in
            !filesToRetain.contains(cachedFile)
        }

        // MARK: Delete non required cached files for message
        assetsToDelete.forEach { fileName in
            try? fileManager.removeItem(atPath: "\(cacheDir.absoluteString)/\(fileName)")
        }
    }

    /// Creates the directory to store the cache if it does not exist
    /// - Returns the Path to the Message Cache folder, Returns nil if cache folder does not exist and unable to create
    private func createDirectoryIfNeeded(messageId: String) -> String? {
        guard let pathUrl = try? fileManager.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true) else {
            return nil
        }
        let pathString = "\(pathUrl.absoluteString)/\(CampaignConstants.Campaign.MESSAGE_CACHE_FOLDER)/\(messageId)"
        guard !fileManager.fileExists(atPath: pathString) else {
            return pathString
        }

        Log.trace(label: LOG_PREFIX, "Attempting to create directory at path '\(pathString)'")
        do {
            try fileManager.createDirectory(atPath: pathString, withIntermediateDirectories: true,attributes: nil)
            return pathString
        } catch {
            return nil
        }
    }
}

private extension String {

    var alphanumeric: String {
        return components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}
