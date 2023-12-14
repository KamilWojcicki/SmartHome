import DependencyInjection
import Foundation
import NavigationInterface
import User
import UserProfile

public struct Dependencies {
    public static func inject() {
        injectShared()

        User.Dependencies.inject()
        UserProfile.Dependencies.inject()
    }
    
    public static func injectShared() {
        Assemblies.inject(type: TabCoordinatorInterface.self, object: TabCoordinator(), inObjectScope: .container)
    }
}
