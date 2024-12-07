//
//  Fixtures.swift
//  Modulus
//
//  Created by Korman Chen on 12/1/24.
//

@testable import Modulus

protocol Dependency {
}

enum Fixtures {
	final class MockDependencyOne: Dependency {
	}

	final class MockDependencyTwo: Dependency {
	}

	final class MockExportable: Exportables {
		@Export var dependency: Dependency = MockDependencyOne()
	}
}
