import Testing
@testable import Modulus

final class ModulusTests {
	@Test func test_registry() async throws {
		let registry = Container()

		registry.register(type: Dependency.self, Fixtures.MockDependencyOne())

		#expect(registry.dependency(for: Dependency.self) != nil)
	}

	@Test func test_import_default() throws {
		try Modulus.withExportables([Fixtures.MockExportable.self]) {
			@Import(Dependency.self) var imported
			_ = try #require(imported as? Fixtures.MockDependencyOne)
		}
	}

	@Test func test_import_overridden_value() throws {
		try Modulus.withExportables([Fixtures.MockExportable.self]) {
			@Export var exported: Dependency = Fixtures.MockDependencyTwo()
			@Import(Dependency.self) var imported

			let e = try #require(exported as? Fixtures.MockDependencyTwo)
			let i = try #require(imported as? Fixtures.MockDependencyTwo)

			#expect(e === i)
		}
	}
}
