async function main () {
    const Battle = await ethers.getContractFactory('Battle');
    console.log('Deploying Battle...');
    const battle = await Battle.deploy();
    await battle.deployed();
    console.log('Battle deployed to: ', battle.address);
}

main()
    .then(() => process.exit(0))
    .catch((err) => {
        console.error(err);
        process.exit(1);
    });
