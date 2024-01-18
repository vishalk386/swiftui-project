//
//  FileDetails+CoreDataProperties.swift
//  TestAppMacOS
//
//  Created by Vishal Kamble on 13/12/23.
//
//

import Foundation
import CoreData


extension FileDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FileDetails> {
        return NSFetchRequest<FileDetails>(entityName: "FileDetails")
    }

    @NSManaged public var filename: String?
    @NSManaged public var fileURL: URL?
    @NSManaged public var id: UUID?
    @NSManaged public var fileExtension: String?
    @NSManaged public var folderURL: URL?
    @NSManaged public var optimizedURL: URL?
    @NSManaged public var originalSize: String?
    @NSManaged public var optimizePercentage: Int16
    @NSManaged public var isChecked: Bool
    @NSManaged public var isFileShrinked: Bool
    @NSManaged public var createdDate: Date?
    @NSManaged public var updatedDate: Date?
    @NSManaged public var optimizedSize: String?
    @NSManaged public var optimizedFolder: URL?
    @NSManaged public var optimizedName: String?

}

extension FileDetails : Identifiable {

}
