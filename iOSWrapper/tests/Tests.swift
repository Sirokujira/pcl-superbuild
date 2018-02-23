import XCTest

@testable import sample

class sampleTests: XCTestCase, NetworkManagerDelegate {

    var callApiExpectation: XCTestExpectation? = nil

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    // MARK: - Reurn value

    /*!
     * ���ʂ�߂�l�ŕԂ��B
     */
    func testReturnVelue() {
        let manager = NetworkManager()
        let userData = manager.userData()

        // �߂�l���m�F����ꍇ�́A�f���ɔ�r����B
        XCTAssertNotNil(userData)

        XCTAssertEqual(userData.username, "TEST1234")
        XCTAssertEqual(userData.uuid, "CAD34831-E763-45A9-8BA2-31991DCB682B")
        XCTAssertEqual(userData.rank, 1)

        XCTAssertNotNil(userData.latestAccessDate)
    }

    // MARK: - Asynchronous(Delegate)

    /*!
     * ���ʂ� Delegate �ŕԂ��B
     */
    func testCallApiDelegate() {
        // �񓯊������̊������Ď�����I�u�W�F�N�g���쐬
        // �ʃ��\�b�h�ɂȂ邽�߃����o�ϐ���p��
        self.callApiExpectation = self.expectation(description: "CallApiDelegate")

        let manager = NetworkManager()
        manager.delegate = self
        manager.callApi(command: .Update, parameters: nil, completionHandler: nil)

        // �w��b���҂�
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    func callBackApi(result: [NetworkManager.ApiResutKeys : Any]) {
        // �񓯊������̊Ď����I��
        self.callApiExpectation?.fulfill()
        // ���ʂ��m�F
        XCTAssertNotNil(result)
    }

    // MARK: - Asynchronous(Blocks)

    /*!
     * �񓯊������Ō��ʂ� Blocks �ŕԂ��B
     */
    func testImageDownlaodBlocks() {
        // �񓯊������̊������Ď�����I�u�W�F�N�g���쐬
        let expectation = self.expectation(description: "CallApiBlocks")

        let manager = NetworkManager()
        manager.delegate = self
        manager.callApi(command: .Update, parameters: nil) { (result, apiResult, error) in
            // �񓯊������̊Ď����I��
            expectation.fulfill()
            // ���ʂ��m�F
            XCTAssertTrue(result)
        }

        // �w��b���҂�
        self.waitForExpectations(timeout: 10, handler: nil)
    }

    // MARK: - Asynchronous(Notification)

    /*!
     * ���ʂ� Notification �ŕԂ��B
     */
    func testCallApiNotification() {
        // �ʒm���Ď�����
        self.expectation(forNotification: NetworkManager.ApiCallbackNotification.rawValue, object: nil) { (notification) -> Bool in
            // ���ʂ��m�F
            XCTAssertNotNil(notification.object)
            let apiResult = notification.object as! [NetworkManager.ApiResutKeys: AnyObject]
            XCTAssertTrue(apiResult[.Status] as! Bool)
            XCTAssertNil(apiResult[.Error])

            // �ʒm�̊Ď����I��
            return true
        }

        let manager = NetworkManager()
        manager.callApi(command: .Update, parameters: nil, completionHandler: nil)

        // �w��b���҂�
        self.waitForExpectations(timeout: 10, handler: nil)
    }
}

