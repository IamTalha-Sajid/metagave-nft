async function main() {
    const [deployer, addr1] = await ethers.getSigners();

    console.log("Deploying contracts with the account:", deployer.address);

    console.log("Account balance:", (await deployer.getBalance()).toString());

    const HyperVesting = await ethers.getContractFactory("HyperVesting");
    const hyperVesting = await HyperVesting.deploy(0x5FbDB2315678afecb367f032d93F642f64180aa3, [[addr1, 100], [addr2, 200]], 1670411836, 10000, 2, true, 500, 20, 40);

    console.log("Contract address:", hyperVesting.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });