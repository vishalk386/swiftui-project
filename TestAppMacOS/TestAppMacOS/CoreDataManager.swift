//
//  CoreDataManager.swift
//  TestAppMacOS
//
//  Created by Vishal Kamble on 13/12/23.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
     let context = PersistenceController.shared.container.viewContext

    func addFileDetail(fileDetailsModel: FileDetailsModel) {
          let fetchRequest: NSFetchRequest<FileDetails> = FileDetails.fetchRequest()
          fetchRequest.predicate = NSPredicate(format: "id = %@", fileDetailsModel.id as CVarArg)

          do {
              let existingFileDetails = try context.fetch(fetchRequest)

              if let firstExistingFileDetail = existingFileDetails.first {
                  // Update the existing object with the new data
                  firstExistingFileDetail.filename = fileDetailsModel.filename
                  firstExistingFileDetail.optimizedName = fileDetailsModel.optimizedName
                  firstExistingFileDetail.fileURL = fileDetailsModel.fileURL
                  firstExistingFileDetail.optimizedURL = fileDetailsModel.optimizedURL
                  firstExistingFileDetail.fileExtension = fileDetailsModel.fileExtension
                  firstExistingFileDetail.isChecked = fileDetailsModel.isChecked
                  firstExistingFileDetail.folderURL = fileDetailsModel.folderURL
                  firstExistingFileDetail.optimizedSize = fileDetailsModel.optimizedSize
                  firstExistingFileDetail.optimizedFolder = fileDetailsModel.optimizedFolder
                  firstExistingFileDetail.isFileShrinked = fileDetailsModel.isFileShrinked
                  firstExistingFileDetail.optimizePercentage = fileDetailsModel.optimizePercentage
                  firstExistingFileDetail.updatedDate =  Date()
                  
                  // Similarly, update other attributes as needed
              } else {
                  // Create a new object if no similar object found
                  let fileDetails = fileDetailsModel.toManagedObject(in: context)
                  fileDetails.createdDate = Date()
                  context.insert(fileDetails)
              }

              try context.save()
//              print("FileDetails saved successfully.")
          } catch {
              print("Error saving or updating FileDetails: \(error)")
          }
      }

    
    
    
    
    
    func moveFileDetailToCompressed(fileDetail: FileDetailsModel) {
         
           // Create an instance of CompressedFileDetails
           let compressedFileDetail = CompressedFileDetails(context: context)
           
           // Copy data from the old entity to the new entity
           compressedFileDetail.id = fileDetail.id
           compressedFileDetail.optimizedFolder = fileDetail.optimizedFolder
           compressedFileDetail.optimizedSize = fileDetail.optimizedSize
           compressedFileDetail.originalSize = fileDetail.originalSize
           compressedFileDetail.optimizePercentage = fileDetail.optimizePercentage
        compressedFileDetail.folderURL = fileDetail.folderURL
           compressedFileDetail.updatedDate = Date()

           // Save the new compressed file detail
           do {
               try context.save()
           } catch {
               print("Error saving CompressedFileDetails: \(error)")
           }
       }
    
    
    func fileExistsWithFilename(_ filename: String) -> Bool {
        let fetchRequest: NSFetchRequest<FileDetails> = FileDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "filename = %@", filename)
        
        do {
            return try context.fetch(fetchRequest).count > 0
        } catch {
            print("Error checking if file exists in the database: \(error)")
            return false
        }
    }


    func fetchFileDetails() -> [FileDetailsModel] {
        let fetchRequest: NSFetchRequest<FileDetails> = FileDetails.fetchRequest()
        do {
            let fileDetailsList = try context.fetch(fetchRequest)
            return fileDetailsList.map { $0.toModel() }
        } catch {
            print("Error fetching FileDetails: \(error)")
            return []
        }
    }
    
   func fetchCompressedFileDetails() -> [CompressedFileDetailsModel] {
        let fetchRequest: NSFetchRequest<CompressedFileDetails> = CompressedFileDetails.fetchRequest()
        do {
            let fileDetailsList = try context.fetch(fetchRequest)
            return fileDetailsList.map { $0.toModel() }
        } catch {
            print("Error fetching FileDetails: \(error)")
            return []
        }
    }
    
    
    func fetchExistingFilenames() -> Set<String> {
        var existingFilenames: Set<String> = []

        let fetchRequest: NSFetchRequest<FileDetails> = FileDetails.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            for result in results {
                if let filename = result.filename {
                    existingFilenames.insert(filename.lowercased())
                }
            }
        } catch {
            print("Error fetching existing filenames: \(error)")
        }

        return existingFilenames
    }

    
    func deleteFileDetail(fileDetail: FileDetailsModel) {
        let fetchRequest: NSFetchRequest<FileDetails> = FileDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", fileDetail.id as CVarArg)

        do {
            let existingFileDetails = try context.fetch(fetchRequest)

            if let firstExistingFileDetail = existingFileDetails.first {
                if fileDetail.isChecked {
                    context.delete(firstExistingFileDetail) // Delete the object from the Core Data context
                    try context.save() // Save the changes
                } else {
                    // Handle the case where the item is not checked but needs to be deleted
                    // For example, you can display an alert to inform the user that the item needs to be checked before deletion.
                }
            }
        } catch {
            print("Error deleting FileDetails: \(error)")
        }
    }
    
    func deleteFileDetailAfterShinked(fileDetail: FileDetailsModel) {
        
        moveFileDetailToCompressed(fileDetail: fileDetail)
        let fetchRequest: NSFetchRequest<FileDetails> = FileDetails.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id = %@", fileDetail.id as CVarArg)

        do {
            let existingFileDetails = try context.fetch(fetchRequest)

            if let firstExistingFileDetail = existingFileDetails.first {
                if fileDetail.isFileShrinked {
                    context.delete(firstExistingFileDetail) // Delete the object from the Core Data context
                    try context.save() // Save the changes
                } else {
                    // Handle the case where the item is not checked but needs to be deleted
                    // For example, you can display an alert to inform the user that the item needs to be checked before deletion.
                }
            }
        } catch {
            print("Error deleting FileDetails: \(error)")
        }
    }

    func sqliteFilePath() -> String? {
           guard let storeURL = context.persistentStoreCoordinator?.persistentStores.first?.url else {
               return nil
           }
           return storeURL.path
       }
}
