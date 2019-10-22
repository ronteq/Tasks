//
//  TaskDataSource.swift
//  SpendeeTask
//
//  Created by Daniel Gustavo Fernandez Yopla on 22/10/2019.
//  Copyright © 2019 danielfcodes. All rights reserved.
//

import Foundation
import CoreData

protocol TaskDataSourceProtocol {
    func saveTask(_ task: Task, completion: @escaping (Result<EmptyObject, Error>) -> Void)
//    func updateCategory(completion: @escaping (Result<EmptyObject, Error>) -> Void)
    func getTasks(completion: @escaping (Result<[Task], Error>) -> Void)
//    func getCategory(withName name: String, completion: @escaping (Result<MOCategory, Error>) -> Void)
}

class TaskDataSource: TaskDataSourceProtocol {
    
    private let categoryDataSource: CategoryDataSourceProtocol
    
    init(categoryDataSource: CategoryDataSourceProtocol = CategoryDataSource()) {
        self.categoryDataSource = categoryDataSource
    }
    
    func saveTask(_ task: Task, completion: @escaping (Result<EmptyObject, Error>) -> Void) {
        let context = CoreDataManager.shared.viewContext
        let moTask = MOTask(context: context)
        moTask.name = task.name
        moTask.expirationDate = Date()
        moTask.isDone = task.isDone
        
        categoryDataSource.getCategory(withName: task.category.name) { result in
            switch result {
            case .success(let moCategory): moTask.moCategory = moCategory
            case .failure(let error): completion(.failure(error))
            }
        }

        do {
            try context.save()
            completion(.success(EmptyObject()))
        } catch let error {
            completion(.failure(error))
        }
    }
    
//    func updateCategory(completion: @escaping (Result<EmptyObject, Error>) -> Void) {
//        let context = CoreDataManager.shared.viewContext
//
//        do {
//            try context.save()
//            completion(.success(EmptyObject()))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
    
    func getTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        let context = CoreDataManager.shared.viewContext
        let request: NSFetchRequest<MOTask> = MOTask.fetchRequest()
        
        do {
            let moTasks = try context.fetch(request)
            let tasks = moTasks.compactMap { Task(moTask: $0) }
            completion(.success(tasks))
        } catch let error {
            completion(.failure(error))
        }
    }
    
//    func getCategory(withName name: String, completion: @escaping (Result<MOCategory, Error>) -> Void) {
//        let context = CoreDataManager.shared.viewContext
//        let predicate = NSPredicate(format: "name == %@", name)
//        let request: NSFetchRequest<MOCategory> = MOCategory.fetchRequest()
//        request.predicate = predicate
//
//        do {
//            guard let moCategory = try context.fetch(request).first else {
//                return
//            }
//
//            completion(.success(moCategory))
//        } catch let error {
//            completion(.failure(error))
//        }
//    }
    
}