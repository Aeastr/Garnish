import Foundation
import CoreData
import SwiftUI

/// CoreData persistence layer for GarnishTheme
public class GarnishThemePersistence {
    // MARK: - Core Data Stack

    /// Shared persistence container
    public static let shared = GarnishThemePersistence()

    private init() {
        // No transformers needed - using native Double attributes
    }

    /// The persistent container for GarnishTheme data
    public lazy var persistentContainer: NSPersistentContainer = {
        guard let modelURL = Bundle.module.url(forResource: "GarnishDB", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load GarnishDB.xcdatamodeld from bundle")
        }

        let container = NSPersistentContainer(name: "GarnishDB", managedObjectModel: model)

        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load CoreData store: \(error)")
            }
        }

        // Enable automatic merging of changes
        container.viewContext.automaticallyMergesChangesFromParent = true

        return container
    }()

    /// Main context for UI operations
    public var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    /// Background context for heavy operations
    public func backgroundContext() -> NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }

    // MARK: - Save Context

    /// Save changes to the context
    public func save() throws {
        let context = self.context

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw GarnishThemeError.coreDataError(error)
            }
        }
    }

    /// Save changes in background context
    public func save(context: NSManagedObjectContext) throws {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                throw GarnishThemeError.coreDataError(error)
            }
        }
    }
}

// MARK: - Theme Operations

public extension GarnishThemePersistence {
    /// Check if a theme exists by name
    func themeExists(name: String) throws -> Bool {
        let request: NSFetchRequest<GarnishThemeEntity> = GarnishThemeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            throw GarnishThemeError.coreDataError(error)
        }
    }

    /// Fetch a theme by name
    func fetchTheme(name: String) throws -> GarnishThemeEntity? {
        let request: NSFetchRequest<GarnishThemeEntity> = GarnishThemeEntity.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1

        // Fetch with colors relationship
        request.relationshipKeyPathsForPrefetching = ["colors"]

        do {
            let themes = try context.fetch(request)
            return themes.first
        } catch {
            throw GarnishThemeError.coreDataError(error)
        }
    }

    /// Fetch all user themes
    func fetchAllThemes() throws -> [GarnishThemeEntity] {
        let request: NSFetchRequest<GarnishThemeEntity> = GarnishThemeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        request.relationshipKeyPathsForPrefetching = ["colors"]

        do {
            return try context.fetch(request)
        } catch {
            throw GarnishThemeError.coreDataError(error)
        }
    }

    /// Create a new theme entity
    func createTheme(name: String) throws -> GarnishThemeEntity {
        // Check if theme already exists
        if try themeExists(name: name) {
            throw GarnishThemeError.themeAlreadyExists(name)
        }

        let theme = GarnishThemeEntity(context: context)
        theme.name = name
        theme.createdAt = Date()
        theme.updatedAt = Date()

        return theme
    }

    /// Delete a theme
    func deleteTheme(_ theme: GarnishThemeEntity) throws {
        context.delete(theme)
        try save()
    }

    /// Update theme's updatedAt timestamp
    func touchTheme(_ theme: GarnishThemeEntity) {
        theme.touch()
    }
}

// MARK: - Color Operations

public extension GarnishThemePersistence {
    /// Set a color for a theme
    func setColor(for theme: GarnishThemeEntity, key: ColorKey, light: Color?, dark: Color?) throws {
        try theme.setColors(for: key, light: light, dark: dark)
        theme.touch()
    }

    /// Get color for a theme and key
    func getColor(for theme: GarnishThemeEntity, key: ColorKey, scheme: ColorScheme) throws -> Color? {
        return theme.color(for: key, scheme: scheme)
    }

    /// Get all color keys defined for a theme
    func getColorKeys(for theme: GarnishThemeEntity) -> [ColorKey] {
        return theme.definedColorKeys
    }

    /// Remove a color from a theme
    func removeColor(for theme: GarnishThemeEntity, key: ColorKey) throws {
        theme.removeColor(for: key)
        theme.touch()
    }
}
