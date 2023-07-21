const { expect } = require("chai");
const { ethers } = require("hardhat");
const { parseEther, formatEther } = require("ethers");

describe("Safe Re-Entrancy Test 2", function () {
  let deployer, user, attacker;
  let scStore;
  let scAttacker;

  before(async () => {
    //Arrange
    [deployer, user, attacker] = await ethers.getSigners();

    const StoreFactory = await ethers.getContractFactory(
      "SafeEtherStore2",
      deployer
    );
    scStore = await StoreFactory.deploy();

    const AttackerFactory = await ethers.getContractFactory("Attack", attacker);
    scAttacker = await AttackerFactory.deploy(scStore.target);

    //Act
    await scStore.deposit({ value: parseEther("100") });
    await scStore.connect(user).deposit({ value: parseEther("100") });
  });

  it("Initial balance should be ok", async function () {
    //Assert
    let balance = await scStore.getBalance();
    expect(balance).to.equal(parseEther("200"));
  });

  it("Attack should fail", async function () {
    //Act
    await scAttacker.connect(attacker);
    await scStore.connect(attacker);
    let balance_instance_0 = await ethers.provider.getBalance(attacker.address);
    console.log("\n_BEFORE");

    console.log(
      `Attacker's balance: ${formatEther(
        await ethers.provider.getBalance(attacker.address)
      ).toString()}`
    );

    console.log(
      `SC Store's balance: ${formatEther(
        await scStore.getBalance()
      ).toString()}`
    );

    //Assert
    await scAttacker.attack({ value: parseEther("1") });
    let balance_instance_1 = await ethers.provider.getBalance(attacker.address);
    expect(balance_instance_1).not.greaterThan(balance_instance_0 + 1n);

    console.log("\n_AFTER");
    console.log(
      `Attacker's balance: ${formatEther(
        await ethers.provider.getBalance(attacker.address)
      ).toString()}`
    );

    console.log(
      `SC Store's balance: ${formatEther(
        await scStore.getBalance()
      ).toString()}`
    );
  });
});
