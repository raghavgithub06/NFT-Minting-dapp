import './App.css';

import React, { useEffect, useState } from "react"
import { ethers } from "ethers";

import NFTEpic from "./utils/NFTEpic.json"

// Constants
const OPENSEA_LINK = 'https://testnets.opensea.io/collection/shingekinokyojinnft';

const App = () => {

  const CONTRACT_ADDRESS = "0xe96CA3Ab75Eb32C1C0d7F692D8ab4A91d1862386";

  const [account, setAccount] = useState("");
  const [totalTokens, setTotalTokens] = useState("");
  const [loading, setLoading] = useState(false);

  const connectWallet = async () => {
    try {

      if (!window.ethereum) {
        alert("Get MetaMask!");
        return;
      }

      console.log("Metamsk available");

      const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
      setAccount(accounts[0]);

      accountsListener();
      networkListener();

      setEventListener();
      getTotalNFTs();

    } catch (error) {
      console.log(error)
    }
  }

  const setEventListener = () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, NFTEpic.abi, signer);

        connectedContract.on("NFTMinted", (from, tokenId) => {
          console.log(from, tokenId.toString());
          alert(` Here's the link to your contract: https://testnets.opensea.io/assets/${CONTRACT_ADDRESS}/${tokenId.toString()}. It might take some time to show up on opensea`);
        });

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

  const accountsListener = () => {
    window.ethereum.removeListener('accountsChanged', handleAccounts);
    window.ethereum.on("accountsChanged", handleAccounts);
  }

  const handleAccounts = async () => {
    console.log("account changed");
    const newAccounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    setAccount(newAccounts[0]);
  }

  const networkListener = () => {
    window.ethereum.removeListener('chainChanged', (chainId) => {
      networkHandler(chainId);
    });
    window.ethereum.on('chainChanged', (chainId) => {
      networkHandler(chainId);
    });
  }

  const networkHandler = (chainId) => {
    if (chainId !== "0x4") {
      alert("Please connect to the rinkeby network!");
    }
  }

  const askContractToMintNft = async () => {

    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, NFTEpic.abi, signer);

        console.log("Going to pop wallet now to pay gas...");
        setLoading(true);
        let nftTxn = await connectedContract.makeAnEpicNFT();

        console.log("Mining...please wait.")
        await nftTxn.wait();

        console.log(`Mined, see transaction: https://rinkeby.etherscan.io/tx/${nftTxn.hash}`);
        setLoading(false);

        const tokens = await connectedContract.totalTokens();
        setTotalTokens(tokens.toString());

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error);
      setLoading(false);
    }
  }

  const getTotalNFTs = async () => {
    try {
      const { ethereum } = window;

      if (ethereum) {
        const provider = new ethers.providers.Web3Provider(ethereum);
        const signer = provider.getSigner();
        const connectedContract = new ethers.Contract(CONTRACT_ADDRESS, NFTEpic.abi, signer);

        const tokens = await connectedContract.totalTokens();
        console.log(tokens.toString());
        setTotalTokens(tokens.toString());
        console.log(totalTokens);

      } else {
        console.log("Ethereum object doesn't exist!");
      }
    } catch (error) {
      console.log(error)
    }
  }

  const renderMintUI = () => (
    <button onClick={askContractToMintNft} className="cta-button connect-wallet-button">
      Mint NFT
    </button>
  )
  // Render Methods
  const renderNotConnectedContainer = () => (
    <button onClick={connectWallet} className="cta-button connect-wallet-button">
      Connect to Wallet
    </button>
  )

  const showCollection = () => (
    <a href={OPENSEA_LINK} target="_blank">
      <button className="cta-button connect-wallet-button">
        Show Collection
      </button>
    </a>
  )

  return (
    <div className="App">
      <div className="container">
        <div className="header-container">
          <p className="header gradient-text">My AOT NFT Collection</p>
          <p className="sub-text">
            Get AOT characters as NFTs. Lets see if you can get a character with the right name.
          </p>
          {account !== "" && <p className="minting">account connected - {account}</p>}
          {account === "" ? renderNotConnectedContainer() : renderMintUI()}
          <p>{account !== "" && showCollection()}</p>
          {totalTokens !== "" && <p className="minting">Total NFTs minted = <b>{totalTokens}/100</b></p>}
          <p>{loading && <b className="minting">...minting</b>}</p>
        </div>
      </div>
    </div>
  );
};

export default App;