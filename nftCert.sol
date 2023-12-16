// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Certificate is ERC721, Ownable {
    uint256 public nextCertificateId;

    // Mapping to store additional information for each certificate
    mapping(uint256 => CertificateInfo) private certificateInfoMapping;

    struct CertificateInfo {
        string userName;
        string surName;
        string email;
        string companyName;
    }

    constructor() ERC721("Certificate", "CERT") Ownable(msg.sender) {}

    function mintCertificate(
        address recipient,
        string memory userName,
        string memory surName,
        string memory email,
        string memory companyName
    ) external onlyOwner {
        uint256 tokenId = nextCertificateId;
        _safeMint(recipient, tokenId);
        nextCertificateId++;

        // Store additional information using a mapping
        _storeCertificateInfo(tokenId, userName, surName, email, companyName);
    }

    function _storeCertificateInfo(
        uint256 tokenId,
        string memory userName,
        string memory surName,
        string memory email,
        string memory companyName
    ) internal {
        certificateInfoMapping[tokenId] = CertificateInfo({
            userName: userName,
            surName: surName,
            email: email,
            companyName: companyName
        });
    }

    function getCertificateInfo(uint256 tokenId)
        external
        view
        returns (
            string memory userName,
            string memory surName,
            string memory email,
            string memory companyName
        )
    {
        CertificateInfo storage info = certificateInfoMapping[tokenId];
        return (info.userName, info.surName, info.email, info.companyName);
    }
}
