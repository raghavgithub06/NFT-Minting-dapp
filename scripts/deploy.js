const hre = require("hardhat");

async function main() {
    const NFTEpicContractFactory = await hre.ethers.getContractFactory("NFTEpic");
    const NFTEpic = await NFTEpicContractFactory.deploy();

    await NFTEpic.deployed();

    console.log("NFTEpic deployed to:", NFTEpic.address);

    let txn = await NFTEpic.makeAnEpicNFT();
    await txn.wait();
    console.log("NFT deployed");

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });