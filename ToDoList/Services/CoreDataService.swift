//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import CoreData
import UIKit

final class CoreDataService {
    static let shared = CoreDataService()
    private let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "TaskModel")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Ошибка загрузки CoreData: \(error)")
            }
        }
    }

    private lazy var context = persistentContainer.newBackgroundContext()

    // MARK: - Сохранение задачи
    func saveTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [Int64(task.id)])
            

            do {
                let results = try self.context.fetch(fetchRequest)
                let taskEntity: TaskEntity

                if let existingTask = results.first {
                    taskEntity = existingTask
                } else {
                    taskEntity = TaskEntity(context: self.context)
                    taskEntity.id = Int64(Date().timeIntervalSince1970 * 1000)
                    taskEntity.createdAt = Date()
                }

                taskEntity.title = task.title
                taskEntity.taskDescription = task.description
                taskEntity.isCompleted = task.isCompleted

                try self.context.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Получение списка задач
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            
            let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            
            do {
                let taskEntities = try self.context.fetch(fetchRequest)
                let tasks = taskEntities.map { entity in
                    Task(
                        id: Int(entity.id),
                        title: entity.title ?? "",
                        description: entity.taskDescription ?? "",
                        createdAt: entity.createdAt ?? Date(),
                        isCompleted: entity.isCompleted
                    )
                }
                DispatchQueue.main.async {
                    completion(.success(tasks))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }

    // MARK: - Удаление задачи
    func deleteTask(_ taskID: Int, completion: @escaping (Result<Void, Error>) -> Void) {
        context.perform {
            let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [Int64(taskID)])

            do {
                if let taskEntity = try self.context.fetch(fetchRequest).first {
                    self.context.delete(taskEntity)
                    try self.context.save()
                    DispatchQueue.main.async {
                        completion(.success(()))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NSError(domain: "CoreData", code: 404, userInfo: [NSLocalizedDescriptionKey: "Задача не найдена"])))
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
