// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./DTLToken.sol";
import "./NftCertificate.sol";

contract CubLearn is Ownable {
	DTLToken dtlContract;
	NftCertificate cubcertContract;
	
	uint256 public cashbackPercentage;

	// course id => price in DTL
	mapping(string => uint256) private coursePrices;
	
	// course id => student address => is enrolled
	mapping(string => mapping(address => bool)) private enrolledCourses;

	// course id => student address => is certificate issued
	mapping(string => mapping(address => bool)) private issuedCertificates;

	constructor(address dtlContractAddress, address cubcertContractAddress) Ownable(msg.sender) {
		dtlContract = DTLToken(dtlContractAddress);
		cubcertContract = NftCertificate(cubcertContractAddress);

        coursePrices["1"] = 300;
        coursePrices["2"] = 500;
        coursePrices["3"] = 200;
        coursePrices["4"] = 150;
        coursePrices["5"] = 250;
        coursePrices["6"] = 250;
        coursePrices["7"] = 450;
        
		cashbackPercentage = 50;
	}

	function setCashbackPercentage(uint256 newValue) external onlyOwner {
        require(newValue <= 100, "Cashback percentage cannot be more than 100.");

		cashbackPercentage = newValue;
	}

	function enroll(string memory courseId) external {
		require(coursePrices[courseId] != 0, "Course not found.");

		dtlContract.transferFrom(msg.sender, address(this), coursePrices[courseId]);

        enrolledCourses[courseId][msg.sender] = true;
	}

	function finishCourse(
		string memory courseId,
		string memory studentFullName,
		string memory courseName,
		string memory instructorFullName
	) external {
		require(enrolledCourses[courseId][msg.sender], "Must be enrolled in course.");
		require(!issuedCertificates[courseId][msg.sender], "Certificate already issued.");

		cubcertContract.mintCertificate(msg.sender, studentFullName, courseName, instructorFullName);

		// Mark the certificate as issued
		issuedCertificates[courseId][msg.sender] = true;

        // Cashback
        uint256 cashbackAmount = coursePrices[courseId] * cashbackPercentage / 100;
        dtlContract.transfer(msg.sender, cashbackAmount);
	}

	function getDTLBalance() external view onlyOwner returns (uint256) {
		return dtlContract.balanceOf(address(this));
	}

	function transferAllDTLBalanceToMe() external onlyOwner {
		uint256 balance = dtlContract.balanceOf(address(this));
		dtlContract.transfer(msg.sender, balance);
	}
}
