//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Vicodin on 19.03.2025.
//

import CoreData
import UIKit

protocol CoreDataServiceProtocol {
    func saveTask(_ task: Task, completion: @escaping (Result<Void, Error>) -> Void)
    func fetchTasks(completion: @escaping (Result<[Task], Error>) -> Void)
    func deleteTask(_ taskID: Int, completion: @escaping (Result<Void, Error>) -> Void)
    func saveTasks(_ tasks: [RemoteTask], completion: @escaping (Result<Void, Error>) -> Void)
}

class CoreDataService: CoreDataServiceProtocol {
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
    // MARK: - Сохранение списка задач
    func saveTasks(_ tasks: [RemoteTask], completion: @escaping (Result<Void, Error>) -> Void) {
        context.perform {
            do {
                for task in tasks {
                    guard let id = task.id,
                          let title = task.title,
                          let isCompleted = task.isCompleted else { continue }
                    
                    let taskEntity = TaskEntity(context: self.context)
                    taskEntity.id = Int64(id)
                    taskEntity.title = title
                    taskEntity.isCompleted = isCompleted
                    
                    taskEntity.createdAt = Date()
                    taskEntity.taskDescription = self.taskDescriptions[Int.random(in: 0..<self.taskDescriptions.count)]
                }
                
                try self.context.save()
                DispatchQueue.main.async {
                    FirstLaunchManager.firstLaunchCompleted()
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private let taskDescriptions: [String] = [
        "Заполнить отчет по проделанной работе за месяц, учесть все выполненные задачи, достигнутые цели и проблемы, с которыми столкнулся. Проверить корректность данных перед отправкой руководителю.",
        "Составить план работы на следующую неделю, расставить приоритеты по задачам, учесть дедлайны и возможные задержки. Разбить сложные задачи на более мелкие подзадачи для удобства выполнения.",
        "Обновить документацию по проекту, проверить актуальность информации, внести последние изменения по новой функциональности. Убедиться, что все участники команды в курсе обновлений.",
        "Подготовиться к презентации для заказчика, собрать все необходимые материалы, проработать сценарий выступления, предусмотреть возможные вопросы и подготовить ответы, проверить техническое оборудование.",
        "Разобраться с новыми требованиями по проекту, изучить документацию, определить возможные сложности и предложить оптимальные решения для их реализации. Обсудить детали с командой перед стартом работы.",
        "Провести ревизию старого кода, найти устаревшие или неэффективные решения, предложить варианты оптимизации. Протестировать изменения и убедиться, что они не влияют на работу других частей проекта.",
        "Запустить рекламную кампанию в социальных сетях, проверить настройки таргетинга, проанализировать первые результаты и при необходимости скорректировать стратегию продвижения для повышения эффективности.",
        "Обновить интерфейс приложения, улучшить удобство навигации, протестировать на разных устройствах. Собрать обратную связь от пользователей и внести корректировки, если это необходимо.",
        "Подготовить и отправить клиентам рассылку с информацией о новых функциях в приложении. Проверить тексты на ошибки, убедиться, что письма корректно отображаются на разных устройствах и в почтовых сервисах.",
        "Настроить автоматизированное тестирование, написать тесты для ключевых функций, проверить их работу, убедиться, что новая функциональность не сломала старую. Внедрить тестирование в процесс разработки."
    ]
}
