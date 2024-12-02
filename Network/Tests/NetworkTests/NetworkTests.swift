import Testing
@testable import Network

@Suite("PodcastService Tests")
struct PodcastServiceTests {

    @Test
    func example() throws {
        #expect(DefaultPodcastService(apiKey: "awd") != nil)
    }
}
