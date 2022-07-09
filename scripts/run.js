const main = async () => {
    const waveContractFactory = await hre.ethers.getContractFactory("WavePortal");
    const waveContract = await waveContractFactory.deploy({
      value: hre.ethers.utils.parseEther("0.1"),
    });
    await waveContract.deployed();
    console.log("Contract addy", waveContract.address);

    //get contract balance
    let contractBalance = await hre.ethers.provider.getBalance(
      waveContract.address
    );
    console.log(
      "Contract Balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );

    //two waves to test
    const waveTxn = await waveContract.wave("This is wave #1");
    await waveTxn.wait();

    const waveTxn2 = await waveContract.wave("This is wave #2");
    await waveTxn2.wait();

    //Get contract bal to see what happend
    contractBalance = await hre.ethers.provider.getBalance(waveContract.address);
    console.log(
      "Contract Balance:",
      hre.ethers.utils.formatEther(contractBalance)
    );
      
    let allWaves = await waveContract.getAllWaves();
    console.log(allWaves);

    /*let waveCount;
    waveCount = await waveContract.getTotalWaves();
    console.log(waveCount.toNumber());

    const [_, randomPerson] = await hre.ethers.getSigners();
    waveTxn = await waveContract.connect(randomPerson).wave("Another message!");
    await waveTxn.wait();*/
};
  
const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
    }
};

runMain();
