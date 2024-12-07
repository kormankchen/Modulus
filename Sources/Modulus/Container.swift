import Foundation

final class Container: @unchecked Sendable {
	private let lock = NSLock()
	private var dependencies: [ObjectIdentifier: Any] = [:]

	init(dependencies: [ObjectIdentifier: Any] = [:]) {
		self.dependencies = dependencies
	}

	func register<D>(type: D.Type, _ dependency: D) {
		lock.withLock {
			dependencies[ObjectIdentifier(type)] = dependency
		}
	}

	func dependency<D>(for type: D.Type) -> D {
		lock.withLock {
			guard let dependency = dependencies[ObjectIdentifier(type)] as? D else {
				fatalError("Importing a dependency that hasn't been imported")
			}
			return dependency
		}
	}

	func reset() {
		lock.withLock {
			dependencies.removeAll()
		}
	}

	func copy() -> Container {
		Container(dependencies: dependencies)
	}
}
