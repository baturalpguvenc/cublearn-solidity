"use client"
import { useState } from 'react';
import { ethers } from 'ethers';
import { abi, NFT_CONTRACT_ADDRESS } from "../constants/index";

const CertificateMinter = () => {
  const [certificateId, setCertificateId] = useState('');
  const [userName, setUserName] = useState('');
  const [surName, setSurName] = useState('');
  const [email, setEmail] = useState('');
  const [companyName, setCompanyName] = useState('');

  const mintCertificate = async () => {
    try {
      if (window.ethereum) {
        await window.ethereum.request({ method: 'eth_requestAccounts' });
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const signer = provider.getSigner();
        const certificateContract = new ethers.Contract(NFT_CONTRACT_ADDRESS, abi, signer);

        await certificateContract.mintCertificate(certificateId, userName, surName, email, companyName);
        alert('Certificate minted successfully!');
      } else {
        alert('Please connect your wallet');
      }
    } catch (error) {
      console.error('Error minting certificate:', error);

      if (error.code === 4001) {
        alert('Certificate already issued');
      } else {
        alert('Error minting certificate. Please check the console for details.');
      }
    }
  };

  return (
    <div>
      <h2>Certificate Minter</h2>
      <label>
        Certificate ID:
        <input type="text" value={certificateId} onChange={(e) => setCertificateId(e.target.value)} style={{ color: 'black' }} />
      </label>
      <br />
      <label>
        Name:
        <input type="text" value={userName} onChange={(e) => setUserName(e.target.value)} style={{ color: 'black' }} />
      </label>
      <br />
      <label>
        Surname:
        <input type="text" value={surName} onChange={(e) => setSurName(e.target.value)} style={{ color: 'black' }} />
      </label>
      <br />
      <label>
        Email:
        <input type="text" value={email} onChange={(e) => setEmail(e.target.value)} style={{ color: 'black' }} />
      </label>
      <br />
      <label>
        Company Name:
        <input type="text" value={companyName} onChange={(e) => setCompanyName(e.target.value)} style={{ color: 'black' }} />
      </label>
      <br />
      <button onClick={mintCertificate}>Mint Certificate</button>
    </div>
  );
};

export default CertificateMinter;
