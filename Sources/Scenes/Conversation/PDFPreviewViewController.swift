//
//  PDFPreviewViewController.swift
//  Desk360
//
//  Created by Ali Ammar Hilal on 1.11.2021.
//

import UIKit
import PDFKit
import PersistenceKit

@available(iOS 11.0, *)
final class PDFPreviewViewController: UIViewController {
    
    lazy var pdfView: PDFView = {
        let pdfView = PDFView()
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.displayDirection = .vertical
        return pdfView
    }()
    
    let file: AttachObject
    
    init(file: AttachObject) {
        self.file = file
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(pdfView)
        pdfView.pinToSuperviewEdges()
        guard let pdfURL = URL(string: file.url) else { return }
        PDFDocumentCache.loadDocument(fromURL: pdfURL) { [weak self] document in
            self?.pdfView.document = document
        }
    }
}

@available(iOS 11.0, *)
struct PDFDocumentSnapshot: Codable, Identifiable {
    typealias ID = URL
    
    var url: URL
    let docData: Data?

    init(url: URL, docData: Data?) {
        self.url = url
        self.docData = docData
    }
    
    static var idKey: WritableKeyPath<PDFDocumentSnapshot, URL> {
        \PDFDocumentSnapshot.url
    }
    
    enum CodingKeys: String, CodingKey {
        case url
        case data
    }
    
    init(from decoder: Decoder) throws {
        var continer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.url = try continer.decode(URL.self, forKey: .url)
        self.docData = try continer.decode(Data.self, forKey: .data)
    }
    
    func encode(to encoder: Encoder) throws {
        var continer = try encoder.container(keyedBy: CodingKeys.self)
        try continer.encode(docData, forKey: .data)
        try continer.encode(url, forKey: .url)
    }
}

@available(iOS 11.0, *)
final class PDFDocumentCache {

    @available(iOS 11.0, *)
    private static var storage = UserDefaultsStore<PDFDocumentSnapshot>(uniqueIdentifier: "desk360_pdf_docs_cache")!
        
    static func loadDocument(fromURL url: URL, completion: ((PDFDocument?) -> Void)?) {
        if let snapshot = storage.object(withId: url),
           let docData = snapshot.docData,
           let pdfDoc = PDFDocument(data: docData) {
            completion?(pdfDoc)
        } else {
            DispatchQueue.global(qos: .background).async {
                if let pdfDocument = PDFDocument(url: url) {
                    let snapShot = PDFDocumentSnapshot(url: url, docData: pdfDocument.dataRepresentation())
                    try? storage.save(snapShot)
                    DispatchQueue.main.async {
                        completion?(pdfDocument)
                    }
                }
            }
        }
    }
    
    static func clear() {
        storage.deleteAll()
    }
}
