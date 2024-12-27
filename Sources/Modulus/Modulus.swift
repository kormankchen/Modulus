//
//  Modulus.swift
//  Modulus
//
//  Created by Korman Chen on 12/3/24.
//

import Foundation

final public class Modulus {
	@TaskLocal static var container = Container()
	let exportables: [Exportables]

	private init(with exportables: [Exportables.Type]) {
		self.exportables = exportables.map { $0.init() }
	}

	@discardableResult public static func initialize(with exportables: [Exportables.Type]) -> Modulus {
		Modulus(with: exportables)
	}

	public static func withExportables<R>(_ exportables: [Exportables.Type], _ operation: () throws -> R) rethrows -> R {
		try Modulus.$container.withValue(container.copy()) {
			Modulus.initialize(with: exportables)
			return try operation()
		}
	}

	public static func withExportables<R>(_ exportables: [Exportables.Type], _ operation: () async throws -> R) async rethrows -> R {
		try await Modulus.$container.withValue(container.copy()) {
			Modulus.initialize(with: exportables)
			return try await operation()
		}
	}

	public static func reset() {
		container.reset()
	}
}
