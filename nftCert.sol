// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Certificate is ERC721, Ownable {
    uint256 public nextCertificateId;

    // Mapping to store additional information for each certificate
    mapping(uint256 => CertificateInfo) private certificateInfoMapping;

    // Mapping to check if a certificate with a given name and wallet address has been issued
    mapping(string => mapping(address => bool)) private issuedCertificates;

    struct CertificateInfo {
        string userName;
        string surName;
        string email;
        string companyName;
    }

    constructor() ERC721("Certificate", "CERT") Ownable(msg.sender) {}

    function mintCertificate(
        uint256 certificateId,
        string memory userName,
        string memory surName,
        string memory email,
        string memory companyName
    ) external {
        // Check if the certificate with the given ID has already been issued
        require(!issuedCertificates[userName][msg.sender], "Certificate already issued");

        _safeMint(msg.sender, certificateId);

        // Store additional information using a mapping
        _storeCertificateInfo(certificateId, userName, surName, email, companyName);

        // Mark the certificate as issued
        issuedCertificates[userName][msg.sender] = true;

        // Update the nextCertificateId only if the mint is successful
        nextCertificateId = certificateId + 1;
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
