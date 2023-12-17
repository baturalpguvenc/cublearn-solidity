// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract NftCertificate is ERC721 {
	using Strings for uint256;

	uint256 public nextTokenId;

	mapping(uint256 => CertificateInfo) private certificateInfoMapping;

	struct CertificateInfo {
		string studentFullName;
		string courseName;
		string instructorFullName;
	}

	constructor() ERC721("CubLearn Certificate", "CUBCERT") {}

	function mintCertificate(
		address recipient,
		string memory studentFullName,
		string memory courseName,
		string memory instructorFullName
	) external {
		uint256 tokenId = nextTokenId;
		
		_storeCertificateInfo(tokenId, studentFullName, courseName, instructorFullName);

		_safeMint(recipient, tokenId);

		nextTokenId++;
	}

	function _storeCertificateInfo(
		uint256 tokenId,
		string memory studentFullName,
		string memory courseName,
		string memory instructorFullName
	) internal {
		certificateInfoMapping[tokenId] = CertificateInfo({
			studentFullName: studentFullName,
			courseName: courseName,
			instructorFullName: instructorFullName
		});
	}

	// function getCertificateInfo(uint256 tokenId)
	// 	external
	// 	view
	// 	returns (
	// 		CertificateInfo memory certInfo
	// 	)
	// {
	// 	return certificateInfoMapping[tokenId];
	// }

	function _getSvg(uint256 tokenId) internal view returns (string memory) {
		CertificateInfo storage certInfo = certificateInfoMapping[tokenId];
		string memory svg = string(
			abi.encodePacked(
				unicode"data:image/svg+xml;utf8,<svg width='1024' height='1024' version='1.1' viewBox='0 0 270.93 270.93' xmlns='http://www.w3.org/2000/svg'><g stroke-width='1.75'><rect width='270.93' height='270.93' fill='#fff'/><text x='15.531887' y='33.715561' fill='#000000' font-family='Avenir' font-size='25.4px' letter-spacing='0px' xml:space='preserve'><tspan x='15.531887' y='33.715561' fill='#000000' font-family='Avenir' stroke-width='1.75'>Cub</tspan></text><text x='149.14455' y='33.867962' fill='#000000' font-family='Avenir' font-size='12.7px' letter-spacing='0px' xml:space='preserve'><tspan x='149.14455' y='33.867962' fill='#000000' font-family='Avenir' font-size='12.7px' stroke-width='1.75'>#",
				tokenId.toString(),
				unicode"</tspan></text><g font-family='Avenir' letter-spacing='0px'><text x='63.156933' y='33.715561' fill='#a11235' font-size='25.4px' xml:space='preserve'><tspan x='63.156933' y='33.715561' fill='#a11235' font-family='Avenir' stroke-width='1.75'>Learn</tspan></text><g><text x='16.209221' y='92.678009' fill='#a11235' font-size='11.289px' xml:space='preserve'><tspan x='16.209221' y='92.678009' font-size='11.289px' stroke-width='1.75'>ÖĞRENCİ</tspan></text><text x='15.531888' y='116.36742' fill='#000000' font-size='22.578px' xml:space='preserve'><tspan x='15.531888' y='116.36742' fill='#000000' font-size='22.578px' stroke-width='1.75'>",
				certInfo.studentFullName,
				"</tspan></text><text x='16.209221' y='143.1333' fill='#a11235' font-size='11.289px' xml:space='preserve'><tspan x='16.209221' y='143.1333' font-size='11.289px' stroke-width='1.75'>KURS</tspan></text><text x='15.531888' y='166.82274' fill='#000000' font-size='22.578px' xml:space='preserve'><tspan x='15.531888' y='166.82274' fill='#000000' font-size='22.578px' stroke-width='1.75'>",
				certInfo.courseName,
				unicode"</tspan></text><text x='16.209221' y='193.58873' fill='#a11235' font-size='11.289px' xml:space='preserve'><tspan x='16.209221' y='193.58873' font-size='11.289px' stroke-width='1.75'>EĞİTMEN</tspan></text><text x='15.531888' y='217.27815' fill='#000000' font-size='22.578px' xml:space='preserve'><tspan x='15.531888' y='217.27815' fill='#000000' font-size='22.578px' stroke-width='1.75'>",
				certInfo.instructorFullName,
				"</tspan></text></g></g></g></svg>"
			)
		);
		return svg;
	}

	function tokenURI(uint256 tokenId)
		public
		view
		override
		returns (string memory)
	{
		bytes memory json = abi.encodePacked(
			'{',
				'"name": "CubLearn Certificate #', tokenId.toString(), '",',
				'"image_data": "', _getSvg(tokenId), '"',
			'}'
		);

		return string(
			abi.encodePacked(
				"data:application/json;base64,",
				Base64.encode(json)
			)
		);
	}
}
