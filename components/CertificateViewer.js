"use client"
import React, { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import { abi, NFT_CONTRACT_ADDRESS } from '../constants/index';

const CertificateViewer = () => {
  const [tokenId, setTokenId] = useState('');
  const [certificateInfo, setCertificateInfo] = useState(null);
  const [error, setError] = useState(null);

  const fetchCertificateInfo = async () => {
    await window.ethereum.request({ method: 'eth_requestAccounts' });
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract= new ethers.Contract(NFT_CONTRACT_ADDRESS, abi, signer);
    const info = await contract.getCertificateInfo(tokenId);
    console.log(info);
    setCertificateInfo(info);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    fetchCertificateInfo();
  };

  return (
    <div>
      <h2>Certificate Viewer</h2>
      <form onSubmit={handleSubmit}>
        <label>
          Token ID:
          <input type="text" value={tokenId} onChange={(e) => setTokenId(e.target.value)} style={{ color: 'black' }}/>
        </label>
        <br />
        <button type="submit">Get Certificate Info</button>
      </form>
      <br />
      {error && <p>{error}</p>}
    </div>
  );
};

export default CertificateViewer;
