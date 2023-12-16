"use client"
import { ethers } from 'ethers';

export const connectToEthereum = async () => {
  if (typeof window !== 'undefined' && typeof window.ethereum !== 'undefined') {
    // Connect to Ethereum provider
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();

    // Your contract address and ABI
    const contractAddress = '0x009463E1a8a8CE34dE1D5d04414a2e2502741aA1';
    const contractABI = abi;

    // Instantiate the contract
    const contract = new ethers.Contract(contractAddress, contractABI, signer);

    return contract;
  }
  return null;
};
