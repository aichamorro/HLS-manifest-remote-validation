//
//  File.swift
//  Pods
//
//  Created by Alberto Isaac Chamorro Blanco on 25/07/2018.
//

import Foundation

public struct DebugFunctions {
    public static func upload(manifest: String, to endpoint: String = "http://192.168.1.35:3000/manifest") {
        let url = URL(string: endpoint)!
        let request = try! createRequest(manifest: manifest, url: url)
        
        var response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
        try! NSURLConnection.sendSynchronousRequest(request, returning: response)
    }
}

/// Create request
///
/// - parameter userid:   The userid to be passed to web service
/// - parameter password: The password to be passed to web service
/// - parameter email:    The email address to be passed to web service
///
/// - returns:            The `URLRequest` that was created

func createRequest(manifest: String, url: URL) throws -> URLRequest {
    let boundary = generateBoundaryString()
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    request.httpBody = try createBody(with: nil, filePathKey: "manifest", manifeestData: manifest.data(using: .utf8)!, boundary: boundary)
    
    return request
}

/// Create body of the `multipart/form-data` request
///
/// - parameter parameters:   The optional dictionary containing keys and values to be passed to web service
/// - parameter filePathKey:  The optional field name to be used when uploading files. If you supply paths, you must supply filePathKey, too.
/// - parameter paths:        The optional array of file paths of the files to be uploaded
/// - parameter boundary:     The `multipart/form-data` boundary
///
/// - returns:                The `Data` of the body of the request

private func createBody(with parameters: [String: String]?, filePathKey: String, manifeestData: Data, boundary: String) throws -> Data {
    var body = Data()
    
    if parameters != nil {
        for (key, value) in parameters! {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            body.append("\(value)\r\n")
        }
    }
    
    let filename = "manifest";
    let mimetype = "application/octet-stream";
    
    body.append("--\(boundary)\r\n")
    body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
    body.append("Content-Type: \(mimetype)\r\n\r\n")
    body.append(manifeestData)
    body.append("\r\n")
    
    body.append("--\(boundary)--\r\n")
    return body
}

/// Create boundary string for multipart/form-data request
///
/// - returns:            The boundary string that consists of "Boundary-" followed by a UUID string.

private func generateBoundaryString() -> String {
    return "Boundary-\(UUID().uuidString)"
}

/// Determine mime type on the basis of extension of a file.
///
/// This requires `import MobileCoreServices`.
///
/// - parameter path:         The path of the file for which we are going to determine the mime type.
///
/// - returns:                Returns the mime type if successful. Returns `application/octet-stream` if unable to determine mime type.

private func mimeType(for path: String) -> String {
    let url = URL(fileURLWithPath: path)
    let pathExtension = url.pathExtension
    
    return "application/octet-stream"
}

extension Data {
    
    /// Append string to Data
    ///
    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
    ///
    /// - parameter string:       The string to be added to the `Data`.
    
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
