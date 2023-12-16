// mintCertificate.js
export const mintCertificate = async (contract, recipient, userName, surName, email, companyName) => {
    try {
      // Call the mintCertificate function in the smart contract
      await contract.mintCertificate(recipient, userName, surName, email, companyName);
      console.log('Certificate minted successfully!');
    } catch (error) {
      console.error('Error minting certificate:', error);
    }
  };
  