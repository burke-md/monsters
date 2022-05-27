async function main () {
  const Monster = await ethers.getContractFactory('Monster');
  console.log('Deploying Monster...');
  const monster = await Monster.deploy();
  await monster.deployed();
  console.log('Monster deployed to: ', monster.address);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
      console.error(err);
      process.exit(1);
  });