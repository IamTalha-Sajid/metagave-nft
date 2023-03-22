async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    // Deployment of ERC20 Token
    const TestToken = await ethers.getContractFactory("Token");
    const testToken = await TestToken.deploy();

    console.log("Contract address:", testToken.address);

    // Deployment of Marketplace Contract
    const HyperMarketPlace = await ethers.getContractFactory("HyperMarketPlace");
    const hyperMarketPlace = await HyperMarketPlace.deploy(testToken.address);

    console.log("Contract address:", hyperMarketPlace.address);

    // Deployment of ERC721 Contract
    const HyperLeague = await ethers.getContractFactory("HyperLeague");
    const hyperLeague = await HyperLeague.deploy(hyperMarketPlace.address);

    console.log("Contract address:", hyperLeague.address);

    //Deployment of Auction Contract
    const HyperAuction = await ethers.getContractFactory("HyperNFTsAuction");
    const hyperAuction = await HyperAuction.deploy(testToken.address, hyperMarketPlace.address, hyperLeague.address);

    console.log("Contract address:", hyperAuction.address);

}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });