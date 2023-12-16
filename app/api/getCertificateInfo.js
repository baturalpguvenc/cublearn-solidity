// getCertificateInfo.js
export const getCertificateInfo = async (contract, tokenId) => {
    try {
      // Call the getCertificateInfo function in the smart contract
      const certificateInfo = await contract.getCertificateInfo(tokenId);
      console.log('Certificate Information:', certificateInfo);
    } catch (error) {
      console.error('Error getting certificate information:', error);
    }
  };
  