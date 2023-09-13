const hre = require("hardhat");

async function main() {
    const NFTEpicContractFactory = await hre.ethers.getContractFactory("NFTEpic");
    const NFTEpic = await NFTEpicContractFactory.deploy();

    await NFTEpic.deployed();

    console.log("NFTEpic deployed to:", NFTEpic.address);

    let txn = await NFTEpic.makeAnEpicNFT();
    await txn.wait();

    txn = await NFTEpic.makeAnEpicNFT();
    await txn.wait();

    const nfts = await NFTEpic.totalTokens();
    console.log(nfts.toString());
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });